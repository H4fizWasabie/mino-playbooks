#!/bin/bash
# gmail-daily-cleanup — deterministic script pilot (SCR-001, #272).
# Contract (stage 01-cleanup): scan once for up to 20 inbox promotional
# messages older than 30 days, trash them by exact ID, log the IDs, notify
# the owner exactly once. Every side-effecting step goes through `mino exec` so
# it lands in tool_calls + audit like any loop call. Secrets never appear
# here — the binary resolves them internally.
set -uo pipefail

MINO=/usr/local/bin/mino
PB=/home/mino/.mino/playbooks/gmail-daily-cleanup

# The runner writes state.json into runs/<id>/ before spawning us, so the
# newest run dir is this run (one script run per playbook at a time — the
# SCH-002 per-name mutex guarantees it).
RUN_DIR=$(ls -1dt "$PB"/runs/*/ 2>/dev/null | head -1)
OUT_DIR="$RUN_DIR/stages/01-cleanup/output"
OUT="$OUT_DIR/cleanup-log.md"
mkdir -p "$OUT_DIR"

BEFORE=$(date -u -d '30 days ago' +%Y/%m/%d)
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

notify() { # $1 = digest; synthesized by compose_message (SCR-002), fallback to digest
  local m
  m=$(compose "$1") || m="$1"
  "$MINO" exec send_message "$(jq -nc --arg t "$m" '{message: $t, to: "the owner"}')" >/dev/null 2>&1 || {
    echo "WARN: notify delivery failed (send_message exec exited non-zero)" >> "$OUT"
    return 1
  }
}

fail() { # $1 = reason — log + notify once, then exit 1 (runner pages too)
  printf '## Error\n\n%s\n' "$1" >> "$OUT"
  notify "Gmail cleanup FAILED: $1"
  echo "ERROR: $1"
  exit 1
}
compose() { # $1 = digest -> synthesized message (SCR-002); empty on failure
  local m
  m=$("$MINO" exec compose_message "$(jq -nc --arg d "$1" '{digest: $d}')" 2>/dev/null) || return 1
  case "$m" in Error:*) return 1 ;; esac
  printf '%s' "$m"
}


# --- 1. Scan once: promotional inbox messages older than 30 days (≤20) ---
fetch_args=$(jq -nc --arg q "in:inbox category:promotions before:$BEFORE" \
  '{arguments_json: ({query: $q, max_results: 20, ids_only: true} | tostring), tool_slug: "GMAIL_FETCH_EMAILS"}')
fetch_out=$("$MINO" exec MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT "$fetch_args") ||
  fail "fetch tool call failed (exit $?)"

ok=$(printf '%s' "$fetch_out" | jq -r '.data.results[0].response.successful // false')
[ "$ok" = "true" ] || fail "fetch response unsuccessful"

# Defensive extraction (SCR-001 fix): composio GMAIL_FETCH_EMAILS keys the
# messages under `data_preview` (each message has a messageId field), not
# `data`. Older/alternate shapes may use `data.messages`. Prefer an explicit
# messageId; fall back to the last segment of display_url (<...>/#inbox/<id>).
# Bounded to the contract's 20.
ids=$(printf '%s' "$fetch_out" |
  jq -r '[.data.results[].response |
    (if ((.data.messages // []) | length) > 0
       then .data.messages
       else (.data_preview.messages // []) end)[]
  ] | map(select(type == "object") | .messageId // (.display_url | split("/") | last) // empty) | .[]' 2>/dev/null |
  head -20)

if [ -z "$ids" ]; then
  printf '# Gmail Daily Cleanup Log\n\n**Executed:** %s\n\nNothing to trash today (no matches).\n' "$NOW" > "$OUT"
  cat "$OUT"
  notify "Gmail cleanup: no promotional emails matched the cleanup query today."
  exit 0
fi

# --- 2. Batch modify: exact IDs → TRASH, remove from INBOX ---
ids_json=$(printf '%s\n' "$ids" | jq -R . | jq -s .)
batch_args=$(jq -nc --argjson ids "$ids_json" \
  '{arguments_json: ({ids: $ids, addLabelIds: ["TRASH"], removeLabelIds: ["INBOX"]} | tostring), tool_slug: "GMAIL_BATCH_MODIFY_MESSAGES"}')
batch_out=$("$MINO" exec MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT "$batch_args") ||
  fail "batch modify tool call failed (exit $?)"

# --- 3. Durable log (mirrors the LLM log shape, exact path) ---
n=$(printf '%s\n' "$ids" | wc -l)
{
  cat <<EOF
# Gmail Daily Cleanup Log

**Run:** script-backed (deterministic pilot)
**Executed:** $NOW
**Query:** \`in:inbox category:promotions before:$BEFORE\`
**Rule:** Promotional inbox messages older than 30 days → TRASH

## Summary

| Metric | Value |
| --- | --- |
| Messages trashed | $n |
| Batch modify result | $(printf '%s' "$batch_out" | jq -r '.data.results[0].response.message // "accepted"' 2>/dev/null) |

## Trashed Message IDs ($n)

EOF
  printf '%s\n' "$ids" | nl -w2 -s'. '
} > "$OUT"
cat "$OUT" # stdout → script-output.txt record

# --- 4. Telegram report, exactly once ---
notify "Gmail cleanup: trashed $n promotional email(s) older than 30 days. Log: $OUT. Batch result: $batch_out"
exit 0
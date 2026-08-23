#!/bin/bash
# weekly-cost — stage 01-mechanical (issue #304 runner).
# Computes raw report data ONLY. Zero inference. No notify.
# The 02-synthesize stage handles compose_message + send_message.
#
# #304 runner contract: cwd = runs/<id>/stages/01-mechanical, so relative
# paths (output/, ../01-mechanical/) resolve inside the run record. Never
# guess the run dir from the filesystem — $PWD is authoritative.
set -uo pipefail

HOME_DIR=/home/mino/.mino
OUT_DIR="$PWD/output"
OUT="$OUT_DIR/raw-cost.md"
mkdir -p "$OUT_DIR"

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# --- 0. Day gate: authoritative local date (Asia/Kuala_Lumpur) ---
# Non-Sunday writes the skip artifact (the runner's output check needs the
# declared file to exist) and exits 0. WEEKLY_COST_FORCE=1 overrides for tests.
DOW=$(TZ=Asia/Kuala_Lumpur date +%u)
if [ "${WEEKLY_COST_FORCE:-0}" != "1" ] && [ "$DOW" != "7" ]; then
  printf '# Weekly Cost + Output Report\n\nGenerated: %s (KUL dow %s)\n\nSkipped: not Sunday\n' "$NOW" "$DOW" > "$OUT"
  cat "$OUT"
  exit 0
fi

# --- 1. Usage (the contract's aggregation, bounded tail) ---
USAGE=$(tail -200000 "$HOME_DIR/usage.jsonl" 2>/dev/null |
  jq -s '[.[] | select(.ts >= (now - 7*86400 | todateiso8601)) |
    {m: .model, c: (.cost_usd // 0), i: (.in // 0), o: (.out // 0)}] |
    group_by(.m) | map({model: .[0].m, calls: length, in: (map(.i)|add),
    out: (map(.o)|add), cost: (map(.c)|add)})' 2>/dev/null)
if [ -z "$USAGE" ]; then
  printf '# Weekly Cost + Output Report\n\n**Error:** usage.jsonl unreadable or empty.\n' > "$OUT"
  cat "$OUT"
  exit 1
fi

TOTAL=$(printf '%s' "$USAGE" | jq '[.[] | .cost] | add')
UNCOSTED=$(printf '%s' "$USAGE" | jq '[.[] | select(.cost == 0)] | length')

# --- 2. Outputs: completed logs per playbook, last 7 days ---
POSTS=$(find "$HOME_DIR/playbooks" -path '*/runs/*/stages/*/output/*.md' -newermt '7 days ago' 2>/dev/null |
  awk -F/ '{print $(NF-6)}' | sort | uniq -c | sort -rn)

# --- 3. Schedule errors still set (schedules.json may be parked — tolerate) ---
SCHED_ERR=$(jq -r '[.[]? | select(.last_error != null and .last_error != "") | "\(.name): \(.last_error)"] | .[]' "$HOME_DIR/schedules.json" 2>/dev/null)

# --- 4. Raw report (data only — no Telegram) ---
{
  echo "# Weekly Cost + Output Report"
  echo
  echo "Generated: $NOW (KUL)"
  echo
  echo "## Spend (per model, 7 days)"
  echo
  printf '%s' "$USAGE" | jq -r 'sort_by(-.cost) | .[] |
    "| \(.model) | \(.calls) | \(.in|tostring) | \(.out|tostring) | \(.cost) |"' |
    awk -F'|' 'BEGIN{print "| Model | Calls | In tok | Out tok | Cost |"; print "| --- | --- | --- | --- | --- |"}
      {gsub(/^ +| +$/, "", $2); gsub(/^ +| +$/, "", $3); gsub(/^ +| +$/, "", $4); gsub(/^ +| +$/, "", $5); gsub(/^ +| +$/, "", $6);
       printf "| %s | %s | %s | %s | %s |\n", $2, $3, $4, $5, $6}'
  echo
  printf '**Total recorded cost (7 days):** $%.4f USD (%s models with no recorded cost_usd).\n' "$TOTAL" "$UNCOSTED"
  [ "$UNCOSTED" != "0" ] && echo "⚠ Honest note: models without cost_usd make true spend higher than recorded."
  echo
  echo "## Output (published posts, 7 days)"
  echo
  echo "| Playbook | Outputs |"
  echo "| --- | --- |"
  if [ -n "$POSTS" ]; then
    printf '%s\n' "$POSTS" | awk '{printf "| %s | %s |\n", $2, $1}'
  else
    echo "| (none) | 0 |"
  fi
  echo
  echo "## Issues"
  if [ -n "$SCHED_ERR" ]; then
    printf '%s\n' "$SCHED_ERR" | sed 's/^/- /'
  else
    echo "- None (no schedule last_error set)."
  fi
} > "$OUT"
cat "$OUT"
exit 0
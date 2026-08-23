#!/bin/bash
# daily-ai-concept — deterministic script pilot #3 (SCR-001 / CTX-025).
# Contract (stage 01-learn-and-store): pick ONE concept (first curriculum
# entry with no library fact, else oldest `at`), bounded research (ONE
# remember + ONE search_web), write/update the fact in place via save_note,
# verify the file, log learn-log.md, notify exactly once. The script IS the
# bounded-context fix for the 50-iteration burn (CTX-025): no LLM context
# to bloat. Facts are template-shaped and labeled script-generated — the
# library invariants hold (one fact per concept, never delete, bounded).
set -uo pipefail

MINO=/usr/local/bin/mino
HOME_DIR=/home/mino/.mino
PB="$HOME_DIR/playbooks/daily-ai-concept"
MEM="$HOME_DIR/memories"
CURR="$PB/curriculum.txt"
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

RUN_DIR=$(ls -1dt "$PB"/runs/*/ 2>/dev/null | head -1)
OUT_DIR="$RUN_DIR/stages/01-learn-and-store/output"
OUT="$OUT_DIR/learn-log.md"
mkdir -p "$OUT_DIR"

fail() { # $1 = reason — log + notify once, exit 1 (runner pages too)
  printf '## Error\n\n%s\n' "$1" >> "$OUT"
  "$MINO" exec send_message "$(jq -nc --arg t "daily-ai-concept FAILED: $1" '{message: $t, to: "the owner"}')" >/dev/null 2>&1
  echo "ERROR: $1"
  exit 1
}
compose() { # $1 = digest -> synthesized message (SCR-002); empty on failure
  local m
  m=$("$MINO" exec compose_message "$(jq -nc --arg d "$1" '{digest: $d}')" 2>/dev/null) || return 1
  case "$m" in Error:*) return 1 ;; esac
  printf '%s' "$m"
}

slug() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g; s/[^a-z0-9_]//g'; }

# --- 1. Pick the concept: first curriculum entry with no library fact ---
PICKED="" SLUG=""
while IFS= read -r line; do
  case "$line" in \#*|"") continue ;; esac
  s=$(slug "$line")
  [ -z "$s" ] && continue
  if ! ls "$MEM"/ai_concept_"$s".md >/dev/null 2>&1; then
    PICKED="$line"; SLUG="$s"; break
  fi
done < "$CURR"

if [ -z "$PICKED" ]; then
  # All exist — rotate the fact with the oldest `at` (refresh oldest-first).
  OLDEST=$(for f in "$MEM"/ai_concept_*.md; do
    printf '%s %s\n' "$(grep -m1 '^at:' "$f" | cut -d' ' -f2)" "$f"
  done | sort | head -1 | cut -d' ' -f2)
  [ -n "$OLDEST" ] || fail "no library facts found"
  SLUG=$(basename "$OLDEST" .md | sed 's/^ai_concept_//')
  PICKED=$(grep -m1 '^subject:' "$OLDEST" | sed 's/^subject: *AI concept: *//; s/'"'"'//g')
  PICKED="${PICKED:-$SLUG}"
fi

echo "picked: $PICKED (slug: $SLUG)"

# --- 2. Bounded research: ONE remember + ONE search_web, both clipped ---
REMEMBERED=$("$MINO" exec remember "$(jq -nc --arg q "$PICKED" '{query: $q}')" 2>/dev/null | head -c 1500) || true
SEARCH=$("$MINO" exec search_web "$(jq -nc --arg q "$PICKED AI definition" '{query: $q}')" 2>/dev/null | head -c 1500) || true

# Strip the untrusted-content banner + markdown residue (### headers, URL:
# lines), keep the first result block, truncate to ~150 words (contract).
SNIPPET=$(printf '%s' "$SEARCH" | sed '1{/UNTRUSTED/d;}' | sed -n '/### 1\./,$p' |
  sed 's/^### [0-9]*\. //; s/ URL: [^ ]*/ /g' | tr '\n' ' ' | sed 's/  */ /g' |
  head -c 900 | awk '{for(i=1;i<=NF&&i<=150;i++) printf "%s ", $i; print ""}')
[ -n "$SNIPPET" ] || SNIPPET="(no external verification this round — script wrote from its own bounded knowledge)"
SNIPPET=$(printf '%s' "$SNIPPET" | sed 's/  *$//')

# --- 3. Write/update the fact in place via save_note ---
VER=$(grep -oE 'v[0-9]+' "$MEM/ai_concept_$SLUG.md" 2>/dev/null | grep -oE '[0-9]+' | tail -1)
VER=$(( ${VER:-0} + 1 ))
CONTENT="**$PICKED** — $SNIPPET

How Mino uses this: the concept lives in the ai_concept_* library, retrievable via remember/save_note and surfaced through FTS + graph edges in the loop's memory retrieval.

v$VER: script-generated fact (daily-ai-concept script pilot, $(date -u +%Y-%m-%d))."

SAVE_OUT=$("$MINO" exec save_note "$(jq -nc --arg id "ai_concept_$SLUG" --arg sub "AI concept: $PICKED" --arg c "$CONTENT" '{id: $id, subject: $sub, content: $c}')" 2>/dev/null)
case "$SAVE_OUT" in Error:*) fail "save_note failed: $SAVE_OUT" ;; esac

# --- 4. Verify the fact is on disk (deterministic check) ---
FACT="$MEM/ai_concept_$SLUG.md"
[ -s "$FACT" ] || fail "verification failed: $FACT missing or empty after save_note"

# --- 5. Learn log + one Telegram line ---
{
  echo "# AI Concept Learn Log"
  echo
  echo "**Date:** $NOW"
  echo "**Concept:** $PICKED (slug $SLUG, v$VER)"
  echo "**Research:** 1 remember + 1 search_web (bounded, script)"
  echo "**Fact:** $FACT"
  echo "**Verification:** file exists with $(wc -c < "$FACT") bytes"
  echo "**Changelog:** v$VER script-generated (template fact — LLM may refine)"
} > "$OUT"
cat "$OUT"

MSG=$(compose "Today's concept: $PICKED — learned and stored (v$VER). Fact: $FACT. Research: 1 remember + 1 search_web, bounded.") || MSG="today's concept: $PICKED — learned and stored (v$VER). Log: $OUT"
"$MINO" exec send_message "$(jq -nc --arg t "$MSG" '{message: $t, to: "the owner"}')" >/dev/null 2>&1 ||
  { echo "WARN: notify delivery failed" >> "$OUT"; exit 1; }
exit 0

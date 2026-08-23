#!/bin/bash
# morning-briefing — deterministic script pilot #4 (SCR-001).
# Gather facts via tools (never guess), compose a tight template brief,
# send once, write output with the message verbatim.
set -uo pipefail

MINO=/usr/local/bin/mino
HOME_DIR=/home/mino/.mino
PB="$HOME_DIR/playbooks/morning-briefing"
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

RUN_DIR=$(ls -1dt "$PB"/runs/*/ 2>/dev/null | head -1)
OUT_DIR="$RUN_DIR/stages/01-brief/output"
OUT="$OUT_DIR/morning-brief.md"
mkdir -p "$OUT_DIR"

fail() {
  printf '## Error\n\n%s\n' "$1" >> "$OUT"
  "$MINO" exec send_message "$(jq -nc --arg t "morning-briefing FAILED: $1" '{message: $t, to: "the owner"}')" >/dev/null 2>&1
  echo "ERROR: $1"
  exit 1
}
compose() { # $1 = digest -> synthesized message (SCR-002); empty on failure
  local m
  m=$("$MINO" exec compose_message "$(jq -nc --arg d "$1" '{digest: $d}')" 2>/dev/null) || return 1
  case "$m" in Error:*) return 1 ;; esac
  printf '%s' "$m"
}

# --- Gather (tools, never guess) ---
REMS=$("$MINO" exec list_reminders '{}' 2>/dev/null | head -c 900)
MEM=$("$MINO" exec manage_memory '{"action":"status"}' 2>/dev/null | head -c 400)
RESP=$(sqlite3 "$HOME_DIR/state.db" "SELECT status, substr(next_action,1,60) FROM responsibilities WHERE status IN ('blocked','needs_you','working') ORDER BY updated_at DESC LIMIT 8;" 2>/dev/null)
SCHED=$(jq -r '.[] | [.name, .time] | @tsv' "$HOME_DIR/schedules.json" 2>/dev/null | tr '\n' '; ')
YESTERDAY=$(date -u -d yesterday +%Y%m%d)
POSTS=$(find "$HOME_DIR/playbooks" -path "*/runs/$YESTERDAY*/stages/*/output/*.md" 2>/dev/null |
  while read -r f; do grep -m1 '^# \|^## \|^### ' "$f" 2>/dev/null | head -1 | sed 's/^#* *//'; done |
  grep -v '^$' | head -8)

# --- Compose (template; compose_message tool upgrades this later, SCR-002) ---
MSG="🌅 Overnight: $(if [ -n "$POSTS" ]; then printf '%s' "$POSTS" | tr '\n' '; '; else echo "no posts published"; fi)
⏰ Reminders: $(printf '%s' "$REMS" | tr '\n' ' ' | head -c 400)
🧠 Memory: $(printf '%s' "$MEM" | tr '\n' ' ' | head -c 200)
⚠️ Needs attention: $(if [ -n "$RESP" ]; then printf '%s' "$RESP" | tr '\n' '; '; else echo "none"; fi)
📅 Today: ${SCHED:-none scheduled}"

# --- Send once + write output verbatim ---
MSG=$(compose "$MSG") || MSG="$MSG"
"$MINO" exec send_message "$(jq -nc --arg t "$MSG" '{message: $t, to: "the owner"}')" >/dev/null 2>&1 ||
  { echo "WARN: notify delivery failed" >> "$OUT"; exit 1; }
printf '%s\n' "$MSG" > "$OUT"
cat "$OUT"
exit 0

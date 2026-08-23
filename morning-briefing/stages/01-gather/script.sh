#!/bin/bash
# morning-briefing — stage 01-gather (issue #304 runner).
# Gathers the morning facts deterministically: reminders, memory status,
# blocked/needs-you responsibilities, today's schedule, yesterday's post
# titles. Zero inference. The 02-synthesize stage composes the brief.
#
# #304 runner: cwd = runs/<id>/stages/01-gather. OUTPUT = $PWD/output/facts.md
set -uo pipefail

HOME_DIR=/home/mino/.mino
DB="$HOME_DIR/state.db"
OUT_DIR="$PWD/output"
OUT="$OUT_DIR/facts.md"
mkdir -p "$OUT_DIR"

NOW=$(TZ=Asia/Kuala_Lumpur date +%Y-%m-%d)
YDAY=$(TZ=Asia/Kuala_Lumpur date -d 'yesterday' +%Y-%m-%d)

# Memory graph status: count facts + edges from the graph tables.
FACTS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM facts;" 2>/dev/null || echo "?")
EDGES=$(sqlite3 "$DB" "SELECT COUNT(*) FROM edges;" 2>/dev/null || echo "?")

{
  echo "# Morning Facts — $NOW"
  echo

  echo "## Reminders (pending, nearest 3)"
  sqlite3 -separator ' | ' "$DB" "SELECT message, remind_at FROM reminders WHERE status='pending' ORDER BY remind_at LIMIT 3;" 2>/dev/null |
    sed 's/^/- /' || echo "- (none)"

  echo
  echo "## Memory graph (facts=$FACTS, edges=$EDGES)"

  echo
  echo "## Needs attention (blocked/needs_you/working, top 8)"
  sqlite3 -separator ' | ' "$DB" "SELECT id, status, next_action FROM responsibilities WHERE status IN ('blocked','needs_you','working') ORDER BY updated_at DESC LIMIT 8;" 2>/dev/null |
    sed 's/^/-  /' || echo "- none"

  echo
  echo "## Today's schedule"
  if [ -f "$HOME_DIR/schedules.json" ]; then
    cat "$HOME_DIR/schedules.json" | jq -r '.[] | "\(.time)  \(.name)"' 2>/dev/null | sort | sed 's/^/-  /'
  else
    echo "- (no schedules.json — parked)"
  fi

  echo
  echo "## Yesterday's published posts ($YDAY)"
  FOUND=0
  while read -r f; do
    title=$(grep -m1 '^# ' "$f" 2>/dev/null | sed 's/^# //')
    if [ -n "$title" ]; then
      echo "-  $title"
      FOUND=1
    fi
  done < <(find "$HOME_DIR/playbooks" -path "*/output/*.md" -newermt "$YDAY 00:00" ! -newermt "$NOW 00:00" 2>/dev/null | head -8)
  [ "$FOUND" = "0" ] && echo "- (none found)"
} > "$OUT"

cat "$OUT"
exit 0
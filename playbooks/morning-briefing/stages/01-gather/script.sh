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
DOW=$(TZ=Asia/Kuala_Lumpur date +%A | tr '[:upper:]' '[:lower:]')

# Memory graph status: the graph lives in memories/*.md (schema v7 removed the
# SQLite facts table). Facts = live fact files; edges = edge blocks' target
# entries (4-space indented YAML). Close to the Go count (a file Go skips on
# parse can shift it by a few edges — informational only).
FACTS=$(find "$HOME_DIR/memories" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l)
EDGES=$(grep -h '^    - target:' "$HOME_DIR/memories"/*.md 2>/dev/null | wc -l)

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
    # Day-gate: entries with a days list only run on those weekdays (lowercase).
    cat "$HOME_DIR/schedules.json" | jq -r --arg dow "$DOW" '.[] | select((.days // []) | length == 0 or index($dow)) | "\(.time)  \(.name)"' 2>/dev/null | sort | sed 's/^/-  /'
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
  done < <(find "$HOME_DIR/playbooks" -path '*/output/*.md' -newermt "$YDAY 00:00" ! -newermt "$NOW 00:00" 2>/dev/null | head -8)
  [ "$FOUND" = "0" ] && echo "- (none found)"
} > "$OUT"

cat "$OUT"
exit 0

#!/bin/bash
# malaysian-news-daily — deterministic script pilot #5 (SCR-001).
# Five categories, exactly ONE search each (no rescue searches in script
# mode — bounded by construction), first verified URL per category wins,
# fallback labels unverified categories, publish to FB page YOUR_PAGE_ID
# via composio (exact slug FACEBOOK_CREATE_POST, never retry a non-idempotent
# publish), Telegram in the contract's literal format, output report.
set -uo pipefail

MINO=/usr/local/bin/mino
HOME_DIR=/home/mino/.mino
PB="$HOME_DIR/playbooks/malaysian-news-daily"
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

RUN_DIR=$(ls -1dt "$PB"/runs/*/ 2>/dev/null | head -1)
OUT_DIR="$RUN_DIR/stages/01-news/output"
OUT="$OUT_DIR/malaysian-news-report.md"
mkdir -p "$OUT_DIR"

fail() {
  printf '## Error\n\n%s\n' "$1" >> "$OUT"
  "$MINO" exec send_message "$(jq -nc --arg t "malaysian-news-daily FAILED: $1" '{message: $t, to: "the owner"}')" >/dev/null 2>&1
  echo "ERROR: $1"
  exit 1
}
compose() { # $1 = digest -> synthesized message (SCR-002); empty on failure
  local m
  m=$("$MINO" exec compose_message "$(jq -nc --arg d "$1" '{digest: $d}')" 2>/dev/null) || return 1
  case "$m" in Error:*) return 1 ;; esac
  printf '%s' "$m"
}

# Prior-report exclusion: URL + first-title-words already used → skip.
PRIOR=$(ls -1t "$PB"/runs/*/stages/*/output/malaysian-news-report.md 2>/dev/null | head -1)
[ -n "$PRIOR" ] && PRIOR_TEXT=$(cat "$PRIOR") || PRIOR_TEXT=""

used() { # $1 = url, $2 = title
  printf '%s' "$PRIOR_TEXT" | grep -qF "$1" && return 0
  [ -n "$2" ] && printf '%s' "$PRIOR_TEXT" | grep -qiF "$(printf '%s' "$2" | cut -d' ' -f1-4)" && return 0
  return 1
}

CATS="politics sports entertainment disasters viral"
: > /tmp/mn_cats.txt
for CAT in $CATS; do
  R=$("$MINO" exec search_web "$(jq -nc --arg q "Malaysia $CAT news today" '{query: $q}')" 2>/dev/null | head -c 2000)
  TITLE=$(printf '%s' "$R" | grep -m1 '^### ' | sed 's/^### [0-9]*\. //; s/ URL:.*//' | sed 's/^ *//;s/ *$//')
  URL=$(printf '%s' "$R" | grep -m1 -oE 'https?://[^ )]+' | head -1)
  if [ -n "$TITLE" ] && [ -n "$URL" ] && ! used "$URL" "$TITLE"; then
    printf '%s\t%s\t%s\n' "$CAT" "$TITLE" "$URL" >> /tmp/mn_cats.txt
  else
    printf '%s\tNO-STORY\t\n' "$CAT" >> /tmp/mn_cats.txt
  fi
done

# --- Compose FB caption: VERIFIED categories only, omit fallbacks ---
CAPTION=$(printf 'Malaysian roundup for %s.\n\n' "$(date -u +%A, %d %B %Y)")
while IFS=$'\t' read -r cat title url; do
  [ "$title" = "NO-STORY" ] && continue
  CAPTION+=$(printf '%s — %s (%s)\n' "$cat" "$title" "$url")
done < /tmp/mn_cats.txt

# --- Publish once, never retry ---
PBARGS=$(jq -nc --arg m "$CAPTION" '{arguments_json: ({message: $m, pageId: "YOUR_PAGE_ID", published: true} | tostring), tool_slug: "FACEBOOK_CREATE_POST"}')
PBOUT=$("$MINO" exec MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT "$PBARGS" 2>/dev/null)
case "$PBOUT" in Error:*) fail "FB publish failed: $PBOUT" ;; esac
POST_ID=$(printf '%s' "$PBOUT" | grep -oE '"id":"[0-9_]+"' | head -1 | sed 's/"id":"//; s/"//')
[ -n "$POST_ID" ] || POST_ID="(not captured: $(printf '%s' "$PBOUT" | head -c 120))"

# --- Telegram: contract's literal format, single spaces, no raw breaks ---
TLINE=$(printf '%s' "$CAPTION" | tr '\n' ' ' | sed 's/  */ /g' | head -c 600)
MSG=$(printf 'Malaysian roundup for %s. %s. FB Post ID: %s' "$(date -u +%A, %d %B %Y)" "$TLINE" "$POST_ID" | head -c 900)
MSG=$(compose "Malaysian roundup published to Facebook. Post ID: $POST_ID. Caption: $TLINE") || MSG="$MSG"
"$MINO" exec send_message "$(jq -nc --arg t "$MSG" '{message: $t, to: "the owner"}')" >/dev/null 2>&1 ||
  { echo "WARN: notify delivery failed" >> "$OUT"; exit 1; }

# --- Output report ---
{
  echo "# Malaysian News Report"
  echo
  echo "**Date:** $NOW"
  echo "**FB post ID:** $POST_ID"
  echo
  echo "## Categories"
  while IFS=$'\t' read -r cat title url; do
    if [ "$title" = "NO-STORY" ]; then
      echo "- **$cat**: No suitable verified story found today"
    else
      echo "- **$cat**: $title — $url"
    fi
  done < /tmp/mn_cats.txt
  echo
  echo "## Caption posted"
  echo
  printf '%s\n' "$CAPTION"
} > "$OUT"
cat "$OUT"
exit 0

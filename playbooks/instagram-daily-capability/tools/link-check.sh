#!/usr/bin/env bash
# Routing health check — two directions, one script.
#
# 1. LINK CHECK (docs -> disk): every path referenced in routing docs must
#    exist. Scope: root AGENTS.md, root CONTEXT.md, and every nested
#    CONTEXT.md. A reference passes if it resolves relative to the doc's own
#    directory OR to the workspace root. Template-style tokens ({...},
#    <...>, XXXX, globs), ellipsis-style descriptive tokens, and URLs are
#    skipped — they are runtime-resolved or prose, not static references.
#
# 2. ORPHAN CHECK (disk -> docs): every non-runtime file must be reachable
#    from some routing doc. Catches "new capability folder added but never
#    wired into AGENTS.md routing" — the silent dead-zone failure. Runtime
#    content (see ALLOWLIST below) is exempt: outputs, logs, drafts, queues
#    are supposed to exist without being named in routing docs.
#
# Interpretation:
#   - MISSING reference under an output/ folder → normal before the first run.
#   - MISSING sibling (../...) path  → the other workspace moved; flag to user.
#   - MISSING anything else          → routing drift: fix the DOC, not the file.
#   - ORPHAN file                    → wire it into routing (AGENTS.md/CONTEXT.md),
#                                      or move it under a runtime folder.
#   - Never create placeholder files to silence either check.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

docs=(AGENTS.md)
[ -f CONTEXT.md ] && docs+=(CONTEXT.md)
while IFS= read -r -d '' f; do docs+=("$f"); done < <(find . -name CONTEXT.md -not -path './tools/*' -print0 | sort -z)

missing=0; orphans=0; checked=0

declare -A referenced=() is_routing_doc=()
for d in "${docs[@]}"; do is_routing_doc["$(realpath "$d")"]=1; done

# --- Phase 1: link check (docs -> disk) -------------------------------------
for doc in "${docs[@]}"; do
  dir="$(dirname "$doc")"
  while IFS= read -r tok; do
    [ -z "$tok" ] && continue
    # Mino resolves stage output paths inside the active run at execution
    # time; they are not definition-time links.
    [[ "$tok" == output/* || "$tok" == ../*/output/* ]] && continue
    # Runtime examples and external Mino paths are validated by the harness,
    # not by this workspace-local routing check.
    [[ "$tok" == /home/mino/images/instagram-YYYY-MM-DD.jpg || "$tok" == chmod\ * || "$tok" == image/jpeg || "$tok" == Content-Type:* || "$tok" == "~/.mino/playbooks/shared/platform-rules.md" ]] && continue
    checked=$((checked+1))
    if [[ -e "$dir/$tok" ]]; then
      referenced["$(realpath "$dir/$tok")"]=1
    elif [[ -e "$tok" ]]; then
      referenced["$(realpath "$tok")"]=1
    else
      echo "MISSING   [$doc]  $tok"
      missing=$((missing+1))
    fi
  done < <(
    grep -ohE '`[^`]+`' "$doc" 2>/dev/null \
      | tr -d '`' \
      | grep -E '/|\.md$|\.json$' \
      | grep -vE 'XXXX|[{}<>*]|\.\.\.|https?://' \
      | sort -u
  )
done

# --- Phase 2: orphan check (disk -> docs) ------------------------------------
# Runtime folders whose contents are workflow-generated and exempt from
# routing. Extend this list when the workflow gains new runtime folders.
ALLOW_RE='(^|/)(output|runs|logs|drafts|approved|published|queue|responses|calendar|tools)/'

while IFS= read -r -d '' f; do
  rel="${f#./}"
  [[ "$rel" == .* ]] && continue                       # hidden files
  if [[ "$rel" =~ $ALLOW_RE ]]; then continue; fi      # runtime content
  abs="$(realpath "$f")"
  [[ -n "${is_routing_doc[$abs]:-}" ]] && continue      # routing docs are reachable by definition
  if [[ -n "${referenced[$abs]:-}" ]]; then continue; fi
  echo "ORPHAN    $rel  (not reachable from any routing doc)"
  orphans=$((orphans+1))
done < <(find . -type f -print0 | sort -z)

# --- Verdict ------------------------------------------------------------------
if (( missing || orphans )); then
  (( missing )) && echo "Link drift: $missing of $checked references missing (${#docs[@]} docs scanned)."
  (( orphans )) && echo "Orphan drift: $orphans file(s) unreachable from routing."
  echo "Fix the routing docs, not the files — unless it is a pending output/ folder."
  exit 1
fi
echo "Routing health OK: $checked references verified, no orphans, ${#docs[@]} routing docs scanned."

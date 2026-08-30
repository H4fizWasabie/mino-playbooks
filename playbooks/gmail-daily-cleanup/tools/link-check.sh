#!/usr/bin/env bash
# Playbook routing health check — adapted from the Ascencio workspace
# link-check. Two directions, one script.
#
# 1. LINK CHECK (docs -> disk): every path referenced in routing docs must
#    resolve. Scope: root CONTEXT.md, config.md, persona/CONTEXT.md, and every
#    stage CONTEXT.md. Skipped tokens (runtime-resolved or prose, not static
#    references): template tokens (NN-name, YYYY..., <run-id>, {...}, globs),
#    ellipsis tokens, URLs, MIME types, command snippets (tokens with spaces),
#    bare relative filenames (shorthand prose, e.g. `candidates.md`), and
#    runtime paths (runs/, output/, references/, ../ stage handoffs, Mino
#    runtime state under ~/.mino: data/, logs/, traces/, schedules.json,
#    usage.jsonl, state.db).
#
# 2. ORPHAN CHECK (disk -> docs): every non-runtime file must be reachable
#    from some routing doc. ALLOWLIST exempts runtime content: run state,
#    outputs, logs, and script.sh (mechanical stages execute via the harness,
#    reachable through their stage CONTEXT.md).
#
# Interpretation:
#   - MISSING a runtime/template token → expected, not a defect.
#   - MISSING an absolute path → that resource moved; fix the DOC.
#   - MISSING anything else    → routing drift: fix the DOC, not the file.
#   - ORPHAN file              → wire it into routing, or move it under a
#                                runtime folder (runs/, output/).
#   - Never create placeholder files to silence either check.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

declare -a docs=()
add_doc() { local rp; rp="$(realpath "$1")"; [[ -n "${seen[$rp]:-}" ]] && return; seen[$rp]=1; docs+=("$1"); }
declare -A seen=()
add_doc CONTEXT.md
[ -f config.md ] && add_doc config.md
while IFS= read -r -d '' f; do add_doc "$f"; done < <(find . -name CONTEXT.md -not -path './tools/*' -not -path './runs/*' -print0 | sort -z)

missing=0; orphans=0; checked=0

declare -A referenced=() is_routing_doc=()
for d in "${docs[@]}"; do is_routing_doc["$(realpath "$d")"]=1; done

# --- Phase 1: link check (docs -> disk) -------------------------------------
for doc in "${docs[@]}"; do
  dir="$(dirname "$doc")"
  while IFS= read -r tok; do
    [ -z "$tok" ] && continue
    checked=$((checked+1))
    if [[ -e "$dir/$tok" ]]; then
      referenced["$(realpath "$dir/$tok")"]=1
    elif [[ -e "$tok" ]]; then
      referenced["$(realpath "$tok")"]=1
    elif [[ "$tok" == \~/* && -e "${tok/#\~//home/mino}" ]]; then
      referenced["$(realpath "${tok/#\~//home/mino}")"]=1
    else
      echo "MISSING   [$doc]  $tok"
      missing=$((missing+1))
    fi
  done < <(
    grep -ohE '`[^`]+`' "$doc" 2>/dev/null \
      | tr -d '`' \
      | grep -E '/|\.md$|\.json$' \
      | grep -vE 'XXXX|[{}<>*]|\.\.\.|https?://' \
      | grep -vE 'NN-name|YYYY|<run-id>' \
      | grep -vE '^[A-Za-z]+/[A-Za-z0-9.+-]+$' \
      | grep -vE '^[^/]+\.(md|json)$' \
      | grep -v ' ' \
      | grep -vE '^(output/|references/|\.\.?/|runs/)' \
      | grep -vE '^/home/mino/\.mino/(data/|logs/|traces/|schedules\.json|usage\.jsonl|state\.db|audit\.jsonl)' \
      | grep -vE '^/home/mino/images/' \
      | sort -u
  )
done

# --- Phase 2: orphan check (disk -> docs) ------------------------------------
# Runtime content exempt from routing. Extend when the playbook gains new
# runtime folders.
ALLOW_RE='(^|/)(runs|output|references|tools)/|/script\.sh$|\.bak'

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
  echo "Fix the routing docs, not the files — unless it is runtime content."
  exit 1
fi
echo "Routing health OK: $checked references verified, no orphans, ${#docs[@]} routing docs scanned."

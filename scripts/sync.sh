#!/usr/bin/env bash
# Sync the live VPS playbooks into this public repo (sanitized).
# Pulls source files only into playbooks/, re-runs sanitization, blocks on
# residual sensitive content, commits and pushes when something changed.
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH=/usr/local/bin:/usr/bin:/bin

# 1. Pull source files into playbooks/ (no runs/artifacts/backups).
# From a desktop: rsync over ssh from the VPS. On the VPS itself, set
# MINO_PLAYBOOKS_SRC to the local path so no ssh hop is needed.
SRC="${MINO_PLAYBOOKS_SRC:-vps:/home/mino/.mino/playbooks/}"
rsync -a --delete \
  --exclude 'runs/' --exclude 'output/' \
  --exclude '*.bak*' --exclude '.archive*' --exclude '.backup*' --exclude 'stages-bak*' \
  "$SRC" playbooks/

# 2. Sanitize (idempotent: already-sanitized values never match)
cd playbooks
grep -rl 'abah-personal' . | xargs -r sed -i 's/abah-personal/owner-account/g'
grep -rl 'u/H4fizWasabie' . | xargs -r sed -i 's|u/H4fizWasabie|u/your-handle|g'
grep -rl '89lab' . | xargs -r sed -i 's/89lab Facebook Page/the Facebook Page/g; s/89lab/the Page/g'
grep -rl '911623135577188' . | xargs -r sed -i 's/911623135577188/YOUR_PAGE_ID/g'
grep -rlw 'Abah' . | xargs -r sed -i 's/\bAbah\b/the owner/g'
grep -rl 'Facebook Page the Page' . | xargs -r sed -i 's/Facebook Page the Page/the Facebook Page/g'
cd ..

# 3. Residual scan — abort before anything sensitive reaches a public repo
BAD=$(grep -rniE 'abah|89lab|911623135577188|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{30,}|[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
  --include='*.md' --include='*.sh' --include='*.txt' playbooks/ || true)
if [ -n "$BAD" ]; then
  echo "BLOCKED: sensitive content found, not publishing:" >&2
  echo "$BAD" >&2
  exit 1
fi

# 4. Pull any external commits (autostash protects our dirty worktree),
# then commit + push if anything changed.
git pull --rebase --autostash origin main >/dev/null 2>&1 || echo "pull/rebase failed (check sync.log)"
git add -A
if ! git diff --cached --quiet; then
  git commit -m "sync playbooks from VPS ($(date -u +%Y-%m-%d))"
  git push
  echo "pushed $(date -u +%Y-%m-%dT%H:%M:%SZ)"
else
  echo "no changes"
fi

#!/usr/bin/env bash
set -euo pipefail
: "${GITHUB_REPOSITORY:?}"
if [[ "$GITHUB_REPOSITORY" != 'khant735/PCSX2-Developer-Edition' ]]; then
  echo 'Refusing unexpected target repository' >&2; exit 2
fi
git config user.name 'github-actions[bot]'
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
git remote add pcsx2-upstream https://github.com/PCSX2/pcsx2.git
git fetch --no-tags pcsx2-upstream master
git push origin FETCH_HEAD:refs/heads/upstream-master
git push origin FETCH_HEAD:refs/heads/developer
printf 'Imported upstream PCSX2 master at %s\n' "$(git rev-parse FETCH_HEAD)"

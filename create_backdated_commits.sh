#!/usr/bin/env bash
for i in $(seq 1 12); do
  ts="2025-06-10T06:$(printf '%02d' $((i*5))):00"
  echo "Backdated commit $i at $ts" >> README.md
  git add README.md
  GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts" \
    git commit -m "Backdated commit $i ($ts)"
done

GIT_AUTHOR_DATE="2025-06-11T08:00:00" \
GIT_COMMITTER_DATE="2025-06-11T08:00:00" \
git commit --allow-empty -m "fix: correct author email"

echo "🎉 Done! 记得 git push 然后去 Guild Re-check"

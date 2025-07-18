#!/usr/bin/env bash
for i in $(seq 0 11); do
  min=$(printf '%02d' $((i*5)))          # 00 05 10 … 55
  ts="2025-06-10T06:${min}:00"
  echo "Backdated commit $i at $ts" >> README.md
  git add README.md
  GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts" \
    git commit -m "Backdated commit $i ($ts)"
done

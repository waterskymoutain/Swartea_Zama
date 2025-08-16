#!/usr/bin/env bash

# Create 12 backdated commits at 5‑minute intervals.
#
# The original script started counting from 0 which produced commit messages
# like "Backdated commit 0" and was slightly confusing.  Additionally, using
# `i * 5` directly with `seq 1 12` would have produced an invalid "60" minute
# timestamp on the last iteration.  We now iterate from 1..12 and compute the
# minute offset based on `(i-1) * 5` to keep the timestamps valid while keeping
# commit numbers human‑friendly starting from 1.
for i in $(seq 1 12); do
  # 00 05 10 … 55
  min=$(printf '%02d' $(((i-1)*5)))
  ts="2025-06-10T06:${min}:00"
  echo "Backdated commit $i at $ts" >> README.md
  git add README.md
  GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts" \
    git commit -m "Backdated commit $i ($ts)"
done

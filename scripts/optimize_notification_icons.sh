#!/usr/bin/env bash
set -euo pipefail

RES_ROOT="android/app/src/main/res"
DENSITIES=(mdpi hdpi xhdpi xxhdpi xxxhdpi)

if ! command -v optipng >/dev/null 2>&1; then
  echo "::error::optipng is not installed or not on PATH"
  exit 1
fi

for density in "${DENSITIES[@]}"; do
  file="${RES_ROOT}/drawable-${density}/ic_notification.png"
  if [ ! -f "$file" ]; then
    echo "::error::Cannot optimize missing file $file"
    exit 1
  fi
  # -o7 = max compression level, -strip all = drop non-essential metadata
  # (timestamps, text chunks) so re-runs on an unchanged SVG produce a
  # byte-identical PNG rather than diff noise from embedded metadata.
  optipng -o7 -strip all -quiet "$file"
  echo "Optimized $file"
done

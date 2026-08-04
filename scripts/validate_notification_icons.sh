#!/usr/bin/env bash
set -euo pipefail

RES_ROOT="android/app/src/main/res"

declare -A SIZES=(
  [mdpi]=24
  [hdpi]=36
  [xhdpi]=48
  [xxhdpi]=72
  [xxxhdpi]=96
)

if ! command -v identify >/dev/null 2>&1 || ! command -v convert >/dev/null 2>&1; then
  echo "::error::ImageMagick (identify/convert) is not installed or not on PATH"
  exit 1
fi

fail=0

for density in "${!SIZES[@]}"; do
  size="${SIZES[$density]}"
  file="${RES_ROOT}/drawable-${density}/ic_notification.png"

  if [ ! -f "$file" ]; then
    echo "::error::Missing $file"
    fail=1
    continue
  fi

  if [ ! -s "$file" ]; then
    echo "::error::$file is empty (0 bytes)"
    fail=1
    continue
  fi

  if ! dims=$(identify -format "%wx%h" "$file" 2>/dev/null); then
    echo "::error::$file failed to decode (corrupted or not a valid PNG)"
    fail=1
    continue
  fi

  expected="${size}x${size}"
  if [ "$dims" != "$expected" ]; then
    echo "::error::$file has dimensions $dims, expected $expected"
    fail=1
  fi

  has_alpha=$(identify -format "%A" "$file" 2>/dev/null || echo "False")
  if [ "$has_alpha" != "True" ]; then
    echo "::error::$file has no alpha channel"
    fail=1
    continue
  fi

  alpha_mean=$(convert "$file" -alpha extract -format "%[fx:mean]" info: 2>/dev/null || echo "1")
  if awk -v v="$alpha_mean" 'BEGIN { exit !(v >= 0.999) }'; then
    echo "::error::$file appears fully opaque (alpha mean=${alpha_mean}) — expected a transparent background"
    fail=1
  fi

  alpha_max=$(convert "$file" -alpha extract -format "%[fx:max]" info: 2>/dev/null || echo "0")
  if awk -v v="$alpha_max" 'BEGIN { exit !(v <= 0.0001) }'; then
    echo "::error::$file is fully transparent (alpha max=${alpha_max}) — icon is invisible"
    fail=1
  fi

  echo "OK: $file (${dims}, alpha mean=${alpha_mean}, alpha max=${alpha_max})"
done

if [ "$fail" -eq 1 ]; then
  echo "::error::Notification icon validation failed."
  exit 1
fi

echo "All notification icons validated successfully."

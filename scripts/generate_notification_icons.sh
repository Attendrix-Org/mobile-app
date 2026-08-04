#!/usr/bin/env bash
set -euo pipefail

SRC="assets/branding/notification_icon.svg"
RES_ROOT="android/app/src/main/res"

if [ ! -f "$SRC" ]; then
  echo "::error::Source SVG not found at $SRC"
  exit 1
fi

if ! command -v inkscape >/dev/null 2>&1; then
  echo "::error::inkscape is not installed or not on PATH"
  exit 1
fi

# density:size pairs — see https://developer.android.com/training/notify-user/icon-design-status
declare -A SIZES=(
  [mdpi]=24
  [hdpi]=36
  [xhdpi]=48
  [xxhdpi]=72
  [xxxhdpi]=96
)

for density in "${!SIZES[@]}"; do
  size="${SIZES[$density]}"
  outdir="${RES_ROOT}/drawable-${density}"
  outfile="${outdir}/ic_notification.png"

  mkdir -p "$outdir"

  # Render directly at target size from the vector source (not downscaled
  # from a single raster) to avoid compounding resampling artifacts.
  inkscape "$SRC" \
    --export-type=png \
    --export-filename="$outfile" \
    --export-width="$size" \
    --export-height="$size" \
    --export-background-opacity=0

  echo "Generated ${outfile} (${size}x${size})"
done

#!/usr/bin/env bash
# resize-brand.sh — generate the canonical brand asset set for a niche site.
#
# Usage:
#   bash scripts/resize-brand.sh <source-logo.png|svg> <source-apple-touch.png> <out-dir>
#
# Given a master logo + square master image, writes:
#   out-dir/logo-full-color.svg            (or .png — copied through)
#   out-dir/logo-header.png                 (height 40)
#   out-dir/favicon.svg                     (if source was SVG — copied through)
#   out-dir/favicon-16.png                  (16x16)
#   out-dir/favicon-32.png                  (32x32)
#   out-dir/apple-touch-icon.png            (180x180)
#   out-dir/android-chrome-192.png          (192x192)
#   out-dir/android-chrome-512.png          (512x512)
#
# These eight files are what every niche template page <link>s and <img>s.
# Team headshots, testimonial avatars, and blog thumbnails are niche-specific
# and produced separately — this helper only touches the logo + icon set.
#
# Depends on macOS `sips` (preinstalled) for raster resizing. SVGs are copied
# through as-is — browsers scale them natively.

set -euo pipefail

src_logo="${1:?src logo required}"
src_square="${2:?src square image (apple-touch master, 1024x1024+ recommended) required}"
out_dir="${3:?out dir required}"

mkdir -p "$out_dir"

# Preserve source logo at full fidelity
case "$src_logo" in
  *.svg) cp "$src_logo" "$out_dir/logo-full-color.svg" ;;
  *.png) cp "$src_logo" "$out_dir/logo-full-color.png" ;;
  *)     cp "$src_logo" "$out_dir/logo-full-color${src_logo##*.}" ;;
esac

# Header logo — 40px tall (2x retina-safe via source being larger)
if [[ "$src_logo" == *.svg ]]; then
  cp "$src_logo" "$out_dir/logo-header.svg"
else
  sips -Z 80 "$src_logo" --out "$out_dir/logo-header.png" >/dev/null
fi

# Square icon set — all derived from the square master
sips -z 16 16   "$src_square" --out "$out_dir/favicon-16.png"          >/dev/null
sips -z 32 32   "$src_square" --out "$out_dir/favicon-32.png"          >/dev/null
sips -z 180 180 "$src_square" --out "$out_dir/apple-touch-icon.png"    >/dev/null
sips -z 192 192 "$src_square" --out "$out_dir/android-chrome-192.png"  >/dev/null
sips -z 512 512 "$src_square" --out "$out_dir/android-chrome-512.png"  >/dev/null

# If the square master is SVG, also drop a favicon.svg
if [[ "$src_square" == *.svg ]]; then
  cp "$src_square" "$out_dir/favicon.svg"
fi

echo "Wrote to $out_dir:"
ls -1 "$out_dir"

#!/usr/bin/env bash
set -euo pipefail

FPS=30
IN_DIR="out/frames"
OUT_FILE="out/final.mp4"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fps) FPS="$2"; shift 2;;
    --in) IN_DIR="$2"; shift 2;;
    --out) OUT_FILE="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

mkdir -p "$(dirname "$OUT_FILE")"

# Silent mux from PNG frames (Phase 1).
ffmpeg -y   -framerate "$FPS"   -i "${IN_DIR}/frame_%06d.png"   -c:v libx264 -pix_fmt yuv420p -crf 18   "$OUT_FILE"

echo "Wrote $OUT_FILE"

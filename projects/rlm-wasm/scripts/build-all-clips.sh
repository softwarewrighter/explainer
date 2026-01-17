#!/bin/bash
# Build all video clips for the RLM WASM explainer video
# This script builds all segments in the correct order:
#   1. Title card (with music)
#   2. Hook (avatar with narration)
#   3. L1 DSL overview (SVG with narration)
#   4. L2 WASM overview (SVG with narration)
#   5. VHS demos (error-ranking, percentiles, unique-ips) with overlaid narration
#   6. WASM Limitations (SVG with narration)
#   7. More to Come (SVG with narration)
#   8. CTA (avatar with narration)
#   9. Epilog (standard)
#  10. Epilog extension (music fade-out)

set -e
source "$(dirname "$0")/common.sh"
SCRIPT_DIR="$(dirname "$0")"

echo "=========================================="
echo "Building All RLM WASM Explainer Clips"
echo "=========================================="
echo ""

# Ensure directories exist
mkdir -p "$CLIPS"
mkdir -p "$WORK/png"

# ==========================================
# SECTION 1: Title (already built or use vid-slide)
# ==========================================
echo "=== Section 1: Title ==="
if [ -f "$CLIPS/00-title.mp4" ]; then
    echo "  00-title.mp4 exists, skipping"
else
    echo "  Building 00-title.mp4..."
    # Title card with music intro
    $VID_IMAGE \
        --image "$ASSETS/images/rlm-and-wasm-book.jpg" \
        --duration 5.0 \
        --music "$MUSIC" \
        --music-offset 0 \
        --volume 0.3 \
        --fade-in 0.5 \
        --fade-out 0.5 \
        --output "$CLIPS/00-title.mp4"
fi
echo ""

# ==========================================
# SECTION 2: Hook (avatar clip)
# ==========================================
echo "=== Section 2: Hook ==="
if [ -f "$CLIPS/01-hook-composited.mp4" ]; then
    echo "  01-hook-composited.mp4 exists, skipping"
else
    echo "  Run: ./scripts/build-avatar-clip.sh 01-hook"
    echo "  (Avatar clips require separate build due to lip-sync)"
fi
echo ""

# ==========================================
# SECTION 3-4: L1 and L2 Overview SVGs
# ==========================================
echo "=== Section 3: L1 DSL Overview ==="
"$SCRIPT_DIR/build-svg-clip.sh" rlm-l1-dsl l1-overview 03-l1-dsl
echo ""

echo "=== Section 4: L2 WASM Overview ==="
"$SCRIPT_DIR/build-svg-clip.sh" rlm-l2-wasm l2-overview 04-l2-wasm
echo ""

# ==========================================
# SECTION 5-7: VHS Demo Videos with Narration
# ==========================================
echo "=== Section 5-7: VHS Demo Videos ==="
echo "  VHS demos need narration overlay script (TODO)"
echo "  For now, using raw VHS recordings:"
echo "    - vhs/l2-error-ranking.mp4"
echo "    - vhs/l2-percentiles.mp4"
echo "    - vhs/l2-unique-ips.mp4"
echo ""

# ==========================================
# SECTION 8: WASM Limitations SVG
# ==========================================
echo "=== Section 8: WASM Limitations ==="
"$SCRIPT_DIR/build-svg-clip.sh" rlm-limitations limitations 08-limitations
echo ""

# ==========================================
# SECTION 9: More to Come SVG
# ==========================================
echo "=== Section 9: More to Come ==="
"$SCRIPT_DIR/build-svg-clip.sh" rlm-future future 09-future
echo ""

# ==========================================
# SECTION 10: CTA (avatar clip)
# ==========================================
echo "=== Section 10: CTA ==="
if [ -f "$CLIPS/14-cta-composited.mp4" ]; then
    echo "  14-cta-composited.mp4 exists, skipping"
else
    echo "  Run: ./scripts/build-avatar-clip.sh 14-cta"
    echo "  (Avatar clips require separate build due to lip-sync)"
fi
echo ""

# ==========================================
# SECTION 11-12: Epilog
# ==========================================
echo "=== Section 11-12: Epilog ==="
if [ -f "$CLIPS/99b-epilog.mp4" ]; then
    echo "  99b-epilog.mp4 exists, skipping"
else
    echo "  Copying reference epilog..."
    cp "$REFDIR/epilog/99b-epilog.mp4" "$CLIPS/99b-epilog.mp4"
fi

if [ -f "$CLIPS/99c-epilog-ext.mp4" ]; then
    echo "  99c-epilog-ext.mp4 exists, skipping"
else
    echo "  Run: ./scripts/build-epilog.sh"
fi
echo ""

# ==========================================
# Summary
# ==========================================
echo "=========================================="
echo "Build Summary"
echo "=========================================="
echo ""
echo "Clips ready:"
ls -la "$CLIPS"/*.mp4 2>/dev/null || echo "  (no clips found)"
echo ""
echo "Next steps:"
echo "  1. Build avatar clips if not done: ./scripts/build-avatar-clip.sh 01-hook"
echo "  2. Build VHS narration overlays (TODO)"
echo "  3. Run final concat: ./scripts/build-final.sh"

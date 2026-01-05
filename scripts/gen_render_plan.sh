#!/usr/bin/env bash
set -euo pipefail
cargo run -p explainerctl -- render-plan --script script/scenes.yaml --out out/render_plan.json

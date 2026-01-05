import fs from "node:fs";
import path from "node:path";
import { chromium } from "@playwright/test";

function parseArgs() {
  const args = process.argv.slice(2);
  const out = { baseUrl: "http://127.0.0.1:4173", fps: 30, script: "script/scenes.yaml" };
  for (let i=0;i<args.length;i++) {
    if (args[i] === "--base-url") out.baseUrl = args[++i];
    else if (args[i] === "--fps") out.fps = Number(args[++i]);
  }
  return out;
}

function readRenderPlan() {
  // In Phase 1 we precompute a plan with Rust so capture stays dumb & deterministic.
  const planPath = path.resolve("..", "out", "render_plan.json");
  if (!fs.existsSync(planPath)) {
    console.error("Missing out/render_plan.json. Run: cargo run -p explainerctl -- render-plan");
    process.exit(1);
  }
  return JSON.parse(fs.readFileSync(planPath, "utf-8"));
}

function ensureDir(p) { fs.mkdirSync(p, { recursive: true }); }

(async () => {
  const { baseUrl } = parseArgs();

  // Ensure render plan exists
  const plan = readRenderPlan();

  // Start browser
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1920, height: 1080 }, deviceScaleFactor: 1 });

  const outDir = path.resolve("..", "out", "frames");
  ensureDir(outDir);

  for (const item of plan) {
    const frame = String(item.frame).padStart(6, "0");
    const url = `${baseUrl}/?frame=${item.frame}&fps=${item.fps}&scene=${encodeURIComponent(item.scene_id)}&text=${encodeURIComponent(item.text)}`;
    await page.goto(url, { waitUntil: "networkidle" });
    await page.waitForTimeout(10); // small settle; deterministic content, no animations
    const outPath = path.join(outDir, `frame_${frame}.png`);
    await page.screenshot({ path: outPath });
    if (item.frame % 30 === 0) {
      console.log(`Captured frame ${item.frame}/${plan.length - 1}`);
    }
  }

  await browser.close();
  console.log(`Done. Frames in ${outDir}`);
})();

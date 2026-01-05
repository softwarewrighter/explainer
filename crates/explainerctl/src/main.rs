use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use explainer_core::Script;
use std::fs;

#[derive(Parser)]
#[command(name = "explainerctl")]
#[command(about = "Script-driven explainer pipeline helper (Phase 1 skeleton).")]
struct Cli {
    #[command(subcommand)]
    cmd: Cmd,
}

#[derive(Subcommand)]
enum Cmd {
    /// Validate and summarize a SceneScript YAML.
    Validate {
        /// Path to scenes.yaml
        #[arg(default_value = "script/scenes.yaml")]
        script: String,
    },
    /// Emit a JSON render plan for Playwright (frame -> scene/time mapping).
    RenderPlan {
        /// Path to scenes.yaml
        #[arg(default_value = "script/scenes.yaml")]
        script: String,
        /// Output JSON file
        #[arg(default_value = "out/render_plan.json")]
        out: String,
    },
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.cmd {
        Cmd::Validate { script } => {
            let s = fs::read_to_string(&script).with_context(|| format!("read {script}"))?;
            let script = Script::from_yaml_str(&s).with_context(|| "parse SceneScript")?;
            println!(
                "OK: {} scenes, fps={}, total_frames={}",
                script.scenes.len(),
                script.meta.fps,
                script.total_frames()
            );
        }
        Cmd::RenderPlan { script, out } => {
            let s = fs::read_to_string(&script).with_context(|| format!("read {script}"))?;
            let script = Script::from_yaml_str(&s).with_context(|| "parse SceneScript")?;
            let total = script.total_frames();
            let mut frames = Vec::with_capacity(total as usize);
            for f in 0..total {
                let (i, local, start) = script.locate_frame(f);
                let sc = &script.scenes[i];
                frames.push(serde_json::json!({
                    "frame": f,
                    "t": script.frame_time_s(f),
                    "scene_id": sc.id,
                    "scene_index": i,
                    "scene_frame": local,
                    "scene_start": start,
                    "fps": script.meta.fps,
                    "width": script.meta.width,
                    "height": script.meta.height,
                    "text": sc.text
                }));
            }
            fs::create_dir_all(std::path::Path::new(&out).parent().unwrap())?;
            fs::write(&out, serde_json::to_string_pretty(&frames)?)?;
            println!("Wrote {}", out);
        }
    }
    Ok(())
}

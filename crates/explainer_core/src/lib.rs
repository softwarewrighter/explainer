//! Explainer Core - Scene definition and parsing for deterministic video rendering.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Script {
    pub meta: Meta,
    pub scenes: Vec<Scene>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Meta {
    pub fps: u32,
    pub width: u32,
    pub height: u32,
    pub theme: Option<String>,
    pub background: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Scene {
    pub id: String,
    pub dur_s: f32,
    #[serde(rename = "type", default)]
    pub scene_type: SceneType,
    #[serde(default)]
    pub audio: AudioType,
    #[serde(default)]
    pub text: Option<String>,
    #[serde(default)]
    pub subtitle: Option<String>,
    #[serde(default)]
    pub script: Option<String>,
    #[serde(default)]
    pub source: Option<String>,
    #[serde(default)]
    pub layers: Vec<Layer>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum SceneType {
    #[default]
    Slide,
    Content,
    Epilog,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum AudioType {
    #[default]
    Music,
    Avatar,
    Shared,
    None,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "lowercase")]
pub enum Layer {
    Text(TextLayer),
    Svg(SvgLayer),
    Code(CodeLayer),
    Grid(GridLayer),
    Gauge(GaugeLayer),
    Particles(ParticlesLayer),
    Overlay(OverlayLayer),
    Split(SplitLayer),
    Block(BlockLayer),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TextLayer {
    pub text: String,
    pub at: [f32; 2],
    #[serde(default)]
    pub style: TextStyle,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SvgLayer {
    pub asset: String,
    #[serde(default)]
    pub id: Option<String>,
    pub at: [f32; 2],
    #[serde(default = "default_scale")]
    pub scale: f32,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

fn default_scale() -> f32 {
    1.0
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CodeLayer {
    pub language: String,
    pub text: String,
    pub at: [f32; 2],
    #[serde(default)]
    pub style: CodeStyle,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GridLayer {
    pub rows: u32,
    pub cols: u32,
    #[serde(default)]
    pub id: Option<String>,
    pub at: [f32; 2],
    #[serde(default)]
    pub style: GridStyle,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GaugeLayer {
    pub label: String,
    pub from: f32,
    pub to: f32,
    pub at: [f32; 2],
    #[serde(default)]
    pub style: GaugeStyle,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ParticlesLayer {
    pub kind: String,
    pub count: u32,
    #[serde(default)]
    pub bounds: Option<String>,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OverlayLayer {
    pub kind: String,
    #[serde(default)]
    pub opacity: f32,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SplitLayer {
    #[serde(default)]
    pub left: Vec<Layer>,
    #[serde(default)]
    pub right: Vec<Layer>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BlockLayer {
    pub label: String,
    #[serde(default)]
    pub style: BlockStyle,
    #[serde(default)]
    pub anim: Vec<Animation>,
}

// Style definitions
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct TextStyle {
    #[serde(default = "default_size")]
    pub size: u32,
    #[serde(default = "default_weight")]
    pub weight: u32,
    #[serde(default = "default_color")]
    pub color: String,
    #[serde(default)]
    pub font: Option<String>,
}

fn default_size() -> u32 {
    48
}
fn default_weight() -> u32 {
    600
}
fn default_color() -> String {
    "#ffffff".to_string()
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct CodeStyle {
    #[serde(default = "default_code_size")]
    pub size: u32,
    #[serde(default)]
    pub font: Option<String>,
}

fn default_code_size() -> u32 {
    24
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct GridStyle {
    #[serde(default = "default_gap")]
    pub gap: u32,
    #[serde(default = "default_cell_size")]
    pub cell_size: u32,
}

fn default_gap() -> u32 {
    10
}
fn default_cell_size() -> u32 {
    100
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct GaugeStyle {
    #[serde(default = "default_gauge_size")]
    pub size: u32,
    #[serde(default = "default_gauge_color")]
    pub color: String,
}

fn default_gauge_size() -> u32 {
    200
}
fn default_gauge_color() -> String {
    "#44ff88".to_string()
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct BlockStyle {
    #[serde(default = "default_block_color")]
    pub color: String,
}

fn default_block_color() -> String {
    "#4488ff".to_string()
}

// Animation definitions
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Animation {
    pub kind: AnimationKind,
    #[serde(default)]
    pub t0: f32,
    #[serde(default)]
    pub t1: Option<f32>,
    #[serde(default)]
    pub duration: Option<f32>,
    #[serde(default)]
    pub to: Option<f32>,
    #[serde(default)]
    pub cps: Option<u32>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "snake_case")]
pub enum AnimationKind {
    FadeIn,
    FadeUp,
    FadeOut,
    TypeOn,
    Sweep,
    Overflow,
    Increase,
    HighlightSequence,
    Assemble,
    CatalogSearch,
}

#[derive(Debug, thiserror::Error)]
pub enum ScriptError {
    #[error("failed to parse YAML: {0}")]
    Yaml(#[from] serde_yaml::Error),
    #[error("script must contain at least one scene")]
    NoScenes,
    #[error("invalid fps (must be > 0)")]
    BadFps,
}

impl Script {
    pub fn from_yaml_str(s: &str) -> Result<Self, ScriptError> {
        let script: Script = serde_yaml::from_str(s)?;
        script.validate()?;
        Ok(script)
    }

    pub fn validate(&self) -> Result<(), ScriptError> {
        if self.scenes.is_empty() {
            return Err(ScriptError::NoScenes);
        }
        if self.meta.fps == 0 {
            return Err(ScriptError::BadFps);
        }
        Ok(())
    }

    pub fn total_frames(&self) -> u64 {
        let fps = self.meta.fps as f32;
        self.scenes
            .iter()
            .map(|sc| (sc.dur_s * fps).round().max(1.0) as u64)
            .sum()
    }

    /// Return (scene_index, local_frame, absolute_frame_start)
    pub fn locate_frame(&self, frame: u64) -> (usize, u64, u64) {
        let fps = self.meta.fps as f32;
        let mut start: u64 = 0;
        for (i, sc) in self.scenes.iter().enumerate() {
            let n = (sc.dur_s * fps).round().max(1.0) as u64;
            if frame < start + n {
                return (i, frame - start, start);
            }
            start += n;
        }
        // clamp to last frame
        let last_i = self.scenes.len().saturating_sub(1);
        (last_i, 0, start.saturating_sub(1))
    }

    pub fn frame_time_s(&self, frame: u64) -> f32 {
        frame as f32 / self.meta.fps as f32
    }

    /// Get scene by ID
    pub fn scene_by_id(&self, id: &str) -> Option<&Scene> {
        self.scenes.iter().find(|s| s.id == id)
    }
}

impl Scene {
    /// Calculate progress (0.0 to 1.0) within this scene
    pub fn progress(&self, local_frame: u64, fps: u32) -> f32 {
        let total_frames = (self.dur_s * fps as f32).round().max(1.0);
        (local_frame as f32 / total_frames).min(1.0)
    }

    /// Get time in seconds within this scene
    pub fn time_s(&self, local_frame: u64, fps: u32) -> f32 {
        local_frame as f32 / fps as f32
    }
}

/// Render context passed to the web renderer
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RenderContext {
    pub scene_id: String,
    pub frame: u64,
    pub local_frame: u64,
    pub fps: u32,
    pub width: u32,
    pub height: u32,
    pub progress: f32,
    pub time_s: f32,
    pub background: String,
}

impl RenderContext {
    pub fn from_script_and_frame(script: &Script, frame: u64) -> Self {
        let (scene_idx, local_frame, _) = script.locate_frame(frame);
        let scene = &script.scenes[scene_idx];
        let progress = scene.progress(local_frame, script.meta.fps);
        let time_s = scene.time_s(local_frame, script.meta.fps);

        RenderContext {
            scene_id: scene.id.clone(),
            frame,
            local_frame,
            fps: script.meta.fps,
            width: script.meta.width,
            height: script.meta.height,
            progress,
            time_s,
            background: script
                .meta
                .background
                .clone()
                .unwrap_or_else(|| "#0e1117".to_string()),
        }
    }
}

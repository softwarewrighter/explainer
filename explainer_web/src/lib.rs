use gloo::utils::window;
use yew::prelude::*;

#[function_component(App)]
pub fn app() -> Html {
    let search = window().location().search().unwrap_or_default();
    let params = web_sys::UrlSearchParams::new_with_str(&search).ok();

    // We drive everything from query params to keep Playwright capture deterministic.
    let frame = params
        .as_ref()
        .and_then(|p| p.get("frame"))
        .and_then(|v| v.parse::<u64>().ok())
        .unwrap_or(0);
    let fps = params
        .as_ref()
        .and_then(|p| p.get("fps"))
        .and_then(|v| v.parse::<u32>().ok())
        .unwrap_or(30);
    let scene_id = params
        .as_ref()
        .and_then(|p| p.get("scene"))
        .unwrap_or_else(|| "unknown".into());
    let text = params
        .as_ref()
        .and_then(|p| p.get("text"))
        .unwrap_or_else(|| "No text".into());

    html! {
        <div class="frame">
            <div class="center">
                <div style="font-size:84px; font-weight:800;">{ text }</div>
                <div class="small">
                    { format!("scene: {}  |  frame: {}  |  fps: {}", scene_id, frame, fps) }
                </div>
            </div>
            <div class="badge">{ "Phase 1 deterministic renderer (Yew/WASM)" }</div>
        </div>
    }
}

#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn main_js() {
    yew::Renderer::<App>::new().render();
}

use explainer_core::Script;

#[test]
fn parse_and_compute_frames() {
    let yaml = r#"
meta: { fps: 30, width: 1920, height: 1080, theme: demo }
scenes:
  - { id: a, dur_s: 1.0, text: "A" }
  - { id: b, dur_s: 2.0, text: "B" }
"#;
    let script = Script::from_yaml_str(yaml).unwrap();
    assert_eq!(script.total_frames(), 30 + 60);
    let (i, local, start) = script.locate_frame(35);
    assert_eq!(i, 1);
    assert_eq!(local, 5);
    assert_eq!(start, 30);
}

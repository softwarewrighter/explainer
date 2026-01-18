# SVG Design Guidelines for Video

Guidelines for creating readable, professional SVG slides for 1920x1080 video output.

## Font Size Requirements

**CRITICAL: All text must be readable on video. Small fonts become illegible when rendered.**

### Minimum Font Sizes

| Element Type | Minimum Size | Recommended Size |
|--------------|--------------|------------------|
| Main headline | 84px | 96px |
| Subtitle/subheadline | 36px | 42-48px |
| Body text | **28px** | 32px |
| Subtext/labels | **28px** | 28-32px |
| Monospace/code | **28px** | 32px |

### Never Use

- Font sizes below 28px for any visible text
- Light font weights (< 400) at small sizes
- Text that extends beyond box boundaries

## Color Contrast

- Ensure sufficient contrast between text and background
- Use glow filters for text on busy backgrounds
- Prefer solid backgrounds behind important text

## Layout Guidelines

### Canvas Size
- Always design for 1920x1080 viewBox
- Center important content (avoid edges where avatar overlay appears)
- Leave 100px margins on all sides for safe area

### Text Positioning
- Use `text-anchor="middle"` for centered text
- Ensure URLs and links have adequate padding in their containers
- Make clickable/readable elements large enough

## Example: CTA Slide

```svg
<!-- Good: Readable font sizes -->
<text font-size="96" fill="#ff6b6b">Try Ralphy</text>
<text font-size="42" fill="#f8f8f2">Autonomous Task Execution</text>
<text font-size="32" fill="#8be9fd">Label Text</text>
<text font-size="28" fill="#50fa7b">github.com/user/repo</text>

<!-- Bad: Too small -->
<text font-size="22" fill="#8be9fd">Label Text</text>  <!-- TOO SMALL -->
<text font-size="24" fill="#50fa7b">github.com/repo</text>  <!-- TOO SMALL -->
```

## Dracula Color Palette

For consistency with terminal recordings and dark themes:

| Color | Hex | Use |
|-------|-----|-----|
| Background | #1a0a0a / #282a36 | Dark backgrounds |
| Foreground | #f8f8f2 | Primary text |
| Red | #ff6b6b / #ff5555 | Headlines, emphasis |
| Green | #50fa7b | Code, success, URLs |
| Cyan | #8be9fd | Labels, secondary text |
| Pink | #ff79c6 | Accents |
| Orange | #ffb86c | Warnings, highlights |
| Purple | #bd93f9 | Special elements |
| Comment | #6272a4 | Subdued text |

## Quality Checklist

Before finalizing an SVG:

- [ ] No text smaller than 28px
- [ ] Headlines at least 84px
- [ ] All text fits within boxes with padding
- [ ] Stroke widths at least 4-5px for visibility
- [ ] Sufficient color contrast
- [ ] Text readable at 50% zoom
- [ ] Safe margins observed
- [ ] Avatar overlay area (bottom-right) kept clear

# UI Direction — QR Code Generator App

> Per pre-dev skill: this file is mandatory for any user-facing interface project.
> Inputs: `ui-philosophy.md`, `ui-preferences.md`, project brief.

## App Type

**iOS native tool app** — single-purpose utility, minimal screens, quick task completion.

## Target Visual Feel

**Apple-native with premium flair.** Soft, elegant, restrained.
The app should feel like a polished product from the App Store, not a developer prototype.

Key adjectives: *calm, focused, premium, iOS-native, subtle.*

## Reference Inputs

- `ui-philosophy.md` — iOS default: "Apple-native with premium flair. Soft, elegant, and subtle by default."
- `ui-preferences.md` — Kirt: "Prefer Apple-native with premium flair. Prefer soft and elegant over sharp and aggressive."
- No project-specific inspiration image was provided by Kirt.

## Layout Strategy

### Single-Screen Architecture

One primary screen (`GeneratorView`) that handles all three QR types via a segmented picker:

```
[Segmented Picker: URL | Text | WiFi]
[Dynamic Input Fields (per segment)]
[Generate Button — prominent, rounded, accent-tinted]

[QR Code Output Card — white card, rounded corners, subtle shadow
    QR Image (centered)
    Copy Button | Share Button (below image)
]

[History Section
    Horizontal scroll of recent QR thumbnails
    Tapping a thumbnail regenerates and shows the QR
]
```

### Navigation

- No tab bar (single-purpose tool)
- No complex navigation
- Settings accessible via toolbar icon → sheet presentation
- History tap → inline regenerate (no push)

### Responsive Behavior

- Portrait-only primary use case
- QR card scales with container width (max 280pt)
- Safe area respected on all edges
- Dynamic Type support for body text

## Visual Specifications

### Color Palette

| Role | Light Mode | Dark Mode |
|------|-----------|-----------|
| Background | `#F2F2F7` (system grouped) | `#000000` |
| Card/Surface | `#FFFFFF` | `#1C1C1E` |
| Primary Accent | System Blue | System Blue |
| QR Foreground | `#000000` | `#FFFFFF` (invert on dark BG) |
| QR Background | `#FFFFFF` | `#1C1C1E` (card surface) |
| Text Primary | `#000000` | `#FFFFFF` |
| Text Secondary | `#8E8E93` | `#8E8E93` |
| Divider | `#3A3A3C` @ 30% | `#545458` @ 65% |

### Typography

| Element | Font | Size | Weight |
|---------|------|------|--------|
| Section Header | SF Pro | 13pt | Semibold (uppercase) |
| Input Label | SF Pro | 15pt | Medium |
| Input Field | SF Pro | 17pt | Regular |
| Button (Primary) | SF Pro | 17pt | Semibold |
| Button (Secondary) | SF Pro | 15pt | Regular |
| History Item Label | SF Pro | 11pt | Regular |
| Caption/Timestamp | SF Pro | 12pt | Regular |

### Spacing System (8pt grid)

- Screen horizontal padding: 20pt
- Section spacing: 24pt
- Card internal padding: 16pt
- Card corner radius: 16pt
- Card shadow: `0 2pt 8pt rgba(0,0,0,0.08)`
- Button height: 50pt
- Button corner radius: 12pt
- Input field height: 44pt
- QR output max width: 280pt
- QR padding in card: 20pt

### Motion / Animation

- QR appearance: `.scale` + `.opacity` spring animation (0.4s)
- History item tap: subtle scale down (0.97) on press
- Copy confirmation: checkmark overlay fade-in (200ms) + fade-out (1s)
- Mode toggle: instant (no animation, respects system)
- Avoid: flashy animations, heavy spring, bouncing

## States

### Empty State (no QR generated yet)

- Centered content
- Subtle icon or illustration showing QR + device
- Short instructional text: "Select a type, enter content, and generate"

### Generated State

- QR card appears with spring animation
- Copy and Share buttons below QR
- History section shows updated list

### History Empty State

- Section header shows "Recent" with count 0
- No history cards — just the section header

### Error States

- Invalid WiFi (empty SSID): inline red text below field
- Invalid URL: inline red text (URLs must have scheme — auto-add `https://` if missing)
- QR generation failure: alert with retry option (rare, catch all errors)

### Loading State

- Generate button shows `ProgressView()` spinner while generating
- Disable input fields during generation

## Component Inventory

### Segmented Picker

- 3 segments: URL, Text, WiFi
- `.pickerStyle(.segmented)` (native iOS)
- Full-width, 34pt height

### Input Fields

- `.textField` with `.autocorrectionDisabled()`, `.textInputAutocapitalization(.never)` for URL
- `.textField` for SSID
- Secure field for WiFi password
- Picker for encryption type (WPA, WEP, None)
- Placeholder text per field

### Generate Button

- Full-width primary button
- Background: system accent color
- Text: "Generate QR Code" in white/semibold
- Disabled state: 50% opacity when input empty

### QR Output Card

- White/dark surface card
- QR image centered
- Corner radius 16pt
- Subtle shadow
- If no QR yet: hidden or placeholder

### Action Buttons (Copy/Share)

- Icon + label: `Image(systemName: "doc.on.doc") + "Copy"`, `Image(systemName: "square.and.arrow.up") + "Share"`
- Secondary style (tinted, not filled)
- Horizontal stack, equal width

### History Thumbnail Card

- 72x72pt rounded square (8pt radius)
- QR thumbnail image
- Timestamp below (relative: "2m ago", "Yesterday")
- Type indicator icon (url=text.bubble, wifi=wifi, text=text)

### Appearance Settings

- Sheet presentation (`.sheet`)
- Toggle: "Auto", "Light", "Dark"
- Using `.preferredColorScheme()` modifier

## Anti-Goals (What to Avoid)

- Clunky layouts or cramped spacing
- Boxy "developer UI" aesthetic
- Harsh visual weight
- Flashy animations
- Overly decorated surfaces
- Childish styling
- No data collection banners or trust messaging (it's obvious from the app's behavior — no need to announce it)

## Summary

Single-screen tool app. Premium iOS-native feel. Soft surfaces, calm hierarchy, restrained motion. Native segmented picker for type switching. White/dark card surfaces. 8pt grid spacing. No visual noise. The result should feel like a polished Apple tool.

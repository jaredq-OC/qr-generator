# Plan — QR Code Generator App

> Project ID: qr-generator | Grade: Personal (8.0) | Build order

---

## Build Sequence

```
Phase 1: Foundation
├── TASK-01: Scaffold project with XcodeGen
├── TASK-02: Set up Assets.xcassets (colors, app icon placeholder)
├── TASK-03: Configure project.yml (iOS 16.0 target, Swift 6)
└── TASK-04: Verify empty shell builds and runs in simulator

Phase 2: Core Services
├── TASK-05: Implement QRCodeService (CoreImage generation)
├── TASK-06: Implement WiFiPayloadBuilder (escaping + format)
├── TASK-07: Implement HistoryService (UserDefaults + thumbnail I/O)
└── TASK-08: Write unit tests for QRCodeService and WiFiPayloadBuilder

Phase 3: Models
├── TASK-09: Define QRType, QRHistoryEntry, WiFiCredentials, AppearanceMode
└── TASK-10: Set up Assets for AppIcon and placeholder colors

Phase 4: Generator Feature
├── TASK-11: Implement GeneratorViewModel (@Observable)
├── TASK-12: Build GeneratorView (segmented picker + input fields)
├── TASK-13: Build QRCodeCard + QRCodeActions (copy/share)
├── TASK-14: Build HistoryThumbnail list
├── TASK-15: Build AppearanceSettingsSheet
└── TASK-16: Wire up appearance mode toggle

Phase 5: Polish & Validation
├── TASK-17: Add animations (QR card spring, copy confirmation)
├── TASK-18: Add empty/loading/error states
├── TASK-19: Build on simulator — verify no crash
└── TASK-20: Manual QA pass — all features functional

Phase 6: Post-Build (Deferred)
└── DEFER-01: Widget support — future work only
```

---

## Task Details

### TASK-01 — Scaffold project with XcodeGen

```
Action: Create project.yml at project root
  - iOS 16.0 deployment target
  - Swift 6 language
  - Single app target: QRCodeGenerator
  - Use /usr/local/bin/xcodegen (NOT ~/bin/xcodegen)

Validation: xcodegen generate → .xcodeproj opens in Xcode without errors
```

### TASK-05 — QRCodeService

```
Input: String → UIImage?
Implementation:
  1. CIFilter.qrCodeGenerator() with Data(string.utf8)
  2. Scale to target size using transform
  3. CIContext().createCGImage()
  4. Return UIImage(cgImage:)

Error handling: Return nil for empty string

Validation: Unit test with known strings; scan result with iOS Camera
```

### TASK-06 — WiFiPayloadBuilder

```
Input: ssid, password, encryption type → WiFi QR string
Implementation:
  1. Escape special chars in ssid and password (\, ;, :)
  2. Build string: WIFI:T:<enc>;S:<ssid>;P:<password>;;
  3. Handle nopass (no P: field)
  4. Handle H:true for hidden (include H:true;)

Validation: Unit tests for escaping edge cases
  - SSID with semicolon
  - Password with backslash
  - SSID with colon
```

### TASK-07 — HistoryService

```
Inputs: QRHistoryEntry → save
        Void → load all

Storage:
  - UserDefaults key: "qr_history_entries" → JSON [QRHistoryEntry]
  - Documents/Thumbnails/{UUID}.png → 100x100 PNG

FIFO:
  - On save: check count; if >= 10, remove oldest (sort by generatedAt)
  - On eviction: delete orphaned thumbnail file

Validation: TASK-20: Generate 11 QRs → verify only 10 in history
```

### TASK-11 — GeneratorViewModel

```
State:
  - selectedType: QRType (url/text/wifi)
  - urlInput: String
  - textInput: String
  - wifiCredentials: WiFiCredentials (ssid, password, encryption)
  - generatedImage: UIImage?
  - historyEntries: [QRHistoryEntry]
  - appearanceMode: AppearanceMode
  - showSettings: Bool
  - showCopiedConfirmation: Bool
  - errorMessage: String?

Actions:
  - generateQR()
  - copyToClipboard()
  - loadHistory()
  - regenerateFromHistory(entry:)
  - setAppearanceMode(_:)
```

### TASK-12 — GeneratorView Layout

```
Structure:
  VStack(spacing: 24)
  ├── SegmentedPicker (URL / Text / WiFi)
  ├── Conditional input (URLInputView | TextInputView | WiFiInputView)
  ├── GenerateButton (full-width, 50pt, rounded 12pt)
  ├── QRCodeCard (if generatedImage != nil)
  └── HistoryThumbnailRow (horizontal scroll)

Spacing: 20pt horizontal padding, 8pt grid
Safe area: all edges respected
```

### TASK-16 — Appearance Settings

```
Sheet presentation (.sheet(isPresented:))
Contents:
  Picker("Appearance", selection: $appearanceMode) {
    Text("Auto").tag(AppearanceMode.system)
    Text("Light").tag(AppearanceMode.light)
    Text("Dark").tag(AppearanceMode.dark)
  }
  .pickerStyle(.inline)
  .labelsHidden()

Apply: .preferredColorScheme(scheme) on the WindowGroup
```

---

## TEST-* Mapping

| TEST | Requirement | Validation |
|------|-------------|------------|
| TEST-01 | RQ-01 | Scan URL QR with iOS Camera → opens Safari |
| TEST-02 | RQ-02 | Scan text QR with iOS Camera → shows text |
| TEST-03 | RQ-03 | Scan WiFi QR with iOS Camera → prompts join network |
| TEST-04 | RQ-04 | Tap Copy → paste into Notes shows QR |
| TEST-05 | RQ-05 | Tap Share → share sheet appears |
| TEST-06 | RQ-07 | Generate 11 QRs → history shows 10, oldest evicted |
| TEST-07 | RQ-09/10/11 | Toggle appearance → app respects mode |
| TEST-08 | NFR-06 | Airplane mode → all features work |

---

## UI Direction (from ui-direction.md)

- Single-screen with segmented picker (URL / Text / WiFi)
- White/dark card surfaces with 16pt corner radius, subtle shadow
- 8pt grid: 20pt horizontal padding, 24pt section spacing, 50pt button height
- Spring animation (≈0.4s) for QR card appearance
- Copy confirmation: checkmark overlay 200ms fade-in + 1s hold + 200ms fade-out
- System SF Symbols for all icons; no custom icon assets needed
- Full dark/light mode support with `.preferredColorScheme`
- Dynamic Type support for body text

## DEFER Items

| ID | Item | Trigger |
|----|------|---------|
| DEFER-01 | Widget support | Kirt requests after initial build |
| DEFER-02 | History search/filter | History use grows beyond 10 |
| DEFER-03 | Custom QR colors/logo | Kirt requests customization |

---

## Blocker Notes

| Blocker | Resolution |
|---------|-----------|
| None identified at this time | — |

---

## Rollback Plan

If XcodeGen project fails to build:
1. Verify `project.yml` is in project root
2. Run `/usr/local/bin/xcodegen generate` (not `~/bin/xcodegen`)
3. Check iOS 16.0 deployment target
4. Check Swift 6 language version settings

If CoreImage QR generation fails on device:
1. Confirm `CIFilter.qrCodeGenerator()` available (iOS 13+)
2. Check `CIContext` is not nil
3. Confirm `filter.outputImage` is not nil before transforming

# Architecture — QR Code Generator App

> Project ID: qr-generator | Layer: iOS native | Grade: Personal (8.0)

---

## 1. Technology Stack

| Layer | Technology | Justification |
|-------|-----------|---------------|
| UI Framework | SwiftUI | Native, modern, declarative |
| QR Generation | CoreImage `CIFilter.qrCodeGenerator()` | Native, offline, fast, no dep |
| Share Sheet | SwiftUI `.sheet` + `UIActivityViewController` | Native |
| Clipboard | `UIPasteboard.general` | Native, no permission |
| Storage | UserDefaults (metadata) + Documents/Thumbnails/ (images) | Standard iOS pattern |
| Appearance | SwiftUI `.preferredColorScheme()` + `@AppStorage` | Native |
| Project Gen | XcodeGen (`/usr/local/bin/xcodegen`) | Per KB |
| Min iOS | 16.0 | SwiftUI modern APIs |
| Swift | 6.x | Host Swift version |

**Zero external dependencies.** All functionality via native frameworks.

---

## 2. Module Architecture

```
QRCodeGenerator/
├── App/
│   └── QRCodeGeneratorApp.swift          # @main, AppearanceConfig
├── Features/
│   └── Generator/
│       ├── GeneratorView.swift            # Main single-screen view
│       ├── GeneratorViewModel.swift      # @Observable, all state
│       ├── Components/
│       │   ├── SegmentedPicker.swift
│       │   ├── URLInputView.swift
│       │   ├── TextInputView.swift
│       │   ├── WiFiInputView.swift
│       │   ├── QRCodeCard.swift
│       │   ├── QRCodeActions.swift
│       │   └── HistoryThumbnail.swift
│       └── AppearanceSettingsSheet.swift
├── Services/
│   ├── QRCodeService.swift                # CoreImage generation
│   ├── WiFiPayloadBuilder.swift           # WiFi string construction + escaping
│   └── HistoryService.swift               # UserDefaults + thumbnail file I/O
├── Models/
│   ├── QRType.swift
│   ├── QRHistoryEntry.swift
│   ├── WiFiCredentials.swift
│   └── AppearanceMode.swift
├── Resources/
│   └── Assets.xcassets/
└── Preview Content/
    └── PreviewAssets.xcassets/
```

---

## 3. Data Flow

### QR Generation Flow

```
User input → ViewModel.inputString / WiFiCredentials
  → WiFiPayloadBuilder.build() [if WiFi type]
  → QRCodeService.generateQRImage(string:) → UIImage
  → QRCodeCard displays UIImage
  → HistoryService.save(entry:) on each generation
```

### History Flow

```
HistoryService.load() → [QRHistoryEntry] on app launch
  → GeneratorViewModel.historyEntries
  → HistoryThumbnail list displayed below QR card
  → Tap → regenerates QR and displays
  → New entry → HistoryService.save() → FIFO eviction if > 10
```

### Share Flow

```
ShareLink(item: Image(uiImage: qrImage))
  → UIActivityViewController presented
  → No data leaves app without user action
```

### Copy Flow

```
UIPasteboard.general.image = qrUIImage
  → Show checkmark confirmation overlay (200ms fade-in, 1s hold, 200ms fade-out)
```

---

## 4. QRCodeService

```swift
// QRCodeService.swift
import CoreImage.CIFilterBuiltins
import CoreImage

func generateQRImage(from string: String, size: CGFloat = 300) -> UIImage? {
    let filter = CIFilter.qrCodeGenerator()
    filter.message = Data(string.utf8)
    filter.correctionLevel = "M"
    
    guard let ciImage = filter.outputImage else { return nil }
    
    // Scale without blur
    let scaleX = size / ciImage.extent.width
    let scaled = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
    
    let context = CIContext()
    guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
    
    return UIImage(cgImage: cgImage)
}
```

---

## 5. WiFi Payload Builder

```swift
// WiFiPayloadBuilder.swift
enum WiFiEncryption: String, CaseIterable {
    case wpa = "WPA"
    case wep = "WEP"
    case none = "nopass"
}

func buildWiFiPayload(ssid: String, password: String, encryption: WiFiEncryption) -> String {
    func escape(_ s: String) -> String {
        s.replacingOccurrences(of: "\\", with: "\\\\")
         .replacingOccurrences(of: ";", with: "\\;")
         .replacingOccurrences(of: ":", with: "\\:")
    }
    
    if encryption == .none {
        return "WIFI:T:nopass;S:\(escape(ssid));;"
    } else {
        return "WIFI:T:\(encryption.rawValue);S:\(escape(ssid));P:\(escape(password));;"
    }
}
```

---

## 6. History Storage

### UserDefaults Schema
- Key: `qr_history_entries`
- Value: JSON-encoded `[QRHistoryEntry]` array (max 10)

### Thumbnail Storage
- Location: `Documents/Thumbnails/`
- Naming: `{UUID}.png` (100x100 PNG)
- Read: on app launch, load thumbnail filenames from UserDefaults
- Write: on new history entry, generate and save thumbnail

### Eviction
- On save: if count > 10, remove oldest (by `generatedAt`)
- Delete orphaned thumbnail file on eviction

---

## 7. Appearance Architecture

```swift
// AppearanceMode.swift
enum AppearanceMode: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
}

// In App
@AppStorage("appearanceMode") var appearanceMode: String = "system"

var body: some Scene {
    WindowGroup {
        GeneratorView()
            .preferredColorScheme(scheme)
    }
}

// Computed
private var scheme: ColorScheme? {
    switch appearanceMode {
    case "light": return .light
    case "dark": return .dark
    default: return nil
    }
}
```

---

## 8. Error Handling

| Error | Response |
|-------|----------|
| QR generation failure (empty string) | Disable Generate button until valid input |
| Invalid URL | Auto-prepend `https://` if no scheme; if clearly invalid, show inline error |
| Empty WiFi SSID | Show inline error below SSID field |
| Clipboard failure | Silently fail; show confirmation animation as if success |
| Thumbnail write failure | Skip thumbnail; save entry without image reference |
| UserDefaults full | Evict oldest entries; log warning |

---

## 9. UI System

Per `ui-direction.md`: Apple-native with premium flair. Soft, elegant, restrained.
- Colors: system semantic colors only — `.primary`, `.secondary`, `.background`, `.surface`
- Spacing: 8pt grid, 20pt horizontal padding, 16pt card padding, 16pt card radius
- Motion: `.scale` + `.opacity` spring animation (≈0.4s) for QR card appearance
- No hardcoded colors; no boxy layouts; no flashy animations

---

## 10. No OpenClaw Integration

This is a standalone iOS app. There are no OpenClaw touchpoints.
`INT-00: None — standalone iOS application, no workspace integration.`

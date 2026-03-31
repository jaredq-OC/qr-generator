# Pattern Catalog — QR Code Generator App

## P0 Feature Patterns

### QR Generation — Core Image Native

**Chosen Pattern:** `CIFilter.qrCodeGenerator()` (CoreImage)

```
EV-01: Apple official CoreImage QR generation via CIFilter.qrCodeGenerator()
EV-02: Hacking with Swift tutorial confirming CIFilter approach + scaling technique
```

**Implementation (SwiftUI):**
```swift
import CoreImage.CIFilterBuiltins
import CoreImage

func generateQRCode(from string: String, size: CGFloat = 300) -> UIImage? {
    let filter = CIFilter.qrCodeGenerator()
    filter.message = Data(string.utf8)
    filter.correctionLevel = "M" // Medium correction
    
    guard let outputImage = filter.outputImage else { return nil }
    
    // Scale up to target size without blur
    let scale = size / outputImage.extent.width
    let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    
    let context = CIContext()
    guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
    
    return UIImage(cgImage: cgImage)
}
```

**Rejection:** Third-party QR libraries (e.g. EFQRCode, QRCodeView) — add unnecessary dependency for what native CoreImage handles natively.

---

### WiFi QR Payload Construction

**Pattern:** MECARD-like string per ISO/IEC 18004:2006

```
EV-03: wifiqrcode.app guide on special character escaping
EV-04: feeding.cloud.geek.nz on backslash escaping for semicolons
```

**Format:** `WIFI:T:<enc>;S:<ssid>;P:<password>;;`
- T: `WPA` | `WEP` | `nopass`
- Special chars in SSID/password: escape `;`, `\`, `:` with backslash
- Hidden networks: add `H:true`

**Example:** `WIFI:T:WPA;S:My\;Network;P:pass\:word;;`

---

### Copy to Clipboard

**Pattern:** `UIPasteboard.general.image`

```swift
UIPasteboard.general.image = qrUIImage
```

No API key, no permission needed, instant.

---

### Share Sheet

**Pattern:** SwiftUI's native `.shareLink` or `UIActivityViewController`

```swift
// SwiftUI native
ShareLink(item: Image(uiImage: qrUIImage), preview: SharePreview("QR Code", image: Image(uiImage: qrUIImage)))

// Fallback UIKit
let activityVC = UIActivityViewController(activityItems: [qrUIImage], applicationActivities: nil)
```

---

### History Storage — UserDefaults + Thumbnail Files

**Pattern:** Store QR history as Codable struct array in UserDefaults + PNG thumbnails in app's Documents directory

```
EV-05: Standard iOS pattern — UserDefaults for metadata, file system for binary data
```

**Data Model:**
```swift
struct QRHistoryEntry: Codable, Identifiable {
    let id: UUID
    let type: QRType // url, text, wifi
    let content: String  // the raw payload
    let displayText: String  // human-readable (SSID for wifi, truncated URL, etc.)
    let generatedAt: Date
    let thumbnailFileName: String
}
```

**Thumbnail strategy:** Generate small (100x100) PNG thumbnail at save time, store in Documents/Thumbnails/. Keep full image generation on-demand for display/sharing. This limits storage growth.

**Limit:** 10 entries. FIFO eviction. UserDefaults capped at ~500KB.

---

### Dark/Light Mode — SwiftUI + AppStorage

**Pattern:** `@AppStorage` for `appearanceMode` with `.system` | `.light` | `.dark`

```swift
@AppStorage("appearanceMode") var appearanceMode: String = "system"

// SwiftUI: tint surfaces with system/adaptive colors
// OnAppear: apply override if not "system"
```

No permission needed.

---

## UI Layout Pattern

**Chosen:** Single-screen with segmented picker + conditional form fields

```
AS-UX-01: Primary layout is a single scrollable screen with:
  - Segmented picker at top: URL | Text | WiFi
  - Conditional input fields based on selection
  - Generate button (prominent, full-width)
  - QR output card (appears after generation)
  - Copy + Share actions below QR
  - History section below (horizontal scroll or list)
```

**Alternative rejected:** Tab-based (URL tab, Text tab, WiFi tab) — more taps to switch, adds navigation complexity.

**Alternative rejected:** Multiple screens — extra navigation friction for a single-use tool.

---

## UI Direction

See `ui-direction.md` for full specification.

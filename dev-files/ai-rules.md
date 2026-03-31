# AI Rules — QR Code Generator App

> These are hard rules for Dev. No deviation. No "it should be fine." If in doubt, stop and ask.

---

## Build Constraints

### FORBID

- **FORBID** introducing any third-party Swift package or CocoaPod dependency. Use only native frameworks (CoreImage, SwiftUI, UIKit, Foundation).
- **FORBID** using `/Users/jared/bin/xcodegen` — it is a broken 9-byte stub. Always use `/usr/local/bin/xcodegen`.
- **FORBID** adding any network call, URLSession, or external API — this is a fully offline app.
- **FORBID** adding any analytics, tracking, telemetry, or crash reporting SDK.
- **FORBID** adding user accounts, authentication, or sign-in flows.
- **FORBID** storing history data anywhere except UserDefaults (metadata) and the app's Documents directory (thumbnails).
- **FORBID** transmitting any user data over the network — there is no network access.

### MUST

- **MUST** use `CIFilter.qrCodeGenerator()` from CoreImage for QR generation — never a third-party QR library.
- **MUST** generate QR codes client-side only, with zero external service calls.
- **MUST** respect the 10-entry FIFO history limit — no unbounded storage growth.
- **MUST** escape special characters in WiFi SSID and password (`;`, `\`, `:` → backslash-escaped) per ISO/IEC 18004:2006 before encoding.
- **MUST** auto-prepend `https://` to URL input if no scheme is present.
- **MUST** use `UIPasteboard.general.image` for clipboard copy — native API, no permission required.
- **MUST** use SwiftUI `.sheet` or `ShareLink` for share functionality.
- **MUST** respect `preferredColorScheme` for manual light/dark mode toggle.
- **MUST** generate 100x100 PNG thumbnails for history items and store in `Documents/Thumbnails/`.
- **MUST** delete orphaned thumbnail files when history entries are evicted.

### PIN

- **PIN** the minimum iOS deployment target to iOS 16.0 or later.
- **PIN** the Swift language version to the host Swift version (6.x).
- **PIN** XcodeGen to `/usr/local/bin/xcodegen` in all instructions and scripts.

---

## Visual & UX Rules

### FORBID

- **FORBID** hardcoding colors — use `.primary`, `.secondary`, `.background`, `.surface` and system semantic colors.
- **FORBID** overly decorative UI elements or animations — keep motion subtle and purposeful.
- **FORBID** boxy or cramped layouts — follow 8pt grid with generous spacing.
- **FORBID** "developer UI" aesthetic — it must look like a polished App Store product.
- **FORBID** adding unnecessary banners, disclaimers, or messaging about privacy — the app's behavior demonstrates this.

### MUST

- **MUST** use system SF Symbols for all icons (`.doc.on.doc`, `.square.and.arrow.up`, `.wifi`, `.link`, `.textformat`).
- **MUST** follow the spacing system in `ui-direction.md` (8pt grid, 20pt horizontal padding, 16pt card padding, 16pt card corner radius).
- **MUST** include empty/loading/error states for all async and input scenarios.
- **MUST** use `.scale` + `.opacity` spring animation (≈0.4s) for QR card appearance.
- **MUST** use the color palette in `ui-direction.md` — light and dark mode must both look premium.
- **MUST** support Dynamic Type for body text.

---

## Architecture Rules

### FORBID

- **FORBID** putting QR generation logic directly in the View — extract into `QRCodeService`.
- **FORBID** mixing WiFi payload construction with QR generation — separate into `WiFiPayloadBuilder`.
- **FORBID** directly accessing UserDefaults or file system from Views — use `HistoryService`.
- **FORBID** making QR code generation synchronous on the main thread for large inputs — use a background context where needed (though CoreImage is typically fast enough for text QR).

### MUST

- **MUST** use `@Observable` (Swift 5.9+) macro for ViewModels — no `ObservableObject`.
- **MUST** use `@AppStorage` for `appearanceMode` preference.
- **MUST** separate the QR payload building from the QR image generation (WiFi string vs UIImage).
- **MUST** make `QRCodeService` pure: `String → UIImage?` with no side effects.

---

## Test Gates

### TEST-GATE-01: QR Scannability

- Generate a QR for a known URL using the app
- Scan with iOS Camera app → must open in Safari
- Generate a WiFi QR → scan with iOS Camera → must prompt to join WiFi

### TEST-GATE-02: Offline Verification

- Enable airplane mode
- Generate 3 QR codes (URL, text, WiFi)
- Copy and share must still work
- History must persist

### TEST-GATE-03: History FIFO

- Generate 11 QR codes
- Verify only the last 10 are present
- Verify oldest was evicted

### TEST-GATE-04: Appearance Toggle

- Set to light mode → app is light
- Set to dark mode → app is dark
- Set to system → app follows device setting

### TEST-GATE-05: WiFi Special Chars

- SSID: `My;Network`
- Password: `pass:word\more`
- Generate → scan → SSID and password are decoded correctly

---

## Anti-Patterns (What This App Is NOT)

- Not a QR scanner — no AVFoundation scanning needed
- Not a cloud app — no network layer, no sync
- Not a social app — no sharing to specific apps, just the system share sheet
- Not a settings-heavy app — only one user preference (appearance)
- Not a data collection tool — no analytics, no crash reporting

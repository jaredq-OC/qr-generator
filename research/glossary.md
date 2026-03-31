# Glossary — QR Code Generator App

## Actors
- **User** — Person using the app to generate, copy, share, and review QR codes

## Systems / Components
- **iOS App** — The QR Code Generator mobile application
- **Core Image (CIFilter)** — Apple's built-in framework for QR code generation (`CIQRCodeGenerator`)
- **SwiftUI** — Apple's declarative UI framework (preferred for this project)
- **iOS Share Sheet (UIActivityViewController)** — Native iOS sharing mechanism
- **UIPasteboard** — iOS clipboard API
- **UserDefaults** — On-device key-value storage for history and preferences
- **WidgetKit** — iOS widget framework (optional, deferred)
- **XcodeGen** — Project generation tool (use `/usr/local/bin/xcodegen`)

## Data Objects
- **QRCodeEntry** — A history record: { id, type (url|text|wifi), content, generatedAt, thumbnail }
- **QRContentType** — Enum: `url`, `text`, `wifi`
- **WiFiPayload** — Structured: { ssid, password, encryptionType (WPA/WEP/nopass) }
- **AppearanceMode** — Enum: `system`, `light`, `dark`
- **QRCodeImage** — Rendered CGImage/UIImage from CIFilter output

## Environments
- **iOS 17.5** — Target iOS version (based on available simulators)
- **Swift 6.2.3** — Language version
- **Xcode 16+** — IDE

## QR Code Formats
- **URL QR** — Raw UTF-8 string of the URL
- **Text QR** — Raw UTF-8 string of the plain text
- **WiFi QR** — `WIFI:T:<encryption>;S:<ssid>;P:<password>;;` per ISO/IEC 18004:2006

## External Services
- **None** — Fully offline app

## OpenClaw Touchpoints
- None — this is a standalone iOS app with no OpenClaw integration

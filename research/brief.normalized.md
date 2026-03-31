# Brief Normalized — QR Code Generator App

> Project ID: qr-generator | Grade: Personal (8.0) | Status: Pre-Dev Stage 0

## Brief Atomic Requirements

| ID | Statement | Classification |
|----|-----------|----------------|
| RQ-01 | The app generates QR codes for URLs | functional |
| RQ-02 | The app generates QR codes for plain text strings | functional |
| RQ-03 | The app generates QR codes for WiFi credentials (format: WIFI:T:WPA;S:\<network\>;P:\<password\>;;) | functional |
| RQ-04 | The user can copy the generated QR code image to the clipboard with one tap | functional |
| RQ-05 | The user can share the QR code via the iOS share sheet | functional |
| RQ-06 | The app operates fully offline — no data is collected or transmitted | constraint |
| RQ-07 | The app stores the last 10 generated QR codes locally on-device only | functional |
| RQ-08 | The history data is never synced to any external service | constraint |
| RQ-09 | The app supports dark mode and light mode | functional |
| RQ-10 | The app supports automatic mode switching based on system appearance | functional |
| RQ-11 | The user can manually toggle between dark and light mode | functional |
| RQ-12 | The app may optionally include widget support (lower priority) | non-goal (deferred/optional) |
| RQ-13 | The app is an iOS app | constraint |
| RQ-14 | QR code generation must work entirely without network access | constraint |

## Non-Functional Requirements

| ID | Statement | Classification |
|----|-----------|----------------|
| NFR-01 | QR codes must be scannable by any standard QR code reader | non-functional |
| NFR-02 | QR code generation must be instant (< 1 second) | non-functional |
| NFR-03 | No external API calls for QR generation | constraint |
| NFR-04 | History data persists across app launches | non-functional |
| NFR-05 | No analytics, tracking, or telemetry | constraint |

## Non-Goals

| ID | Statement |
|----|-----------|
| NG-01 | No widget support required (optional, lower priority — treated as deferred) |
| NG-02 | No network-based QR generation |
| NG-03 | No cloud sync or backup of history |
| NG-04 | No user accounts or authentication |

## UI/UX Requirements

| ID | Statement | Classification |
|----|-----------|----------------|
| UI-01 | User-facing iOS app — UI review is mandatory | constraint |
| UI-02 | No specific visual inspiration provided by Kirt | open |
| UI-03 | Default to Apple-native with premium flair per ui-philosophy.md | constraint |
| UI-04 | Dark/light mode must be accessible and obvious | functional |

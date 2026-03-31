# PRD — QR Code Generator App

> Project ID: qr-generator | Grade: Personal (8.0) | Status: Pre-Dev complete

---

## 1. Overview

**What it is:** A simple offline iOS app that generates QR codes for URLs, plain text, and WiFi credentials.

**Target user:** Personal use; Kirt himself.

**Core value:** Fast, private, offline QR generation without any data leaving the device.

**Out of scope:** QR code scanning (not mentioned in brief), cloud sync, widgets (deferred), accounts/auth.

---

## 2. User Stories

### 2.1 URL to QR

- **Actor:** User
- **Flow:** User selects "URL" tab → enters URL → taps Generate → QR code appears → user copies or shares it
- **Acceptance:** Any valid URL string (with or without `https://`) generates a valid, scannable QR code

### 2.2 Plain Text QR

- **Actor:** User
- **Flow:** User selects "Text" tab → enters any text → taps Generate → QR code appears
- **Acceptance:** Any UTF-8 string generates a valid, scannable QR code

### 2.3 WiFi QR

- **Actor:** User
- **Flow:** User selects "WiFi" tab → enters SSID, password, selects encryption type → taps Generate → QR appears
- **Acceptance:** Generated QR contains correctly formatted WiFi payload scannable by iOS/Android WiFi connect

### 2.4 Copy to Clipboard

- **Actor:** User
- **Flow:** After QR is generated → user taps "Copy" → QR image is on clipboard
- **Acceptance:** User can paste the QR image into any app

### 2.5 Share QR

- **Actor:** User
- **Flow:** After QR is generated → user taps "Share" → iOS share sheet appears → user selects target app
- **Acceptance:** Share sheet presents with QR image as shareable item

### 2.6 History

- **Actor:** User
- **Flow:** After generating a QR → it appears in history → user can tap any history item to re-display that QR
- **Acceptance:** Last 10 unique generated QR entries are persisted across app launches; oldest evicted when 11th is added

### 2.7 Appearance Mode

- **Actor:** User
- **Flow:** User taps settings icon → selects Auto / Light / Dark → app respects preference
- **Acceptance:** Appearance persists across launches; system default applies when Auto is selected

---

## 3. UI Direction (visual standard)

Per `ui-direction.md`, this app must feel **Apple-native with premium flair**:
- Soft, elegant surfaces
- Calm hierarchy with generous breathing room
- Restrained, polished motion
- Single primary screen with segmented picker
- White/dark card surfaces with subtle shadows
- No "developer UI" boxy aesthetic
- Kirt's known dislike: cramped buttons, harsh layout, crude visual quality

---

## 4. Data Model

### QRHistoryEntry
```
id: UUID
type: QRType  // .url | .text | .wifi
content: String  // raw payload (WiFi string, URL, or text)
displayText: String  // human-readable (truncated URL, SSID, etc.)
generatedAt: Date
thumbnailFileName: String  // path within Documents/Thumbnails/
```

### AppearanceMode
```
system | light | dark
```

---

## 5. Non-Functional Requirements

| ID | Requirement |
|----|-------------|
| NFR-01 | QR generation < 1 second on device |
| NFR-02 | Fully offline — zero network calls |
| NFR-03 | No analytics, telemetry, or tracking |
| NFR-04 | History persists across app launches |
| NFR-05 | QR codes scannable by any standard reader |
| NFR-06 | No external API or third-party SDK required |

---

## 6. Non-Goals

- No QR code scanning
- No cloud sync / backup
- No user accounts
- No analytics
- No widget (deferred to future)

---

## 7. Open Questions Resolved

| Question | Resolution |
|----------|------------|
| WiFi format | `WIFI:T:<enc>;S:<ssid>;P:<password>;;` per ISO/IEC 18004:2006 |
| History format | UserDefaults JSON + PNG thumbnails in Documents |
| Min iOS | iOS 16+ |
| UI framework | SwiftUI |
| QR library | Native CoreImage only — no third-party |

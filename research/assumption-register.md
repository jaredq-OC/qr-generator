# Assumption Register — QR Code Generator App

| ID | Assumption | Why | Risk if False | Validation |
|----|-----------|-----|---------------|------------|
| AS-01 | Minimum iOS deployment target: iOS 16 | SwiftUI `shareLink` and modern APIs; iOS 16 has 96%+ adoption | If iOS 15 needed: use older APIs for share sheet | Dev validates against target |
| AS-02 | History stored as 100x100 PNG thumbnails + JSON metadata in UserDefaults | Standard iOS pattern for small binary + structured data | If storage too slow: switch to pure metadata (regenerate on view) | Dev tests with rapid saves |
| AS-03 | QR correction level "M" (15%) is sufficient | Standard for most use cases; H is more dense | If scannability is poor: upgrade to "L" or "M" | Dev generates test QR codes and scans |
| AS-04 | No need for a Settings screen beyond appearance toggle | Only one setting (appearance); can use toolbar/sheet | If more settings added: refactor to dedicated Settings view | Brief specifies only appearance |
| AS-05 | Single-screen layout with segmented picker | Simplest for a 3-type tool; no multi-screen navigation | If UX feels cramped: split into 3 type-specific screens | Dev builds prototype; Kirt reviews |
| AS-06 | WiFi QR uses "WPA" as the default/target encryption type | Most common; brief doesn't specify | If WEP common: add picker with WPA/WEP/nopass options | Dev includes picker |
| AS-07 | UserDefaults is sufficient for 10-entry history | ~10 small structs + 10 PNGs (~200KB total) | If data grows: migrate to SwiftData or file-based | Dev confirms startup time |

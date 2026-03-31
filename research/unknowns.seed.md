# Unknowns Seed — QR Code Generator App

Seed questions to drive Stage 1 research:

## UX/UI
- AS-UX-01: What is the primary screen layout? Single screen with segmented input types, or separate tabs for URL/text/WiFi?
- AS-UX-02: How should the QR code be displayed — inline in the same view or in a modal after generation?
- AS-UX-03: How is the WiFi QR structured exactly (encryption type enum, handling special characters in SSID/password)?
- AS-UX-04: What does the history list look like — thumbnails, timestamps, type indicators?
- AS-UX-05: How is the appearance toggle exposed — settings screen or toolbar control?

## Technical
- AS-TECH-01: What is the minimum iOS deployment target? (assume iOS 16+ given SwiftUI modern patterns)
- AS-TECH-02: Should history be stored as full images or just metadata + regenerate on view?
- AS-TECH-03: How to handle WiFi payload special characters (semicolons, backslashes in SSID/password)?
- AS-TECH-04: What image format for stored history thumbnails? PNG vs JPEG vs HEIC?
- AS-TECH-05: SwiftUI vs UIKit — which to use for the main interface?

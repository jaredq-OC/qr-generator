# Risk Register — QR Code Generator App

| ID | Risk | Likelihood | Impact | Mitigation | Status |
|----|------|-----------|--------|------------|--------|
| RSK-01 | User enters invalid URL and QR scans to nothing | medium | low | Auto-prepend `https://` if no scheme detected | mitigated |
| RSK-02 | WiFi SSID/password with special chars breaks QR | medium | medium | Escape `;`, `\`, `:` per spec before encoding | mitigated |
| RSK-03 | History thumbnail storage grows unbounded over time | low | low | 100px thumbnails only; limit 10 entries FIFO | mitigated |
| RSK-04 | Clipboard fails silently on copy | very low | low | Show confirmation overlay (checkmark animation) | mitigated |
| RSK-05 | Very long text/URL exceeds QR code capacity | low | medium | Use high error correction (M level) + warn user if content very long | mitigated |
| RSK-06 | App runs on device without network (expected — fully offline) | N/A | N/A | No network dependencies — this is the design | resolved |
| RSK-07 | XcodeGen wrong path used | high | high | Always use `/usr/local/bin/xcodegen` | mitigated (KB-flagged) |
| RSK-08 | Widget support becomes desired after initial build | low | medium | Architecture separates QR logic into reusable service for future WidgetKit | deferred |

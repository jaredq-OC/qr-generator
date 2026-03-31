# Errors Log — QR Code Generator


## [2026-03-31 20:51] TASK-06 / Smoke Test Gate — FAILURES

### Failed Checks
- **LAUNCH**: FAIL
- **UITESTS**: FAIL

### Screenshots Captured
- projects/qr-generator/active/screenshots/smoke/20260331-205126-01-launch-FAIL.png
- projects/qr-generator/active/screenshots/smoke/20260331-205129-02-home-screen-PASS.png
- projects/qr-generator/active/screenshots/smoke/20260331-205138-99-final-FAIL.png

### Action Required
Dev continues autonomously — fixing layout/functional issues before re-running smoke test.
Layout issues MUST surface screenshot to Kirt if not resolved after 2 attempts.

## [2026-03-31 21:56] Handoff Blocker
Error: GitHub authentication invalid — cannot create/push to dedicated repo
Layer: DEPLOY
Root Cause: gh auth token expired or revoked (per TOOLS.md note about token exposure)
Impact: Cannot complete handoff — repo push blocked
Resolution: Kirt needs to re-authenticate gh CLI or provide new GitHub PAT
Evidence: `gh auth status` shows "token is invalid" for jaredq-OC account

## [2026-03-31 21:18] Kirt Rejection — Startup Unresponsiveness
Error: App feels dead/blocked on launch; first interaction slow
Layer: L4-UI / L1-Startup
Root Cause (suspected): 
  1. HistoryThumbnail.loadThumbnail() called synchronously in view body — 10 file reads on main thread
  2. loadHistory() called on onAppear — blocks on UserDefaults + 10 thumbnail file reads
  3. No lazy/async thumbnail loading — all thumbnails render at once
  4. Result accumulator timeout: 3.000000 suggests main thread is blocked for 3s+
Impact: App appears frozen on launch before becoming interactive
Resolution in progress:
  - Make HistoryThumbnail load images asynchronously
  - Defer history loading until after first render
  - Show placeholder until thumbnail loaded
  - Use Task { } for async history loading
Evidence: Log lines from Kirt's testing session

## [2026-03-31 21:20] TASK-06 / Smoke Test Gate — FAILURES

### Failed Checks
- **LAUNCH**: FAIL
- **UITESTS**: FAIL

### Screenshots Captured
- projects/qr-generator/active/screenshots/smoke/20260331-212044-01-launch-FAIL.png
- projects/qr-generator/active/screenshots/smoke/20260331-212047-02-home-screen-PASS.png
- projects/qr-generator/active/screenshots/smoke/20260331-212056-99-final-FAIL.png

### Action Required
Dev continues autonomously — fixing layout/functional issues before re-running smoke test.
Layout issues MUST surface screenshot to Kirt if not resolved after 2 attempts.

## [2026-03-31 21:33] Kirt Rejection — REV-2 (Startup still glitchy)
Error: 23-second gesture gate blocking — system gesture recognizer blocked for 23.1 seconds
Layer: L4-UI / L1-MainThread
Root Cause (in progress): 
  - 10x HistoryThumbnail each fire .task {} immediately on render
  - 10 concurrent async thumbnail loads competing for main thread during layout
  - SwiftUI view body recomputation during first render may trigger excess layout passes
  - .task {} in ForEach fires synchronously as part of view evaluation on iOS 16
Impact: 23-second main thread blocking during early startup; gesture system times out
Evidence: [_UISystemGestureGateGestureRecognizer: ...] blocking for 23.101880 seconds
  UIScrollViewPanGestureRecognizer: failed(touchesEnded)
  UIScrollViewDelayedTouchesBeganGestureRecognizer: failed(delayedTouchesDenied)
Resolution in progress:
  - Stagger thumbnail loading with Task.sleep between each load
  - Use LazyHStack for history (only renders visible items)
  - Defer entire history load by 1 second after view appears
  - Reduce concurrent load burst

## [2026-03-31 21:40] TASK-06 / Smoke Test Gate — FAILURES

### Failed Checks
- **LAUNCH**: FAIL
- **UITESTS**: FAIL

### Screenshots Captured
- projects/qr-generator/active/screenshots/smoke/20260331-214017-01-launch-FAIL.png
- projects/qr-generator/active/screenshots/smoke/20260331-214020-02-home-screen-PASS.png
- projects/qr-generator/active/screenshots/smoke/20260331-214029-99-final-FAIL.png

### Action Required
Dev continues autonomously — fixing layout/functional issues before re-running smoke test.
Layout issues MUST surface screenshot to Kirt if not resolved after 2 attempts.

## [2026-03-31 22:14] Kirt Rejection — REV-3

### Issue 1: UI Overlap Bug
Error: Settings button overlaps WiFi button — layout constraint failure
Layer: L4-UI / Layout
Root Cause (suspected): Settings button VStack overlay with Spacer() overlaps input section on smaller screens or when keyboard appears
Resolution: Fix GeneratorView layout — move settings button out of overlay ZStack into safe toolbar, or use .safeAreaInset()

### Issue 2: Auto Layout Keyboard Constraint Error
Error: TUIKeyplane.height == 224 vs _UITemporaryLayoutHeight == 258 — constraint conflict at runtime
Layer: L4-UI / Keyboard
Root Cause: System keyboard view conflicting with app layout when text field becomes first responder
Resolution: Wrap text fields in safe-area-respecting container; avoid pinning views that conflict with keyboard layout

### Issue 3: fopen failed for data file (errno 2)
Error: Something in the app/simulator is trying to open a missing data file
Layer: L1-Startup / I/O
Root Cause: Investigating — likely a system file path not created, or UserDefaults corruption
Resolution: Investigate which path; add graceful fallback

## [2026-03-31 22:17] TASK-06 / Smoke Test Gate — FAILURES

### Failed Checks
- **LAUNCH**: FAIL
- **UITESTS**: FAIL

### Screenshots Captured
- projects/qr-generator/active/screenshots/smoke/20260331-221714-01-launch-FAIL.png
- projects/qr-generator/active/screenshots/smoke/20260331-221717-02-home-screen-PASS.png
- projects/qr-generator/active/screenshots/smoke/20260331-221726-99-final-FAIL.png

### Action Required
Dev continues autonomously — fixing layout/functional issues before re-running smoke test.
Layout issues MUST surface screenshot to Kirt if not resolved after 2 attempts.

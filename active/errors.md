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

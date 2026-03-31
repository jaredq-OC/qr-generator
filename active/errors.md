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

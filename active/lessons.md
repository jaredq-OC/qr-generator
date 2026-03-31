# Lessons Log — QR Code Generator


## [2026-03-31 21:57] Lesson (PROBATION) — gh auth intermittent failure
What: gh auth status showed invalid token on first attempt, but was fine on retry 2 minutes later
Source: Attempt 3 vs Attempt 4
Context: Cron/session context may have different keychain access than interactive shell
Supporting Entries: Attempt 3 (fail), Attempt 4 (pass)
Status: PROBATION — needs more data points to understand if this is a known issue

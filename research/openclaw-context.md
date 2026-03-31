# OpenClaw Context — QR Code Generator App

## Environment Snapshot

- **Platform:** macOS (headless MacBook Pro, no display)
- **XcodeGen:** `/usr/local/bin/xcodegen` (homebrew 2.45.3 — working)
- **Swift:** Apple Swift version 6.2.3
- **Available iOS Simulators:** iOS 17.5 (iPhone 15 Pro, etc.)
- **Active simulator ID:** `DD1443D2-B7FE-4A64-8ED6-FB4F4C5E0336` (iPhone 17 — macOS 26.3.1)
- **Workspace root:** `/Users/jared/.openclaw/workspace`

## OpenClaw Integration

- **INT-00:** This is a standalone iOS app. No OpenClaw integration required.
- The app has no touchpoints to OpenClaw systems, messaging channels, or workspace files.

## Key XcodeGen Note (from KB)
- `/Users/jared/bin/xcodegen` is a broken 9-byte stub — do NOT use
- Always use `/usr/local/bin/xcodegen`
- Always `cd` to project root before generating (xcodegen resolves paths relative to CWD)

## Git Credentials Note (from KB)
- If git push hangs, use `credential.helper=store` and stored credentials
- Use `timeout 60 git push` to avoid indefinite hangs

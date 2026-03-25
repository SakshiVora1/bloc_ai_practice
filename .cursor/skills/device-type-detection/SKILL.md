---
name: device-type-detection
description: Detect device form factor and adapt UI behavior. Use when implementing responsive layouts or device-specific UX handling.
---

# Device Type Detection

Use this skill when UI behavior depends on whether the app is running on phone, tablet, desktop, or web contexts.

## Use when

- Defining responsive breakpoints for layout switching.
- Adjusting navigation patterns (drawer, rail, bottom nav) by device class.
- Enabling or disabling interactions based on input modality.

## Suggested approach

1. Classify device type from screen constraints and platform context.
2. Expose device classification via helper/service for reuse.
3. Keep feature widgets focused on rendering decisions instead of detection logic.

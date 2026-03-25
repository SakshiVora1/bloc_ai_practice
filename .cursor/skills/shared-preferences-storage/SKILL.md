---
name: shared-preferences-storage
description: Persist lightweight local key-value data with shared preferences. Use when storing simple user/session flags and app settings.
---

# Shared Preferences Storage

Use this skill when data is lightweight, local-only, and key-value oriented.

## Use when

- Saving onboarding completion flags.
- Storing non-sensitive UI preferences.
- Caching small session helpers that do not require relational structure.

## Suggested approach

1. Define clear key names and ownership per feature.
2. Wrap read/write operations in a small service or repository.
3. Keep serialization simple and explicit for maintainability.

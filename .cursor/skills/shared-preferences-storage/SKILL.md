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
2. Wrap read/write operations in a small service or repository under `lib/core/services/` or feature's `data/` layer.
3. Keep serialization simple and explicit for maintainability.
4. Do not store sensitive data (tokens, passwords) in shared preferences without encryption.

## Layer Boundaries

- The storage service belongs in the **data layer**, not in Bloc or UI.
- Bloc calls the storage service through a repository if needed.
- Do not call shared preferences directly from widgets.

## Key Naming Convention

Centralize keys (this project uses **`AppPreferencesKeys`** in `lib/core/constants/app_preferences_keys.dart`). Example pattern:

```dart
abstract final class AppPreferencesKeys {
  AppPreferencesKeys._();
  static const String loginResponse = 'login_response';
}
```

## Don'ts

- **Don't** store large or complex data structures—use a database instead.
- **Don't** scatter preference keys across the codebase—centralize them.
- **Don't** access preferences directly from Bloc or UI layers.

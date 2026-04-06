---
name: flutter-package-install
description: Install Flutter packages and run pub get. Use when adding dependencies, installing packages, or when the user asks to add a Flutter package.
---

# Flutter Package Installation

## Add a package

```bash
flutter pub add {{package_name}}
```

This updates `pubspec.yaml` automatically.

## After adding packages

```bash
flutter pub get
```

Run this to install/fetch the new dependencies.

## Workflow

1. `flutter pub add <package_name>`
2. `flutter pub get`

## New image or asset files

When you add files under `assets/`:

- Declare them in **`pubspec.yaml`** if not already covered by an existing asset entry.
- Register the path in **`AppAssets`** (`lib/core/constants/app_assets.dart`). **Search that file first** for the same path string — if a constant already exists for that path, **reuse it**; do not add a duplicate constant. The same rule applies to **`AppStrings`** and **`AppColors`**: one literal value should map to **one** centralized name (see **`.cursor/rules/flutter-assets.mdc`**).

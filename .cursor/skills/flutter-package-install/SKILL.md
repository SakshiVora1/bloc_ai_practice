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

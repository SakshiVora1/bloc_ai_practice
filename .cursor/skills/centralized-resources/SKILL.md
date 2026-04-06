---
name: centralized-resources
description: Add or reuse AppStrings, AppAssets, AppColors, and shared typography without duplicating identical literals. Use when introducing user-facing copy, asset paths, colors, or central constants.
---

# Centralized strings, assets, and colors

1. Use **`AppStrings`**, **`AppAssets`**, **`AppColors`**, and the project’s typography helpers (`lib/core/constants/`) — do not hardcode the same value in widgets or BLoCs.
2. **Before adding a new constant**, search the relevant file for the **same literal** (identical copy, asset path, or color value).
3. If it already exists, **reuse that constant’s name** everywhere — do **not** create another variable for the same value.
4. If it does not exist, add **one** new member and reference it from all call sites that need that value.

Full rules: **`.cursor/rules/flutter-assets.mdc`**.

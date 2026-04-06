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
2. Expose device classification via helper/service under `lib/core/services/` or `lib/core/utils/` for reuse (this repo includes **`DeviceInfoService`** for platform/device metadata where needed).
3. Keep feature widgets focused on rendering decisions instead of detection logic.
4. **Default to `MediaQuery`** (`sizeOf`, `padding`, `orientation`) for breakpoints and viewport-relative layout. **Use `LayoutBuilder` only when required:** the UI must branch on **this widget’s allocated constraints** (not the same as the full window), e.g. inside `Expanded`, split panes, or when max width/height from the parent drives layout. If you can answer the question with `MediaQuery` alone, **do not** add `LayoutBuilder`.

## When `LayoutBuilder` is justified (examples)

- Horizontal scroll of a wide table: `maxWidth` from `LayoutBuilder` vs a minimum content width.
- Adaptive column counts where the **parent** width is not the screen width.
- Any case where **`constraints.maxWidth` / `maxHeight` from the parent** must drive branching and **`MediaQuery.sizeOf` would be wrong**.

## When to avoid `LayoutBuilder`

- Global breakpoints (phone vs tablet) based on the **window** — use **`MediaQuery`**.
- Padding, keyboard inset, text scale — use **`MediaQuery`** (and related APIs), not `LayoutBuilder`.

## Breakpoint Pattern

```dart
abstract final class DeviceBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

enum DeviceType { mobile, tablet, desktop }

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < DeviceBreakpoints.mobile) return DeviceType.mobile;
  if (width < DeviceBreakpoints.tablet) return DeviceType.tablet;
  return DeviceType.desktop;
}
```

## Centralized Constants

Place breakpoints and device-related constants in `lib/core/`:

```
lib/core/
  constants/
    device_breakpoints.dart
  utils/
    device_utils.dart
```

## Don'ts

- **Don't** scatter breakpoint values across widgets—centralize them.
- **Don't** put complex detection logic inside widget `build` methods.
- **Don't** hardcode device-specific values in feature code.
- **Don't** use **`LayoutBuilder`** for screen-level responsive choices when **`MediaQuery.sizeOf(context)`** (or orientation / padding) is sufficient — see **`.cursor/rules/flutter-development.mdc`** (Responsive layout).

# Code Consistency & Reusability Rules

## Objective
Keep the codebase consistent, highly reusable, and free from duplication by:
- Centralizing images, strings, colors, and fonts
- Reusing shared models and UI widgets in the correct scope
- Extracting logic out of views and into the appropriate layer

## 1) Centralize Assets, Strings, Colors, and Fonts

### Images / SVG / Lottie
- Never hardcode asset paths like `assets/images/image.svg` directly inside widgets.
- Always declare asset paths once in `lib/core/constants/app_images.dart` (class: `AppImages`) as `static const String`.
- Reuse existing constants; if the constant doesn’t exist yet, add it and reuse it everywhere.

Example (usage in UI):
```dart
SvgPicture.asset(AppImages.subqdocsWhite);
```

Example (constant declaration):
```dart
class AppImages {
  static const String subqdocsWhite = 'assets/images/subqdocs_white.svg';
}
```

### Strings
- Never hardcode user-facing strings directly in widgets.
- Define strings once in `lib/core/constants/app_strings.dart` (class: `AppStrings`) as `static const String`.
- Reuse constants; only add new ones when needed.

### Colors
- Never use inline `Color(0xFF...)` or hex values directly in widgets.
- Define colors once in `lib/core/constants/app_colors.dart` (class: `AppColors`) as `static const Color`.
- Reuse existing colors; add new ones only when required.

### Fonts (TextStyles)
- Do not create `TextStyle(...)` directly inside widgets.
- Instead, define centralized `TextStyle` factories in `lib/core/constants/app_fonts.dart` (class: `AppFonts`).
- Widgets must use the returned `TextStyle` from these static functions (so `Text(style: AppFonts.someStyle(...))`).

Example (usage in UI):
```dart
Text(
  AppStrings.firstName,
  style: AppFonts.titleStyle(size: 20),
);
```

Example (style factory):
```dart
class AppFonts {
  static TextStyle titleStyle({double size = 20, Color? color}) {
    return TextStyle(
      fontSize: size,
      color: color ?? AppColors.primary,
      // keep the rest of the typography centralized here
    );
  }
}
```

## 2) Choose Reuse Scope (Avoid Duplication)
Use the same decision rule everywhere:
- If something is used across multiple screens/features: create it in the global/shared location.
- If it’s only used inside one screen/feature: create it in that feature’s folder.

## 3) Model Placement Rule

### Global (commonly used everywhere)
- If a model is commonly used across the whole app, place it in:
  - `lib/data/models/`

### Feature-specific (not widely used)
- If a model is only relevant to a specific feature/screen, place it inside that feature, for example:
  - `lib/screens/<feature_name>/models/`

Decision checklist:
- If you expect future features to reuse it broadly -> `lib/data/models/`
- If it is tied to one feature’s API/UI contract -> `lib/screens/<feature_name>/models/`

## 4) UI / Widget Placement Rule

### Global reusable UI
- If a UI component is used across multiple features/screens, place it inside:
  - `lib/widgets/`

### Feature-level reusable UI
- If a UI component is reused within only one feature, place it inside:
  - `lib/screens/<feature_name>/widgets/`
- If the feature doesn’t have a `widgets/` folder yet, create it.

Notes:
- Keep `lib/screens/<feature_name>/widgets/` for reusable UI pieces (button variations, common form fields, small layout components, etc.).
- Keep screen-specific page widgets inside `lib/screens/<feature_name>/view/` (or your existing screen page folder) unless they’re meant to be reused.

## 5) Logic Separation (Consistency within Features)
- Views (UI) should stay “dumb”: they should render based on state and trigger events.
- Put business logic in the appropriate layer (typically inside `{{feature_name}}_bloc.dart` / bloc, and use repositories/services for IO).
- Avoid putting duplicated logic inside multiple widgets; extract shared logic into blocs, services, or reusable widgets based on usage scope.

## 6) Naming & Maintenance Rules
- Always use consistent naming: `AppImages`, `AppStrings`, `AppColors`, `AppFonts`.
- Reuse existing constants/widgets/models before creating new ones.
- When duplication is found, extract the common part and replace usages across the project.

---
## Quick “Do / Don’t” Summary
Do:
- Use `AppImages`, `AppStrings`, `AppColors`, `AppFonts` from `lib/core/constants/`
- Put global models in `lib/data/models/`
- Put global widgets in `lib/widgets/`
Don’t:
- Hardcode asset paths, strings, or `Color(...)` in widgets
- Create `TextStyle(...)` directly in widgets
- Duplicate models/widgets that can be shared by scope rules above


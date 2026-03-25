# Project Coding Rules

## 🎯 Objective
Ensure consistency, reusability, and avoid duplication across the project by centralizing images, strings, and colors.

## Images, SVG && lottie
- Ensure that always create static constant variable in a dedicated file (Eg: AppImages).
- Do not use raw strings directly in widgets.

### Steps to Follow:
- Before creating a new constant , check that particular (images, svg or lottie) exists.
- If exists then reuse that.
- If not exists then create new constant.

### Example:
```dart
class AppImages {
  static const subqdocsWhite = 'assets/images/subqdocs_white.svg';        
}
```

## String
- Ensure that always create static constant variable in a dedicated file (Eg: AppStrings).
- Do not use hardcode strings directly in widgets.

### Steps to Follow:
- Before creating a new constant , check that particular strings exists.
- If exists then reuse that.
- If not , then create new constant.

### Example:
```dart
class AppStrings {
  static const firstName = 'First Name';        
}
```

## Colors
- Ensure that always create static constant variable in a dedicated file (Eg: AppColors).
- Do NOT use inline Color() or hex values directly.

### Steps to Follow:
- Before creating a new constant , check that particular strings exists.
- If exists then reuse that.
- If not , then create new constant.

### Example:
```dart
class AppColors {
  static const primary = Color(0xFF123456);
}
```
## UI
- Global Reusable UI:
  - If a UI component is used across multiple features/screens:
    - Create a common stateless widget
    - Place it inside:
        - lib/widgets/
- Feature-Level Reusable UI :
  - If a UI component is reused only within a specific feature:
    - Create a widget inside that feature:
      - lib/screens/<feature_name>/widgets/


## General Rules
- Avoid duplication at all costs.
- Always prefer reuse over creation.
- Keep naming consistent and meaningful.
- Always use Bloc provider inside the `app_routes` file instead using in ui.

## Do not use
- Do not use `setstate` anywhere , always use Bloc state only.
- Do not create any function inside the view always create the logic inside the `{{feature_name}}_bloc.dart` file.
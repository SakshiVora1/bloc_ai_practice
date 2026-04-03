# Skills reference (narrow workflows only)

Most conventions live in **`.cursor/rules/*.mdc`**, **`AGENTS.md`**, and **`docs/rules_flutter_bloc_effective_dart_clean_architecture.md`**. **This file** lists only the **remaining optional skills** under **`.cursor/skills/`**.

## When to open which skill

| Skill folder | Use when |
|--------------|----------|
| `flutter-package-install` | Adding or upgrading packages; `flutter pub add`, `flutter pub get`. |
| `prompt-to-docs-plan` | User asks for a plan or impact write-up under **`docs/`**. |
| `shared-preferences-storage` | Lightweight local key-value persistence (wrap reads/writes; keys like **`AppPreferencesKeys`**). |
| `device-type-detection` | Responsive layouts or behavior by form factor / breakpoints. |

## Rules for everything else

- **BLoC, feature layout, toasts, repositories:** **`flutter-development.mdc`**, **`bloc-patterns.mdc`**, **`repository-boundaries.mdc`**
- **URLs / env:** **`environment-urls.mdc`**
- **Assets / strings / colors / fonts:** **`flutter-assets.mdc`**
- **JSON models:** **`model-serialization.mdc`**
- **Routing:** **`routing-conventions.mdc`**

## Effective Dart

Follow [Effective Dart](https://dart.dev/effective-dart) and **`flutter-development.mdc`** — there is no separate **`effective-dart.mdc`**.

## External resources (optional)

- [BLoC documentation](https://bloclibrary.dev/)

# Code Consistency, Reusability & Duplication-Avoidance Plan

**Source**: [docs/rules.md](../docs/rules.md)

## Objective

Maintain consistent code style, maximize reuse, and avoid duplication across the project by following:

- Centralizing assets, strings, colors, and fonts
- Reusing shared UI components and models in the correct scope
- Keeping architecture clean (UI is dumb, Bloc coordinates, IO/business logic is outside the UI)
- Centralizing environment & URL management (no hardcoded URLs)

---

## Core Workflow (Follow for Every Feature)

1. **Identify Scope First (Global vs Feature-Level)**

   - If reusable across multiple features → treat as **Global**
   - If specific to one feature → treat as **Feature-Level**

2. **Reuse Before Creating**

   - Always search for existing constants/components/models before adding new ones

3. **Place Code in the Correct Layer**

   - Follow placement rules strictly (see sections below)

4. **Keep Responsibilities Clean**

   - UI → renders + dispatches events
   - Bloc → coordinates logic + emits states
   - Repository/UseCase → handles IO/business logic

5. **Keep States Minimal & Meaningful**

   - Required states: `initial`, `loading`, `success`, `error`
   - Do NOT use Equatable — ensure proper state emission and structure instead

6. **Validate Dependencies**

   ```bash
   flutter pub add <package_name>
   flutter pub get
   ```

---

## 1. Centralization Rules

### Images / SVG / Lottie

* Declare all assets in: `lib/core/constants/app_images.dart`
* Use `AppImages` instead of hardcoded paths

```dart
class AppImages {
  static const subqdocsWhite = 'assets/images/subqdocs_white.svg';
}
```

---

### Strings

* Define all user-facing strings in: `lib/core/constants/app_strings.dart`
* Never hardcode strings in UI

```dart
class AppStrings {
  static const firstName = 'First Name';
}
```

---

### Colors

* Do NOT use inline `Color(0xFF...)`
* Define all colors in: `lib/core/constants/app_colors.dart`

---

### Fonts (TextStyles)

* Do NOT create `TextStyle(...)` inside widgets
* Use centralized styles from: `lib/core/constants/app_fonts.dart`

```dart
Text(
  AppStrings.firstName,
  style: AppFonts.titleStyle(size: 20),
);
```

---

## 2. UI Widget Placement Rules

### Global Widgets

* Used across multiple features
* Location: `lib/widgets/`

### Feature-Level Widgets

* Used within a single feature only
* Location:

```
lib/screens/<feature_name>/widgets/
```

---

## 3. Model Placement Rules

### Global Models

* Shared across features
* Location:

```
lib/data/models/
```

### Feature-Specific Models

* Tied to one feature
* Location:

```
lib/screens/<feature_name>/models/
```

---

## 4. BLoC Architecture Rules

### Bloc Scope

* One **Bloc per Feature**

---

### Keep UI Dumb

UI should ONLY:

* Dispatch events
* Listen to states

❌ Do NOT use `setState` with Bloc

---

### Keep Logic Clean

* ❌ No API calls inside Bloc
* ✅ Use Repository / UseCase layer
* Bloc should ONLY coordinate and emit states

---

### State Rules

* Must include:

    * `initial`
    * `loading`
    * `success`
    * `error`

* States must be:

    * Immutable (`final` fields)
    * Minimal and clear

* Always handle errors:

```dart
try {
  // logic
} catch (e) {
  emit(ErrorState(message: e.toString()));
}
```

---

### UI Usage Pattern

* `BlocBuilder` → UI rendering
* `BlocListener` → Side effects (navigation, snackbar, dialogs)

---

### Bloc Injection

* Global Bloc → `main.dart`
* Feature Bloc → `app_routes.dart`

---

## 5. Project Structure & Naming

### Feature Structure

```
lib/screens/<feature_name>/
│
├── bloc/
│   ├── <feature_name>_bloc.dart   (main file with part directives)
│   ├── <feature_name>_event.dart  (part of bloc)
│   └── <feature_name>_state.dart  (part of bloc)
│
├── view/
│   └── <feature_name>_view.dart
│
├── widgets/
│   └── (feature reusable widgets)
│
└── models/
    └── (feature-specific models)
```

Bloc file convention: Use `part`/`part of` — main bloc has `part '..._event.dart'` and `part '..._state.dart'`; event/state files use `part of '..._bloc.dart'`, `sealed class` for base types, `final class` for concrete states/events.

---

### Naming Convention

* Use **snake_case** for all files

Examples:

* `auth_repository.dart`
* `profile_view.dart`

---

## 6. Dependency Management

### Add Package

```bash
flutter pub add <package_name>
```

### Install Dependencies

```bash
flutter pub get
```

---

## 7. Quick Do / Don't Summary

### ✅ Do

* Reuse before creating
* Centralize assets, strings, colors, fonts
* Choose correct scope (global vs feature)
* Keep UI dumb and logic layered

### ❌ Don't

* Hardcode assets, strings, or colors
* Create `TextStyle(...)` inside widgets
* Use `setState` with Bloc
* Call APIs inside Bloc
* Create unnecessary states

---

---

## 8. Environment & URL Management

### Principle

- **No hardcoded URLs anywhere** in the project
- All API/socket base URLs must come from `UrlService` only

### Architecture

1. **Environment enum** (`lib/core/config/environment.dart`)

   - Cases: `dev`, `ngrok`, `stage`, `prod`
   - Getters read from `.env` via `dotenv.get(...)`:
     - `baseUrl` → DEV_URL, NGROK_URL, STAGE_URL, PROD_URL
     - `patientChatBaseUrl` → PATIENT_CHAT_DEV_URL, etc.
     - `socketUrl` → SOCKET_DEV_URL, etc.
     - `viteCryptoSecretKey` → VITE_CRYPTO_SECRET_KEY

2. **AppConfig** (static global env)

   - `_currentEnvironment` defaulting to `Environment.dev`
   - Setter `environment` and getter `environment`
   - Derived getters: `baseUrl`, `socketUrl`, `patientChatSocketUrl`, `viteCryptoSecretKey`
   - Bootstrap: set `AppConfig.environment` from `ENV` flag at app start

3. **UrlService** = single access point

   - Exposes only what the app needs: `baseUrl`, `patientChatSocketUrl`, `viteCryptoSecretKey`
   - UI/BLoC/Repos must NOT call `dotenv` directly
   - No manual URL building outside `UrlService`

4. **Scalability**

   - New environments = add enum case + dotenv key; callers stay unchanged

### Required `.env` Variables (Template)

```
ENV=dev
DEV_URL=
NGROK_URL=
STAGE_URL=
PROD_URL=
PATIENT_CHAT_DEV_URL=
PATIENT_CHAT_NGROK_URL=
PATIENT_CHAT_STAGE_URL=
PATIENT_CHAT_PROD_URL=
SOCKET_DEV_URL=
SOCKET_NGROK_URL=
SOCKET_STAGE_URL=
SOCKET_PROD_URL=
VITE_CRYPTO_SECRET_KEY=
```

### Do / Don't

- ✅ Get URLs via `UrlService` only
- ❌ Do NOT hardcode URLs anywhere
- ❌ Do NOT bypass `UrlService` for API/socket base URLs

---

## Final Rule

> Always think: **Can this be reused? If yes → make it global. If no → keep it scoped.**

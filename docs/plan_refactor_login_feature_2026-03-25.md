# ♻️ Login Feature Refactor Plan (BLoC)
> **Feature Path:** `lib/screens/login/`
>
> **Constraints:** do not change functionality; structure/quality only.

---

## 🎯 Goals
- **Readability**: reduce widget size, clarify responsibilities, improve naming/structure
- **Performance**: avoid recreating controllers/notifiers every build; reduce unnecessary rebuild work
- **Duplication**: extract reusable decorations/validators/widgets for this feature
- **BLoC compliance**: UI dispatches events + reacts to state; repository stays data-only

---

## 📍 Current Snapshot (What’s there today)
- **UI**: `view/login_view.dart`
  - Creates `TextEditingController`s and `ValueNotifier`s inside `build()` (recreated each rebuild)
  - Inline `_validate()` regex logic in same file
  - Uses `BlocListener` for side effects (snackbars) and also to push field error strings into notifiers
- **BLoC**: `bloc/login_bloc.dart` + `login_event.dart` + `login_state.dart`
  - Emits `initial → loading → success|failure`
  - Has `LoginInvalid` state for field errors
  - Calls `AuthRepository.login()` and maps `ApiException` to `LoginFailure`

---

## ✅ Refactor Steps (File-by-file)

### 1) Stabilize UI state lifecycle (no behavior changes)
- **Change**: Convert `LoginView` from `StatelessWidget` to `StatefulWidget`
- **Move to State**:
  - `emailController`, `passwordController`
  - `emailError`, `passwordError`, `rememberMe`, `obscurePassword`
- **Add**: proper `dispose()` for controllers and notifiers
- **Reason**: prevents leaks and avoids losing input/error state on rebuild

### 2) Extract validation into a small feature utility
- **Create**: `lib/screens/login/utils/login_validators.dart`
  - `validate_login_form(email, password)` returning `Map<String, String>`
  - Keep exact validation rules/messages (email regex, password regex, `AppStrings.*`)
- **Update**: `login_view.dart` to call the extracted validator
- **Reason**: smaller view file, easier testing/maintenance, avoids duplication later

### 3) Extract small widgets (feature-scoped)
- **Create**: `lib/screens/login/widgets/login_banner.dart` (existing `_LoginBanner`)
- **Create**: `lib/screens/login/widgets/labeled_field.dart` (existing `_LabeledField`)
- **Create (optional)**: `lib/screens/login/widgets/login_input_decoration.dart`
  - contains the existing `_inputDecoration()` factory
- **Update**: `login_view.dart` to use these widgets
- **Reason**: keep view focused on layout + wiring, enable reuse within the feature

### 4) Layout pass: remove unnecessary `LayoutBuilder` if possible
- **Rule**: prefer `MediaQuery` unless parent constraints are required.
- **Action**: attempt a `MediaQuery`-driven min-height solution; keep current behavior (scroll + bottom insets).
- **Fallback**: if removing `LayoutBuilder` subtly changes sizing, keep it (constraints genuinely needed).

### 5) BLoC + repository boundaries check
- **Keep**: validation in UI (per `.cursor/rules/bloc-patterns.mdc`)
- **Keep**: repository as data mapping only (per `.cursor/rules/repository-boundaries.mdc`)
- **Optional improvement**: ensure error messages are user-safe (avoid raw `toString()`), without changing what users see today unless already inconsistent.

---

## 🧪 Verification / Test Plan
- **Manual**:
  - Type email/password, toggle show password, toggle remember me
  - Submit with invalid email/password and confirm inline error text matches current messages
  - Submit with API failure and confirm snackbar shows same message
  - Submit success and confirm snackbar shows “Login successful”
- **Automated**:
  - `flutter analyze`
  - `flutter test` (if tests exist)

---

## ⚠️ Risk Hotspots
- **Controller lifecycle**: moving controllers/notifiers into `State` must preserve current text/error behavior
- **Scroll + keyboard insets**: small layout changes can affect bottom padding/min-height; verify on iOS/Android
- **Private widget extraction**: ensure imports don’t create circular deps; keep feature-local widgets under `lib/screens/login/widgets/`
- **Behavior drift**: keep validation regexes and messages identical

---

## `.cursor/` Impact
- **Rules referenced**:
  - `/.cursor/rules/general.mdc` (reuse, snake_case, MediaQuery preference)
  - `/.cursor/rules/bloc-patterns.mdc` (UI validation stays in UI; state flow)
  - `/.cursor/rules/repository-boundaries.mdc` (repo fetch/mapping only)
- **No rule changes required** (plan follows existing guidance)


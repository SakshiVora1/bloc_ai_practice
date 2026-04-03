# Login screen — implementation plan

> **Feature prompt:** `docs/prompt/login.md`  
> **Generator:** `docs/plans.md`

---

## 1. Purpose

- **Goal:** Implement the login screen to match `assets/images/figma/login.png`: full-screen background, branded header, centered form, validated credentials, encrypted password payload, and navigation to home on success.
- **Problem solved:** Users can authenticate against the existing API contract (mapped by `LoginModel`) with consistent BLoC-driven UX, project routing, and environment-aware crypto configuration.

---

## 2. Feature flow

1. User lands on login (e.g. from splash via `Navigator.pushReplacementNamed(RouteNames.login)` — already wired in `SplashScreenView`).
2. Screen shows `login.png` as the full-bleed background; `subqdocs_white.svg` is overlapped **50 logical pixels** from the top (no full-screen padding wrapper).
3. Centered column contains email and password fields, optional chrome from Figma (labels, remember/forgot if in design), and primary **Log In** control.
4. User edits fields; **no validation runs** on focus change or per-keystroke (use `Form` with `AutovalidateMode.disabled` and call `validate()` only from the button handler).
5. On **Log In** tap:
   - Run form validation (email format; password 8–20 chars inclusive; at least one letter, one number, one special character). If invalid, show field errors only — **do not** call the API.
   - If valid, dispatch a submit event with email and **plain** password (or dispatch after encryption in BLoC — see §7).
6. While loading, the **button** shows an inline loader (e.g. `SizedBox` + `CircularProgressIndicator`); rest of screen stays usable or follow Figma for disabled inputs.
7. On API **success** (`response_type` success): emit success state; listener navigates with `pushReplacementNamed(RouteNames.home)` (or project-standard replacement stack).
8. On API **failure**: emit error state; in **`BlocListener`**, call **`AppToast.showError(context, message)`** with a server/user-safe string (not `SnackBar`).

---

## 3. Folder structure (rule-based)

**Create / use**

| Path | Role |
|------|------|
| `lib/screens/login_screen/bloc/` | `login_screen_bloc.dart` + `part` files for events/states (`flutter_bloc`, sealed bases) |
| `lib/screens/login_screen/view/login_screen_view.dart` | Screen layout, `Form`, `BlocBuilder` / `BlocListener` |
| `lib/screens/login_screen/repository/login_repository.dart` | `ApiService.post` (or equivalent) → parse/map to `LoginModel` |
| `lib/screens/login_screen/widgets/` | **Only if** the tree needs feature-local reusable pieces (e.g. styled field wrapper) |

**Existing — adjust imports if aligning with `flutter-development.mdc` / `AGENTS.md`**

| Path | Note |
|------|------|
| `lib/models/login_model.dart` | Already holds API shape. **Prefer** eventual move to `lib/data/models/login_model.dart` per `model-serialization.mdc` / `AGENTS.md`; if kept under `lib/models/`, document as a known deviation until migrated. |
| `lib/core/constants/app_images.dart` | Add constant for Figma background (**do not** hardcode path in widgets). |
| `lib/core/constants/app_strings.dart` | Already contains login copy and validation strings — extend only if Figma needs new text. |
| `lib/core/constants/app_colors.dart`, `app_fonts.dart` | Use for colors/typography from design. |
| `lib/widgets/` | Share only truly app-wide widgets; prefer feature `widgets/` for login-specific composition. |

**Assets**

- Ensure `assets/images/figma/login.png` and `assets/images/subqdocs_white.svg` are declared under `pubspec.yaml` `flutter.assets` (parent `assets/images/` already listed).

---

## 4. BLoC strategy

- **Single feature BLoC:** `LoginScreenBloc` (name aligned with `splash_screen` → `login_screen`).

**Events (sealed hierarchy)**

- `LoginScreenStarted` (optional — prefill, analytics).
- `LoginSubmitted({required String email, required String password})` — fired only after form validation passes in the view.
- Optional: `LoginPasswordVisibilityToggled` if design includes visibility control (preserve other state fields per `bloc-patterns.mdc`).

**States (sealed classes — not enums)**

Baseline quartet + **payloads where needed**, for example:

- `LoginScreenInitial` — optional cached form values if you need to survive rebuilds without losing input.
- `LoginScreenLoading` — include `email` (and optionally `password` is **not** recommended in state; keep password out of emitted state for security; only use loading flag + non-sensitive fields).
- `LoginScreenSuccess` — include `LoginModel` (or minimal `token` / `user` if you want a slimmer state).
- `LoginScreenError` — include `String message` (and optionally `email` for re-display).

**Responsibilities**

- Accept validated credentials from UI.
- Derive encrypted password using **`aescryptojs`** and secret from **`UrlService.viteCryptoSecretKey`** (or `AppConfig.viteCryptoSecretKey` — same source; **never** read `dotenv` in BLoC per `environment-urls.mdc`).
- Call `LoginRepository.login(...)`.
- Inspect **`response_type`** on `LoginModel`:
  - Success → persist/token handling if required by product → emit `LoginScreenSuccess`.
  - Non-success → emit `LoginScreenError` → **`BlocListener`** calls **`AppToast.showError(context, message)`** (needs `BuildContext`).

**Constructor injection**

- `LoginScreenBloc({required LoginRepository loginRepository})`

**Validation vs `bloc-patterns.mdc`**

- Rule: *“Do not move UI validation logic into BLoC.”*  
- **Plan:** Keep regex/length/character rules in the **view** via `Form` + `validator` callbacks that run **only** when the login button calls `formKey.currentState?.validate()`. BLoC handles encryption + API + `response_type` only.

---

## 5. Routing

| Item | Detail |
|------|--------|
| **Route name** | `RouteNames.login` — already `'/'` segment unused; value is `'/login'` (exists). |
| **Registration** | Add entry to `AppRoutes.routes`: `RouteNames.login: (context) => BlocProvider(create: (_) => LoginScreenBloc(loginRepository: LoginRepository()), child: const LoginScreenView())`. |
| **From → to** | Splash → Login (`pushReplacementNamed` — existing). Login success → **Home** (`RouteNames.home`). |
| **Home** | `RouteNames.home` exists but **no** `AppRoutes` entry yet. Add minimal `HomeView` (placeholder) + `BlocProvider` only if home needs a BLoC at first ship; otherwise a `StatelessWidget` scaffold is enough until the home feature exists. |

Thin routes only — no business logic in builders.

---

## 6. UI breakdown

- **Scaffold:** No unnecessary outer `Padding` on the full screen; background fills the stack.
- **Layer 1:** `DecorationImage` / `Image.asset` for `AppImages` entry pointing at `assets/images/figma/login.png` (exact constant name TBD, e.g. `loginBackgroundFigma`).
- **Layer 2:** `SafeArea` optional for notch; logo `Positioned` / `Padding` only **top: 50** for `AppImages.subqdocsWhite` via `flutter_svg`.
- **Layer 3:** `Center` + constrained width (`MediaQuery` / `maxWidth`) for the form card/fields per Figma.
- **Scroll / keyboard:** Wrap body in `SingleChildScrollView` (or `CustomScrollView`) with `keyboardDismissBehavior` if needed; set `resizeToAvoidBottomInset: true` on `Scaffold` so focused fields scroll into view when the keyboard opens; consider `Scrollable.ensureVisible` or focus-aware scroll for tight layouts.
- **BlocBuilder:** Drives button label vs inline `CircularProgressIndicator`, enabled/disabled styling, and any error banners **not** covered by field validators.
- **BlocListener:** `LoginScreenSuccess` → navigation; `LoginScreenError` (API) → **`AppToast.showError`**.
- **Bottom text:** Use `AppStrings.loginBottomNote` — **no** sign-up row.
- **Primary button height:** Prefer **40** logical pixels per app consistency (`AGENTS.md` / design system).

---

## 7. Data flow

```
UI (Form validate on submit) → LoginScreenBloc (encrypt password) → LoginRepository → ApiService.post → JSON → LoginModel → Repository returns model → Bloc checks response_type → UI
```

- **Repository:** Single method, e.g. `Future<LoginModel> login({required String email, required String encryptedPassword})` — builds body per backend contract, calls `ApiService` **only**, returns parsed `LoginModel`. **No** branching on `response_type`, **no** toasts.
- **Encryption:** Package **`aescryptojs: ^1.0.0`** only (per prompt); use API compatible with backend expectations (`encryptAESCryptoJS` or as documented). Secret: **`UrlService.viteCryptoSecretKey`** (maps to `VITE_CRYPTO_SECRET_KEY` in `.env` via existing `Environment` / `AppConfig` stack).
- **BLoC** after success: navigate; optionally persist token via `AppPreferences` / existing keys (`app_preferences_keys.dart` mentions `loginResponse`) — confirm product requirement before writing.

**Login endpoint path:** Not defined in-repo yet; add a single constant (e.g. static on `LoginRepository` or future `UrlService` API path section) when backend path is confirmed — **do not** hardcode full URLs.

---

## 8. Constants & theme

- **Images:** Add `AppImages` entry for `assets/images/figma/login.png`; reuse `AppImages.subqdocsWhite`.
- **Strings / colors / fonts:** Prefer existing `AppStrings`, `AppColors`, `AppFonts`; add missing keys before use.
- **Validation copy:** Prefer `loginRequiredEmail`, `loginInvalidEmail`, `loginPasswordLength`, `loginPasswordLetter`, `loginPasswordNumber`, `loginPasswordSpecial`.

---

## 9. Configuration

- **URLs:** Repository uses `ApiService` with `AppConfig.baseUrl` (already wired in `ApiService`).
- **Crypto key:** Only via `AppConfig` / `UrlService` — **no** `dotenv` in UI, BLoC, or repository.

---

## 10. Dependencies

| Dependency | Role |
|------------|------|
| `flutter_bloc` | Already in project. |
| `flutter_svg` | Logo. |
| `aescryptojs: ^1.0.0` | Password encryption (add via `pubspec.yaml`; run `flutter pub get`). |
| `toastification` | API/user toasts via **`AppToast`** in `lib/core/services/app_toast.dart`. |
| `dio` | Via `ApiService`. |

**Bloc tests:** Add `bloc_test` in `dev_dependencies` if not present, for success/error transitions.

---

## 11. Edge cases

- **Loading:** Only button-level spinner; avoid full-screen blocking unless Figma requires.
- **Validation:** Button-triggered only; empty email/password; invalid email; password length <8 or >20; missing letter/number/special.
- **Keyboard:** Field not visible → scroll into view.
- **API error / network:** `LoginScreenError` + toast; optionally map `LoginModel.message` when provided.
- **Success:** Replace stack to home so back does not return to login unintentionally (match splash → login pattern).
- **Crypto key missing/empty:** Fail fast in BLoC with error state + toast (or assert in debug) — avoid silent wrong payloads.

---

## 12. Rule compliance check

| Rule | Plan alignment |
|------|----------------|
| No hardcoded URLs/strings/colors/assets | Constants + `UrlService` / `AppConfig` |
| `flutter-development.mdc` | Prefer `lib/features/`; legacy plan still references `lib/screens/login_screen/` — align with current tree when implementing |
| `bloc-patterns.mdc` | Sealed events/states; `BlocBuilder` + `BlocListener`; repository injection; `response_type` in BLoC; field validation in view |
| `repository-boundaries.mdc` | Repository → `ApiService` only; no `response_type` branching in repo |
| `routing-conventions.mdc` | `RouteNames` + `AppRoutes.routes` only; thin providers |
| `environment-urls.mdc` | No `dotenv` outside config layer |
| `AGENTS.md` | **`AppToast`** for API errors; no API logic in routes |

---

## 13. Scalability

- Extract shared text field or “primary button with loading” to `lib/widgets/` if other auth screens reuse them.
- Centralize API path constants as the API surface grows (`UrlService` or dedicated paths module).
- Token/session persistence and refresh can plug into `LoginScreenSuccess` without changing repository shape.

---

## Structure validation (pre-implementation)

- [ ] `LoginScreenBloc` lives under `lib/screens/login_screen/bloc/`.
- [ ] `LoginRepository` uses `ApiService` exclusively.
- [ ] `LoginModel` import path decided (`lib/models/` vs `lib/data/models/`).
- [ ] `AppRoutes` includes `login` and `home`.
- [ ] Assets and `.env` key `VITE_CRYPTO_SECRET_KEY` documented for local setup.

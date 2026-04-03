# Splash Screen — Implementation Plan

**Plan name:** Splash screen with branded background, centered logo, and timed navigation to login.

**Feature prompt summary:** Splash screen uses background color `#5B5BE1`, centers `subqdocs_white.svg`, waits **2 seconds**, then navigates to the login screen.

---

## 1. Purpose

- **Goal:** Show a branded splash experience on app launch, then route users to authentication.
- **Problem solved:** Replaces the default counter demo entry with a consistent first screen and predictable handoff to login.

---

## 2. Feature Flow

1. App launches with `initialRoute` set to the splash route.
2. User sees full-screen background `#5B5BE1` and the SubQ Docs white logo centered.
3. After **2 seconds**, the app navigates to the login route (replace or push as per routing choice — prefer **replace** so the user cannot back-navigate to splash).
4. (Optional later) If session/bootstrap logic is added, splash can gate navigation (login vs home) without changing the basic UI flow.

---

## 3. Folder Structure (Rule-Based)

**Create or use:**

| Path | Action |
|------|--------|
| `lib/screens/splash_screen/bloc/` | **Use** — bloc scaffold already exists; extend events/states/handlers |
| `lib/screens/splash_screen/view/splash_screen_view.dart` | **Create** |
| `lib/core/routes/route_names.dart` | **Create** — per `routing_conventions.md` |
| `lib/core/routes/app_routes.dart` | **Create** |
| `lib/screens/login/` (bloc/view as per feature skill) | **Create** — login screen must exist for navigation target (minimal placeholder acceptable for this milestone) |
| `lib/core/constants/app_colors.dart` | **Use** — add splash background color constant |
| `lib/core/constants/app_images.dart` | **Use** — add SVG asset path constant |
| `lib/main.dart` | **Update** — `initialRoute`, `routes`, remove default `home` demo |

**Asset (existing):** `assets/images/subqdocs_white.svg` (already under `assets/images/` in `pubspec.yaml`).

---

## 4. Bloc Strategy

**Bloc:** `SplashScreenBloc` (`lib/screens/splash_screen/bloc/`)

| Piece | Responsibility |
|-------|----------------|
| **Events** | e.g. `SplashScreenStarted` — fired when the splash view is first shown (from `initState` / post-frame callback or similar) |
| **States** | `SplashScreenInitial` (show UI), optionally `SplashScreenNavigating` if you want to block double-navigation; avoid unnecessary states if a single listener-driven navigation is enough |
| **Bloc role** | Start a **2-second** delayed action when started; on completion emit a state that means “go to login” (e.g. `SplashScreenReadyForLogin`) — **no API/repository** for this feature |

**Navigation:** Use `BlocListener` in `splash_screen_view.dart` to call `Navigator.pushReplacementNamed` (or equivalent) when the “ready for login” state is emitted — keeps navigation out of the bloc body per side-effect conventions.

**Timer / disposal:** Use `Timer` or `Future.delayed` with cancellation in `close()` if the bloc owns the timer, so navigating away or disposing does not fire navigation on a dead context.

---

## 5. Routing

| Constant | Suggested value |
|----------|-----------------|
| `RouteNames.splashScreen` | `"/splashScreen"` |
| `RouteNames.login` | `"/login"` |

**Flow:** `splashScreen` → (after 2s) → `login`

**BlocProvider placement:** **Route-level** — wrap `SplashScreenView` with `BlocProvider` in `AppRoutes.routes` for `RouteNames.splashScreen` (preferred per project skill). Login route gets its own provider when that feature’s bloc exists.

**main.dart:** `initialRoute: RouteNames.splashScreen`, `routes: AppRoutes.routes`.

---

## 6. UI Breakdown

- **Root:** `Scaffold` with `backgroundColor: AppColors.splashBackground` (or named constant matching `#5B5BE1`).
- **Body:** `Center` with a single child:
  - `SvgPicture.asset(AppImages.subqdocsWhite)` (or matching constant name) via `flutter_svg` (already in `pubspec.yaml`).
- **Sizing:** Constrain logo with `width`/`height` or `BoxConstraints` so it scales appropriately on small and large screens (exact values TBD during implementation; avoid overflow).
- **No** `AppBar`; status bar style can be set for light content on purple if needed (`SystemUiOverlayStyle`).

---

## 7. Data Flow

For this feature there is **no repository or network layer**.

```
UI → dispatches SplashScreenStarted
  → Bloc waits 2s
  → Bloc emits “navigate to login” state
  → BlocListener → Navigator → Login screen
```

If login later needs tokens or config, that remains in login/auth repositories — out of scope for splash-only UI timing.

---

## 8. Constants & Theme

- **AppColors:** Add a constant for `#5B5BE1` (e.g. `splashBackground` or brand primary if shared) — **no** raw `Color(0xFF5B5BE1)` in the view.
- **AppImages:** Add entry for `subqdocs_white.svg` — **no** raw `'assets/images/...'` in the view.
- **AppStrings:** None required unless adding accessibility labels.
- **AppFonts:** Not required for splash (image-only screen).

---

## 9. Configuration

- **API / `.env`:** Not required for timed splash + static asset.
- **UrlService / environments:** No change for this plan.

---

## 10. Dependencies

| Dependency | Notes |
|------------|--------|
| `flutter_bloc` | Already present |
| `flutter_svg` | Already present |
| New packages | None required for this plan |

**Injection:** No repository for splash; `SplashScreenBloc()` can be constructed without DI unless the project later standardizes on `get_it` / `provider` for all blocs.

---

## 11. Edge Cases

| Case | Handling |
|------|----------|
| **Widget disposed before 2s** | Cancel timer in bloc `close()`; do not navigate if `!context.mounted` (listener) |
| **Double start** | Ignore second `SplashScreenStarted` or use a flag / single-subscription pattern |
| **Login route missing** | Implement minimal `LoginView` + route before testing navigation |
| **Hot restart during splash** | Acceptable reset; no special case |
| **Accessibility** | Optional: `Semantics` label for logo image |

---

## 12. Rule Compliance Check

- **No hardcoding in UI:** Colors and asset paths via `AppColors` / `AppImages`.
- **Folder placement:** Splash under `lib/screens/splash_screen/` with `view/` and `bloc/`.
- **BLoC:** Side effects (navigation) via `BlocListener`, not inside `build`.
- **Routing:** Only `RouteNames` + `AppRoutes` + `main.dart` per `routing_conventions.md`.
- **No API in bloc:** Timer-only coordination.
- **Equatable:** Not used (per project rules).

---

## 13. Scalability

- Splash bloc can later subscribe to bootstrap services (remote config, auth refresh) before choosing login vs home.
- Logo widget can move to `lib/widgets/` if reused (e.g. onboarding).
- Brand color can align with a future global `ThemeData` once the app theme is centralized.

---

## `.cursor/` impact

| Area | Impact |
|------|--------|
| **Rules** | No new rules; existing `bloc-patterns`, `flutter-assets`, `project-structure`, `routing_conventions` apply |
| **Skills** | Use **`.cursor/rules/`** (`flutter-development`, `flutter-assets`, `bloc-patterns`); optional **`flutter-package-install`** etc. only if needed |
| **Lint scope** | New/edited files under `lib/screens/splash_screen/`, `lib/core/routes/`, `lib/core/constants/`, `lib/main.dart` |

---

## Risk hotspots

1. **Login screen not built yet** — navigation target must exist or the app will fail at runtime; stub `LoginView` + route early.
2. **Timer leaks** — must cancel on bloc dispose to avoid navigating after the splash route is gone.
3. **SVG sizing** — unbounded or huge SVG can break layout; test on small devices.
4. **`main.dart` still demo template** — replacing `home:` with named routes is a breaking change for any local experiments; coordinate with other in-flight work.
5. **Status bar contrast** — light icons on `#5B5BE1` usually work; verify on iOS/Android notches.

---

*This document is planning only; it does not include implementation code.*

# Plan: Splash Screen → Login Navigation

> **Prompt (argument):** Splash screen with background color #5B5BE1, centered image subqdocs_white.svg; after 2 seconds navigate to login screen.
>
> **Guideline:** Title name and filename must be **short and precise** (e.g. title: "Splash Screen → Login", filename: `splash_screen_plan.md`).

---

## 1. Purpose

Implement a splash screen that displays the `subqdocs_white.svg` logo centered on a purple background (`#5B5BE1`), then automatically navigates to the login screen after a fixed 2-second duration.

---

## 2. Rules & Skills Reference

_This section summarizes the rules and skills defined in the `.cursor` folder. All implementation must align with these._

### 2.0 Plan-Only Execution Rules

- **Analysis only:** Provide planning, impact analysis, and recommendations only.
- **No code generation:** Do not write, suggest, or auto-generate implementation code snippets.
- **No file modifications:** Do not create, edit, or delete source files as part of this task.
- **No command execution for implementation:** Avoid build, test, migration, or package-install commands intended to change code or project state.
- **Readable output format:** Use structured bullet points with clear section titles and concise wording.
- **Decision support first:** Focus on trade-offs, risks, dependencies, and execution sequence.
- **Scope discipline:** Keep the response limited to requested plan and analysis; defer implementation to a separate task.

### 2.1 Rules (`.cursor/rules/`)

| Rule | Description | Scope |
|------|-------------|-------|
| **general.md** | Avoid duplication; prefer reuse; consistent naming; `snake_case` for all files | Always applies |
| **bloc-patterns.md** | BLoC state management: one bloc per feature, initial/loading/success/error states, BlocBuilder/BlocListener for UI/side effects | `*_bloc.dart`, `*_event.dart`, `*_state.dart`, `*_view.dart` |
| **project-structure.md** | Feature layout: bloc/, view/, widgets/, models/ under `lib/screens/{{feature}}/` | `lib/**/*.dart` |
| **routing_conventions.md** | `RouteNames` for string constants, `AppRoutes` for route map; centralize in one place; use in MaterialApp | `route_names.dart`, `app_routes.dart`, `main.dart` |
| **flutter-assets.md** | Use `AppImages`, `AppStrings`, `AppColors`, `AppFonts`; no direct asset paths, hardcoded strings, or `Color(0xFF...)` | All Dart files |

### 2.2 Skills (`.cursor/skills/`)

Optional workflows: **`flutter-package-install`**, **`prompt-to-docs-plan`**, **`shared-preferences-storage`**, **`device-type-detection`**. Splash/login structure and BLoC are covered by **`.cursor/rules/flutter-development.mdc`** and **`bloc-patterns.mdc`** (and **`flutter-assets.mdc`** for constants).

---

## 3. Detailed Approach

### 3.1 Overview

1. Add constants for background color and logo image in `AppColors` and `AppImages`.
2. Create splash screen feature (BLoC + view) with a 2-second timer, emitting a navigation event when complete.
3. Create login screen feature (placeholder view required for routing).
4. Set up `RouteNames` and `AppRoutes` with splash as initial route; splash BLoC triggers navigation to login after 2 seconds.
5. Wire routes in `main.dart`.

### 3.2 Step-by-Step Strategy

1. **Add App Constants**
   - In `lib/core/constants/app_colors.dart`: add `static const splashBackground = Color(0xFF5B5BE1);` for `#5B5BE1`
   - In `lib/core/constants/app_images.dart`: add `static const subqdocsWhite = 'assets/images/subqdocs_white.svg';`
   - Verify asset exists under `assets/images/subqdocs_white.svg` (already declared in `pubspec.yaml`)

2. **Create Splash Screen Feature**
   - Create `lib/screens/splash_screen/` with:
     - `bloc/`: `splash_screen_bloc.dart`, `splash_screen_event.dart`, `splash_screen_state.dart`
     - `view/`: `splash_screen_view.dart`
   - Events: `SplashScreenStarted` (on init), `SplashScreenTimerCompleted` (internal)
   - States: `SplashScreenInitial`, `SplashScreenNavigateToLogin`
   - BLoC: on `SplashScreenStarted`, start `Future.delayed(Duration(seconds: 2))`, then emit `SplashScreenNavigateToLogin`
   - View: full-screen `Scaffold` with `backgroundColor: AppColors.splashBackground`; center child `SvgPicture.asset(AppImages.subqdocsWhite)`; wrap in `BlocListener` to navigate to login when `SplashScreenNavigateToLogin` is emitted

3. **Create Login Screen Feature (Placeholder)**
   - Create `lib/screens/login/` with:
     - `view/`: `login_view.dart` (basic placeholder for now)
   - Login screen content is out of scope; only routing target is required

4. **Setup Routing**
   - Create `lib/core/routing/route_names.dart` with `splashScreen`, `login`
   - Create `lib/core/routing/app_routes.dart` mapping routes to `SplashScreenView` and `LoginView`
   - Use `initialRoute: RouteNames.splashScreen` and `routes: AppRoutes.routes` in `MaterialApp`
   - Remove `home:` from `MaterialApp`

5. **Wire BlocProvider and Navigation**
   - Provide `SplashScreenBloc` at app or route level
   - In `splash_screen_view.dart`, use `BlocListener<SplashScreenBloc, SplashScreenState>` to call `Navigator.pushReplacementNamed(context, RouteNames.login)` when state is `SplashScreenNavigateToLogin`

### 3.3 Technical Considerations

- **Architecture:** Splash and login as separate features under `lib/screens/`; BLoC handles 2-second timing; `BlocListener` handles navigation side effect (no setState)
- **Dependencies:** `flutter_svg` already in `pubspec.yaml` — use for `subqdocs_white.svg`; no new packages
- **Constants / Assets:**
  - `AppColors.splashBackground` → `#5B5BE1`
  - `AppImages.subqdocsWhite` → `assets/images/subqdocs_white.svg`
- **Routing:** Add `RouteNames.splashScreen`, `RouteNames.login`; add both to `AppRoutes.routes`; splash is `initialRoute`
- **Environment / URLs:** None

---

## 4. Risks & Mitigation

| Risk | Severity | Mitigation |
|------|----------|------------|
| Asset path typo | Low | Use `AppImages.subqdocsWhite`; verify `assets/images/subqdocs_white.svg` exists |
| Timer cancel on dispose | Medium | Cancel `Timer`/`Future` in BLoC `close()` to avoid navigation after widget disposed |
| Navigation context | Low | Ensure `BlocListener` runs in valid `BuildContext`; use `pushReplacementNamed` so splash is removed from stack |
| SVG rendering on different devices | Low | Test on multiple screen sizes; consider `SvgPicture` fit/size constraints |

---

## 5. Risk Hotspots

- `lib/core/constants/app_colors.dart` — Add `splashBackground` (file may be empty)
- `lib/core/constants/app_images.dart` — Add `subqdocsWhite` (file may be empty)
- `lib/screens/splash_screen/bloc/splash_screen_bloc.dart` — Timer logic; ensure proper `close()` cleanup
- `lib/screens/splash_screen/view/splash_screen_view.dart` — BlocListener navigation; dependency on `RouteNames.login`
- `lib/main.dart` — Replace `home` with `initialRoute` + `routes`; wire `BlocProvider` for splash
- `lib/core/routing/` — New files `route_names.dart`, `app_routes.dart` (may not exist)
- `pubspec.yaml` — Already has `assets/images/`; no change expected

---

## 6. .cursor Impact

| Area | Impact | Action |
|------|--------|--------|
| **Rules** | None | No rule updates |
| **Skills** | None | Use **rules** (`flutter-development`, `flutter-assets`, `bloc-patterns`); no extra skill folders required |
| **AGENTS.md** | None | No agent instruction changes |

---

## 7. Success Criteria

- [ ] Splash screen displays full-screen with background color `#5B5BE1`
- [ ] `subqdocs_white.svg` image is centered and visible
- [ ] Uses `AppImages` and `AppColors` (no hardcoded paths/colors)
- [ ] Splash is the initial screen when app launches
- [ ] After exactly 2 seconds, app navigates to login screen
- [ ] Splash is replaced (not stacked) when navigating to login

---

## 8. Out of Scope

- Native splash (Android `styles.xml` / iOS `LaunchScreen.storyboard`)
- Login screen implementation (forms, validation, API, etc.) — placeholder only
- Deep linking or auth state checks before navigation

---

## 9. Notes & Assumptions

- Asset `assets/images/subqdocs_white.svg` exists (per project conventions)
- `flutter_svg` is already a dependency
- `AppImages` and `AppColors` may need initial class structure if files are empty
- Login screen is a placeholder; full login feature implementation is a separate task
- 2-second duration is fixed; no configuration or user-triggered skip for this plan

---

## 10. References

- [AGENTS.md](../AGENTS.md)
- [Plan template](./plan.md)
- [flutter-development rule](../.cursor/rules/flutter-development.mdc)
- [flutter-assets rule](../.cursor/rules/flutter-assets.mdc)
- [routing-conventions rule](../.cursor/rules/routing-conventions.mdc)

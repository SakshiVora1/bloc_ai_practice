# Plan: Splash Screen with subqdocs_white Image & #5B5BE1 Background

> **Prompt (argument):** Splash screen with an image `subqdocs_white` and background color `#5B5BE1`

---

## 1. Purpose

Implement a splash screen that displays the `subqdocs_white` logo image centered on a purple background (`#5B5BE1`). The splash screen already has BLoC scaffolding but lacks the view/widget implementation and integration into the app.

---

## 2. Rules & Skills Reference

### 2.1 Rules (`.cursor/rules/`)

| Rule | Description | Scope |
|------|-------------|-------|
| **general.md** | Avoid duplication; prefer reuse; consistent naming; `snake_case` for all files | Always applies |
| **bloc-patterns.md** | BLoC state management; BlocBuilder/BlocListener; no setState | `*_bloc.dart`, `*_event.dart`, `*_state.dart`, `*_view.dart` |
| **project-structure.md** | Feature layout with bloc/, view/, widgets/, models/ | `lib/**/*.dart` |
| **routing_conventions.md** | RouteNames, AppRoutes; centralize in one place | Route files, main.dart |
| **flutter-assets.md** | Use `AppImages`, `AppStrings`, `AppColors`, `AppFonts`; no direct asset paths or `Color(0xFF...)` | All Dart files |

### 2.2 Skills (`.cursor/skills/`)

Use **`.cursor/rules/flutter-development.mdc`**, **`bloc-patterns.mdc`**, and **`flutter-assets.mdc`** for structure, BLoC, and `AppAssets` / `AppColors` / `AppStrings`. Optional skills: **`flutter-package-install`**, **`prompt-to-docs-plan`**, **`shared-preferences-storage`**, **`device-type-detection`**.

---

## 3. Detailed Approach

### 3.1 Overview

1. Add constants for the image and background color in `AppImages` and `AppColors`.
2. Create `splash_screen_view.dart` with a full-screen `Scaffold` using the background color and centered `subqdocs_white` image (SVG via `flutter_svg`).
3. Wire splash screen as initial route in `main.dart`.
4. Optionally add navigation logic in BLoC to auto-redirect after a delay.

### 3.2 Step-by-Step Strategy

1. **Add App Constants**
   - Add `subqdocsWhite` (or `subqdocs_white` per naming) in `lib/core/constants/app_images.dart` → e.g. `'assets/images/subqdocs_white.svg'`
   - Add `splashBackground` with `#5B5BE1` in `lib/core/constants/app_colors.dart` (use `Color(0xFF5B5BE1)` internally)
   - Ensure `assets/images/` is declared in `pubspec.yaml` (already present)

2. **Create Splash Screen View**
   - Create `lib/screens/splash_screen/splash_screen_view.dart`
   - Use `BlocProvider` + `BlocBuilder` wrapping a `Scaffold`
   - `Scaffold` with `backgroundColor: AppColors.splashBackground`
   - Center child: `SvgPicture.asset(AppImages.subqdocsWhite)` with optional `fit` / size constraints for responsiveness

3. **Integrate into App**
   - Update `main.dart`: set `home` to `SplashScreenView` (or wrap with `BlocProvider` if not provided elsewhere)
   - Ensure `SplashScreenBloc` is provided at the appropriate level

4. **Optional: Splash Duration & Navigation**
   - Add `SplashScreenNavigate` event and `Timer` in BLoC to emit navigation state after ~2–3 seconds
   - Use `BlocListener` to push to next route (e.g. home) when navigation state is emitted

### 3.3 Technical Considerations

- **Architecture:** Splash is a feature under `lib/screens/splash_screen/`; view uses BlocBuilder; BLoC can handle timing and navigation events
- **Dependencies:** `flutter_svg` already in `pubspec.yaml` — use for `subqdocs_white.svg`
- **Constants / Assets:**
  - `AppImages.subqdocsWhite` (or `subqdocs_white`)
  - `AppColors.splashBackground` → `#5B5BE1`
- **Routing:** If splash navigates elsewhere, add route in `RouteNames` / `AppRoutes`; otherwise `home` is sufficient for now
- **Environment / URLs:** None

---

## 4. Risks & Mitigation

| Risk | Severity | Mitigation |
|------|----------|------------|
| Asset path typo | Low | Use constant from `AppImages`; verify asset exists (`assets/images/subqdocs_white.svg`) |
| SVG rendering issues on different devices | Low | Test on multiple screen sizes; consider `SvgPicture` constraints |
| Splash blocks app startup | Low | Keep splash lightweight; no heavy logic in build |

---

## 5. Risk Hotspots

- `lib/core/constants/app_images.dart` — Add image constant (file may be empty; initialize structure)
- `lib/core/constants/app_colors.dart` — Add color constant (file may be empty; initialize structure)
- `lib/screens/splash_screen/` — New `splash_screen_view.dart`; ensure BlocProvider scope
- `lib/main.dart` — Change `home` to splash; may need routing updates
- `pubspec.yaml` — Already has `assets/images/`; no change expected

---

## 6. .cursor Impact

| Area | Impact | Action |
|------|--------|--------|
| **Rules** | None | No rule updates |
| **Skills** | None | Covered by **rules**; optional skills only if needed (e.g. **`flutter-package-install`**) |
| **AGENTS.md** | None | No agent instruction changes |

---

## 7. Success Criteria

- [ ] Splash screen displays full-screen with background color `#5B5BE1`
- [ ] `subqdocs_white` image is centered and visible
- [ ] Uses `AppImages` and `AppColors` (no hardcoded paths/colors)
- [ ] Splash is the initial screen when app launches

---

## 8. Out of Scope

- Native splash (Android `styles.xml` / iOS `LaunchScreen.storyboard`) — plan covers in-app Flutter splash only
- Deep linking or complex navigation from splash

---

## 9. Notes & Assumptions

- Asset `assets/images/subqdocs_white.svg` exists (confirmed in project)
- ` flutter_svg` is already a dependency
- `AppImages` and `AppColors` may need initial class structure if files are empty

---

## 10. References

- [AGENTS.md](../AGENTS.md)
- [Plan template](./plan.md)
- [flutter-assets rule](../.cursor/rules/flutter-assets.mdc)

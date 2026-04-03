# Splash Screen with SubqDocs White Logo

> **Source prompt:** "Create a splash screen and take image which is subqdocs_white.svg which is already inside the folder and the background color would be #5B5BE1 give me a plan for this"  
> **File:** `docs/splash_screen_subqdocs_white_plan.md`

---

## 1. Plan Summary

This plan describes how to implement a splash screen that displays the existing `subqdocs_white.svg` logo centered on a background color of `#5B5BE1`. The splash screen will follow project conventions for assets, colors, routing, and BLoC structure. The app currently has a splash screen BLoC scaffold but no view; the plan covers wiring the view, adding centralized constants, and setting the splash as the initial route.

---

## 2. Detailed Description

### 2.1 Scope

**In scope:**
- Splash screen UI with `subqdocs_white.svg` centered on `#5B5BE1` background
- Register `subqdocsWhite` in `AppImages` and add `splashBackground` (or equivalent) in `AppColors`
- Create `splash_screen_view.dart` under `lib/screens/splash_screen/view/`
- Wire splash screen as initial route via `RouteNames` and `AppRoutes`
- Use `flutter_svg` (already in `pubspec.yaml`) for SVG rendering

**Out of scope:**
- Splash-to-next-screen navigation logic (can be added later via bloc events)
- Animations or transitions
- Platform-specific splash/launch screen native configuration (Android `drawable`, iOS `LaunchScreen`)

### 2.2 Approach

- **Asset**: `assets/images/subqdocs_white.svg` already exists; declare it in `AppImages.subqdocsWhite`.
- **Color**: Add `#5B5BE1` to `AppColors` (e.g. `splashBackground` or `splashPurple`) — no inline `Color(0xFF5B5BE1)`.
- **View**: Stateless `SplashScreenView` with `Container` background and centered `SvgPicture.asset(AppImages.subqdocsWhite)`.
- **Routing**: Introduce `RouteNames` and `AppRoutes` if absent; set `initialRoute: RouteNames.splashScreen` and remove or bypass `home: MyHomePage`.
- **BLoC**: Splash screen bloc exists but is minimal; for a static splash, the view may not need events. If auto-navigation is required later, extend the bloc with a timer event.

### 2.3 Implementation Outline

1. **Constants**
   - `lib/core/constants/app_images.dart`: add `static const subqdocsWhite = 'assets/images/subqdocs_white.svg';`
   - `lib/core/constants/app_colors.dart`: add `static const splashBackground = Color(0xFF5B5BE1);` (or equivalent hex constant)

2. **Splash screen view**
   - Create `lib/screens/splash_screen/view/splash_screen_view.dart`
   - Full-screen `Scaffold` or `Container` with `color: AppColors.splashBackground`
   - Center child: `SvgPicture.asset(AppImages.subqdocsWhite)` with appropriate `width`/`height` for scaling

3. **Routing**
   - Create or update `lib/core/config/route_names.dart` with `static final splashScreen = "/splashScreen";`
   - Create or update `lib/core/config/app_routes.dart` with route map including `RouteNames.splashScreen`
   - Update `main.dart`: use `initialRoute: RouteNames.splashScreen`, `routes: AppRoutes.routes`, remove `home:`

4. **Optional bloc wiring**
   - If SplashScreenBloc is used for navigation: wrap splash route with `BlocProvider` in `app_routes.dart`

---

## 3. Impact on .cursor/ Configuration

### 3.1 Rules Affected

| Rule / File              | Scope                          | Impact                                                                 | How It Works                                                                 |
|--------------------------|--------------------------------|------------------------------------------------------------------------|------------------------------------------------------------------------------|
| `flutter-assets.md`      | `**/*.dart`                    | Add `AppImages.subqdocsWhite`, `AppColors.splashBackground`            | No hardcoded asset path or color; use centralized constants                  |
| `project-structure.md`   | `lib/**/*.dart`                | Add `view/splash_screen_view.dart` under splash_screen feature         | View goes in `lib/screens/splash_screen/view/`                               |
| `routing_conventions.md` | route_names, app_routes, main | Add splash route, set initial route                                    | `RouteNames.splashScreen`, `AppRoutes.routes`, `MaterialApp.initialRoute`     |
| `bloc-patterns.md`       | bloc, event, state, view       | Splash bloc may stay minimal unless auto-navigation is added           | If logic added: events → bloc → states → `BlocBuilder` in view               |
| `general.md`             | Always                         | No duplication, reuse constants                                         | Use existing `app_images.dart`, `app_colors.dart`                             |

### 3.2 Skills Affected

| Skill                  | Description                                                   | Impact                                                                 | When to Use                                                              |
|------------------------|---------------------------------------------------------------|------------------------------------------------------------------------|---------------------------------------------------------------------------|
| *(rules)* | **`flutter-development.mdc`**, **`bloc-patterns.mdc`**, **`flutter-assets.mdc`** | Splash BLoC/view and constants follow repo rules | Primary reference for implementation |
| `flutter-package-install` | Install Flutter packages                                  | `flutter_svg` already present; no new package needed                    | Only if another asset type (e.g. Lottie) is added                        |
| `prompt-to-docs-plan`  | Generate docs plan from prompt                               | This plan was produced via this skill                                  | When planning features or refactors                                      |

### 3.3 Other .cursor/ Files

| File                         | Purpose                      | Impact                                                                 |
|-----------------------------|------------------------------|------------------------------------------------------------------------|
| `project_consistency_plan.md` | Centralization, BLoC rules  | Plan aligns with `AppImages`/`AppColors` and feature structure          |
| `rules.md`                  | Rule index                    | No changes; existing rules cover assets, colors, routing              |

---

## 4. Risk & Issue Hotspots

### 4.1 High Risk

| Area             | Issue                          | Possible Cause                          | Mitigation                                                                 |
|------------------|--------------------------------|-----------------------------------------|----------------------------------------------------------------------------|
| Asset not found  | SVG fails to load at runtime   | Path typo, asset not declared in pubspec| Verify `assets/images/` in pubspec; use `AppImages.subqdocsWhite` exactly  |
| Routing conflict | App shows wrong initial screen | `home:` overrides `initialRoute`        | Remove `home:` when using `initialRoute` and `routes`                      |

### 4.2 Medium Risk

| Area              | Issue                               | Possible Cause                     | Mitigation                                                                 |
|-------------------|-------------------------------------|------------------------------------|----------------------------------------------------------------------------|
| SVG sizing        | Logo too large/small on different devices | No explicit width/height       | Use `SvgPicture.asset(..., width: X, height: Y)` or `fit` for scaling       |
| Missing config    | `route_names.dart` or `app_routes.dart` absent | New project setup          | Create files under `lib/core/config/` (or equivalent) per routing rules    |
| Color format      | Wrong shade displayed              | Hex parsing (alpha channel)         | Use `Color(0xFF5B5BE1)` — FF for full opacity                              |

### 4.3 Low Risk / Notes

- `flutter_svg` is already a dependency; no extra install
- `subqdocs_white.svg` is at `assets/images/subqdocs_white.svg`; pubspec lists `assets/images/`
- Splash bloc can remain minimal until auto-navigation is required
- Consider native launch screens later for platform-specific branding before Flutter loads

---

## 5. Checklist Before Implementation

- [ ] `.cursor/` rules and skills reviewed for alignment
- [ ] `AppImages.subqdocsWhite` and `AppColors.splashBackground` added in constants
- [ ] `splash_screen_view.dart` created with `SvgPicture.asset` and background color
- [ ] `RouteNames` and `AppRoutes` created/updated with splash route
- [ ] `main.dart` updated to use `initialRoute` and `routes` (no `home:`)
- [ ] Risk mitigations planned for high/medium items (asset path, routing)

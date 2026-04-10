# Agent instructions

Guidance for coding agents in this Flutter repo. **Detail lives in `.cursor/`; this file is the fast orientation.**

---

## 1. Source of truth (strict order)

| Priority | Location                    | Role                                                                                         |
|----------|-----------------------------|----------------------------------------------------------------------------------------------|
| **1**    | **`.cursor/rules/`**        | **Authoritative.** Start at **`.cursor/rules.mdc`** (index), then each **`.mdc`** file.      |
| **2**    | **`.cursor/skills/`**       | **Workflows.** When a skill matches the task, follow **`SKILL.md`** for that skill.          |
| **3**    | **`AGENTS.md`** (this file) | Summary only. **If anything here conflicts with a rule or skill, follow the rule or skill.** |

---

## 2. Product scope

- **Platforms:** **iOS and Android** (Flutter mobile). Do **not** target web or desktop unless the user explicitly asks.

---

## 3. Architecture overview

### State

- **Bloc + events only** — do **not** use **Cubit**.
- Do **not** use **`setState`** for feature state; drive UI via BLoC events and emitted states.
- One BLoC per feature or cohesive flow; avoid god-blocs.
- **1 BLoC, 1 screen** → `BlocProvider` in route builder (`app_routes.dart`)
- **Many BLoCs, 1 screen** → `MultiBlocProvider` in route builder (`app_routes.dart`)
- **1 BLoC, all screens** → `BlocProvider` in `main.dart` above `MaterialApp`
- **Many BLoCs, all screens** → `MultiBlocProvider` in `main.dart` above `MaterialApp`
- Full placement rules and examples → `routing-conventions.mdc`

### Events and states

- Immutable.
- Do **not** add **`package:equatable`** for events/states unless you hand-write **`==`/`hashCode`** where truly needed.
- Use **`part` / `part of`** across **`feature_bloc.dart`**, **`feature_event.dart`**, **`feature_state.dart`**.

### Repositories

- HTTP only through **`ApiService`** — no raw **`http`** clients in features.
- Return parsed data or typed failures / **`Result`**, feature-defined — **no** branching on **`response_type`** in the repository, **no** toasts or UI side effects.
- Inject repositories into the BLoC via **constructor**.

### BLoC and API responses

- After repository calls, the **BLoC** inspects **`response_type`** (or equivalent): **success** → follow-up logic and success state; **error** → failure state and always emit something useful for the UI.
- After **`await`**, guard with **`isClosed`** before **`emit`**.
- **API errors to the user:** **`AppToast.showError`** (`lib/core/services/app_toast.dart`, **`toastification`**). Do **not** use **`ScaffoldMessenger` / `SnackBar`** for that pattern.

### Routing

- Thin route builders: wire **`BlocProvider`** + view only.
- Paths: **`lib/core/routing/route_names.dart`**. Builders / map: **`lib/core/routing/app_routes.dart`**. Imperative navigation: **`AppRouter`** from **`BlocListener`** or views — avoid raw **`Navigator`** where the façade is meant to be used.
- Do **not** put business logic, API calls, or heavy UI composition in route files.

### UI

- **`BlocBuilder`** (or **`BlocSelector`** / **`buildWhen`**) for rendering; **`BlocListener`** for **navigation, dialogs, and toasts** tied to state transitions.
- Do **not** navigate from inside the BLoC.
- **Sizing / responsive:** prefer **`MediaQuery`** (e.g. **`MediaQuery.sizeOf`**) for viewport and breakpoints. Use **`LayoutBuilder`** only when layout must follow **parent `BoxConstraints`** and `MediaQuery` is not enough — see **`.cursor/rules/flutter-development.mdc`** and **`.cursor/skills/device-type-detection/SKILL.md`**.

### Configuration and URLs

- URLs and env-sensitive values: **`UrlService`**, **`AppConfig`**, **`lib/core/config/`** — **no** hardcoded API bases in widgets, BLoCs, or repositories.
- Do **not** call **`dotenv`** from UI, BLoC, or repository layers.

---

## 4. Centralized resources (`lib/core/`)

Do **not** scatter user-visible strings, colors, asset paths, or ad-hoc **`TextStyle`**s in widgets/BLoCs when a central type exists:

- **Same literal → reuse:** If **`AppStrings`**, **`AppAssets`**, or **`AppColors`** already defines a constant for that exact string, path, or color, use it — do **not** add a second constant with a different name for the same value.

| Use | For |
|-----|-----|
| **`AppStrings`** | Copy and messages |
| **`AppAssets`** | Asset paths |
| **`AppColors`** | Colors |
| **`AppFonts`** / **`AppTextStyles`** | Typography (use what the project already defines) |
| **`RouteNames`**, **`AppRoutes`**, **`AppRouter`** | Navigation |
| **`lib/core/enums/`** | Shared enums |

---

## 5. Where code lives

### Features (preferred)

```
lib/features/<feature_name>/
  presentation/
    view/
    widgets/
    bloc/          # *Bloc, *Event, *State (part files)
  domain/          # optional — interfaces, pure Dart
  data/            # repository impls, feature DTOs; ApiService only
```

### Shared and app-wide

| Area | Path |
|------|------|
| Cross-feature widgets | **`lib/widgets/`** (and **`lib/shared/`** if the project uses it) |
| App-wide API / persistence models | **`lib/data/models/`** |
| Cross-cutting models / session bits | **`lib/core/models/`** when used project-wide |
| Core services, theme, routing | **`lib/core/`** |

An **alternative** **`lib/screens/<feature>/`** layout is documented in **`.cursor/rules/flutter-development.mdc`** — prefer **`lib/features/`** for new work unless the user says otherwise.

---

## 6. Layer responsibilities

| Layer | Responsibility |
|-------|----------------|
| **UI** | Build from state; dispatch events; **`BlocListener`** for nav / toasts / dialogs |
| **Event** | Immutable inputs |
| **State** | Immutable view model |
| **BLoC** | All business rules; orchestrate repositories; **emit** states |
| **Repository** | I/O and mapping; **no** **`BuildContext`**, **no** branching on **`response_type` for UX** |

---

## 7. Naming (Effective Dart)

| Kind | Style | Example |
|------|--------|---------|
| Types | `UpperCamelCase` | `LoginBloc`, `AuthState` |
| Files, dirs | `snake_case` | `login_bloc.dart` |
| Members, params | `lowerCamelCase` | `accessToken` |
| `static const` | `lowerCamelCase` | `defaultTimeout` |

Prefer **`final`**, **`const`** where possible. Run **`dart format .`** and **`flutter analyze`** with **zero** warnings for checked-in code.

---

## 8. Testing

- BLoC tests with **`bloc_test`** and mocked repositories.
- Keep non-trivial business rules in BLoC or unit tests, not only golden/widget tests.

---

## 9. Plans and documentation

When the user asks for a **plan**, **impact analysis**, or **docs**:

1. Use **`.cursor/skills/prompt-to-docs-plan/`** when it applies.
2. Align the output with **`.cursor/rules/`** (no forbidden patterns).
3. Write a **`docs/<descriptive_name>.md`** (or under **`docs/plans/`** per your templates) including plan name, description, **`.cursor/`** impact, and risk hotspots.

---

## 10. Rule index (copy of `.cursor/rules.mdc`)

For convenience, indexed rule files:

- `.cursor/rules/bloc-patterns.mdc`
- `.cursor/rules/error-handling.mdc`
- `.cursor/rules/environment-urls.mdc`
- `.cursor/rules/flutter-assets.mdc`
- `.cursor/rules/flutter-development.mdc`
- `.cursor/rules/general.mdc`
- `.cursor/rules/model-serialization.mdc`
- `.cursor/rules/repository-boundaries.mdc`
- `.cursor/rules/routing-conventions.mdc`
- `.cursor/rules/avoid-unnecessary-material.mdc`

Effective Dart style is bundled into **`flutter-development.mdc`**, — **pure index only**, no rules defined here; points to all other rule files; there is no separate **`effective-dart.mdc`**.

**Skills** (narrow workflows only): **`centralized-resources`**, **`flutter-package-install`**, **`prompt-to-docs-plan`**, **`shared-preferences-storage`**, **`device-type-detection`** — each under **`.cursor/skills/<name>/SKILL.md`**. Everything else is covered by **`.cursor/rules/`** and this file.

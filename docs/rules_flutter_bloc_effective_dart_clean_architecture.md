# Rules reference: Flutter BLoC, Effective Dart, clean architecture

This file is a **single place to read** how this repo expects code to behave. It does not replace `AGENTS.md` or `.cursor/rules/`; those remain authoritative for agents. Use this when you want a consolidated checklist.

## Clean architecture (dependency rule)

- **Dependencies point inward.** UI and infrastructure adapt to the center, not the other way around.
- **Domain (when present)** stays free of Flutter/framework imports: entities, value objects, repository *interfaces*, optional use cases.
- **Data** implements repositories, talks to `ApiService`, maps DTOs to models; no feature “decisions” that belong in BLoC.
- **Presentation** holds widgets and **BLoC only** for state; it consumes repositories/use cases injected into BLoC.

Common folder shapes (adapt to this repo’s layout):

- `lib/core/` — shared constants, routing, cross-cutting services.
- `lib/data/` — shared data access patterns if used.
- `lib/screens/<feature>/` or `lib/features/<feature>/` — feature UI + bloc + local widgets.

## Flutter BLoC (this project)

- **BLoC is the only** app state mechanism; do not use `setState` for feature state.
- **Thin routes:** provide `BlocProvider` (and related blocs), navigate to the view; no business logic, API calls, or heavy UI composition in route builders.
- **Inject repositories** into BLoC via constructors; BLoC orchestrates loading, success, and error flows.
- After repository calls, **inspect `response_type`**: success → follow-up logic and success state; otherwise → error state and user feedback per project conventions.
- **API errors:** use **`AppToast.showError(context, message)`** (`lib/core/services/app_toast.dart`, **toastification**) from a **`BlocListener`**; avoid `ScaffoldMessenger` / `SnackBar` for that pattern unless requirements change.

See `AGENTS.md` for the exact guardrails.

## Effective Dart

Follow [Effective Dart](https://dart.dev/effective-dart) for style, naming, and API design:

- Imports: `dart:` → `package:` → relative; sorted within groups.
- Naming: `UpperCamelCase` for types; `lowerCamelCase` for members; `snake_case` files and directories.
- Prefer `final`, explicit types on public APIs, meaningful names, null-safe idioms (`isEmpty` / `isNotEmpty`).
- Format with `dart format`; respect `analysis_options.yaml` and `flutter_lints`.

Project-specific Flutter/BLoC rules are in **`.cursor/rules/flutter-development.mdc`** and sibling **`.mdc`** files (not edited by this file).

## Quick compliance checklist

- [ ] No `setState` for managed feature state.
- [ ] Repositories use `ApiService` only for HTTP; mapping only, no business branching.
- [ ] BLoC owns branching on API outcomes and emits clear states.
- [ ] Widgets stay declarative; heavy logic stays in BLoC or pure domain types.
- [ ] Files and identifiers match Effective Dart + repo naming rules.

## Further reading (external)

- [Effective Dart](https://dart.dev/effective-dart)
- [bloc library](https://bloclibrary.dev/)
- [Clean architecture in Flutter](https://flutterstudio.dev/blog/flutter-clean-architecture.html) (high-level overview; adapt patterns to this repo’s structure)

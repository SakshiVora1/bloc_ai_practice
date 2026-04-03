Please learn the `Instruction` and give me a plan where it should maintain the code consistency , reusability  and avoid duplication of code across the project.

## Instruction
- create .md file inside `.cursor\*.md` and insert the plan over here.

## Install Packages
- To install any package need to use this command to add flutter package`flutter pub add {{package_name}}` it will install the package in `pubspec.yaml`

## Run
- then run in terminal `flutter pub get` through which it can install the package.

-> Bloc:
File structure:
- Main bloc file (`{{feature_name}}_bloc.dart`) must use `part '{{feature_name}}_event.dart'` and `part '{{feature_name}}_state.dart'`
- Event file must start with `part of '{{feature_name}}_bloc.dart';` and use `@immutable sealed class {{Feature}}Event {}`
- State file must start with `part of '{{feature_name}}_bloc.dart';` and use `@immutable sealed class {{Feature}}State {}`
- Concrete state/event classes must use `final class` (e.g. `final class SplashScreenInitial extends SplashScreenState {}`)

Do's
- it should always use one bloc per one feature
- always emit state for ui representation such as initial,loading, success, error and soon...
- Keep business logic outside UI:
  Use Repository or UseCase for API/data handling.
  BLoC should only coordinate logic, not implement it.
- Always handle errors:
  Use try-catch
  Use async/await properly
  Emit meaningful error states/messages
- Keep states:
  Immutable (final fields)
  Minimal
  Clear and readable
- Keep UI dumb:
  UI should only:
  Dispatch events
  Listen to states
- Use:
  BlocBuilder → for UI updates
  BlocListener → for side effects (navigation, snackbar, dialogs)
- Use BlocProvider properly:
  - Use BlocProvider based on scope:
  - Global BLoC (used across many screens/app lifecycle) -> provide in `main.dart`
  - Screen/feature BLoC (used only on one screen/flow) -> provide in route files (`core/routes/...`)
- Use MultiBlocProvider based on scope:
  - Multiple global BLoCs -> use `MultiBlocProvider` in `main.dart`
  - Multiple BLoCs needed only for one screen -> use `MultiBlocProvider` in that screen's route builder
- Rule of thumb:
  - App-wide scope -> `main.dart`
  - Screen-specific scope -> route files
- Use:
  MultiBlocProvider for multiple blocs
  MultiBlocListener when needed
- Optimize rebuilds:
  Split widgets
  Use BlocSelector when required

Don't ->
- Do NOT use setState for state management when using BLoC.
- Do NOT call APIs directly inside BLoC — always use a Repository or UseCase layer.
- Do NOT write UI logic inside BLoC — UI validation should remain in the UI layer.
- Do NOT emit unnecessary or excessive states — keep state transitions minimal and meaningful.
- Do NOT mix business logic inside the UI — all business logic should be handled in BLoC or UseCases.
- Do NOT skip error handling — always emit proper error states with meaningful messages.
- Do NOT use Equatable — ensure proper state emission and structure instead.

-----

Images, Strings, Colors and Fonts
- Always use AppAssets, AppStrings, AppColors, and AppFonts.
- If any asset, string, or color is NOT available:
  First create a static const variable inside its respective class
  Then use it in the code
- Do NOT use:
  Direct asset paths (assets/...)
  Hardcoded strings ('Text')
  Direct colors (Color(0xFF...))
  Direct TextStyle()
- For fonts:
  Always use functions inside AppFonts that return TextStyle.

Models and Ui
- if any ui or widget which is used in a whole app then make a common ui inside the `lib\widgets` otherwise create in `lib\screens\{{feature_name}}\widgets\`
  and if widget folder  is not their then create that particular widget.
- same for model also if it is in an app instead of particular then create the model class inside the `lib\data\models` otherwise create in `lib\screens\{{feature_name}}\models\`

for file name check the structure of project

## Project Structure
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_assets.dart
│   │   ├── app_fonts.dart
│   │   ├── app_strings.dart
│   │   └── app_enum.dart
│   │
│   ├── routing/
│   │   ├── app_routes.dart
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   │
│   ├── services/
│   │   └── api_client.dart
│   │
│   └── config/
│       └── url_config.dart
│
├── data/
│   ├── models/
│   │   └── {{feature_name}}_model.dart
│   │
│   ├── repository/
│   │   └── {{feature_name}}_repository.dart
│
├── screens/
│   ├── {{feature_name}}/
│   │   ├── bloc/
│   │   │   ├── {{feature_name}}_bloc.dart
│   │   │   ├── {{feature_name}}_event.dart
│   │   │   └── {{feature_name}}_state.dart
│   │   │
│   │   ├── models/        ✅ fixed
│   │   │   └── {{feature_name}}_model.dart
│   │   │
│   │   ├── widgets/       ✅ added
│   │   │
│   │   └── view/
│   │       └── {{feature_name}}_view.dart
│
├── widgets/
│
└── main.dart

## General Rules
- Avoid duplication at all costs.
- Always prefer reuse over creation.
- Keep naming consistent and meaningful.
- Use snake_case for all files. give example for this
- Do not use `LayoutBuilder` unnecessarily. Use `MediaQuery` for width and height sizing by default, and only use `LayoutBuilder` when parent layout constraints are explicitly required.

## Widget Structure Rules
- Prefer splitting reusable/common UI into separate `StatelessWidget` classes.
- For each screen, use only one `StatefulWidget` by default.
- Add additional `StatefulWidget` classes only when there is a clear lifecycle or local-state boundary that cannot be handled by the main screen state.
- Do not create a separate wrapper `StatefulWidget` only to dispatch one event if it can be handled in existing BLoC/provider setup.
- If a widget has no local mutable state and no lifecycle requirement (`initState`, `dispose`, controllers, animation), it must be a `StatelessWidget`.


## Create/update the “Environment & URL Management” convention to match this existing architecture pattern:
1) Environment enum + dotenv mapping
- Use an `Environment` enum with these cases: `dev`, `ngrok`, `stage`, `prod`.
- Implement getters on `Environment` that read from `.env` via `dotenv.get(...)` (no hardcoded URLs anywhere):
  - `baseUrl` must map:
    - dev -> `DEV_URL`
    - ngrok -> `NGROK_URL`
    - stage -> `STAGE_URL`
    - prod -> `PROD_URL`
  - `patientChatBaseUrl` must map:
    - dev -> `PATIENT_CHAT_DEV_URL`
    - ngrok -> `PATIENT_CHAT_NGROK_URL`
    - stage -> `PATIENT_CHAT_STAGE_URL`
    - prod -> `PATIENT_CHAT_PROD_URL`
  - `socketUrl` must map:
    - dev -> `SOCKET_DEV_URL`
    - ngrok -> `SOCKET_NGROK_URL`
    - stage -> `SOCKET_STAGE_URL`
    - prod -> `SOCKET_PROD_URL`
  - `viteCryptoSecretKey` must map: `VITE_CRYPTO_SECRET_KEY`
2) AppConfig single switch (static global env)
- Use an `AppConfig` class with:
  - a private static `_currentEnvironment` defaulting to `Environment.dev`
  - a static setter `environment` and getter `environment`
  - derived getters that return the current environment values (optionally wrap with `WebUri(...).toString()` like the example):
    - `baseUrl`
    - `socketUrl` (if you need it)
    - `patientChatSocketUrl` (derived from `patientChatBaseUrl`)
    - `viteCryptoSecretKey`
3) UrlService = the only access point for app code
- Use a `UrlService` class as the stable public API for the rest of the app.
- It must ONLY expose what the app needs (at minimum):
  - `baseUrl`
  - `patientChatSocketUrl`
  - `viteCryptoSecretKey`
- UI/BLoC/Repos must NOT call `dotenv` directly and must NOT build URLs manually.
- If any socket URL is needed, it must come from `UrlService` (no other place in code).
4) Routing/scalability for new environments
- The system must support adding new environments by extending the `Environment` enum + dotenv keys, without changing callers.
5) Required `.env` variables (template)
- Provide an example `.env` (or `.env.example`) containing:
  - DEV_URL, NGROK_URL, STAGE_URL, PROD_URL
  - PATIENT_CHAT_DEV_URL, PATIENT_CHAT_NGROK_URL, PATIENT_CHAT_STAGE_URL, PATIENT_CHAT_PROD_URL
  - SOCKET_DEV_URL, SOCKET_NGROK_URL, SOCKET_STAGE_URL, SOCKET_PROD_URL
  - VITE_CRYPTO_SECRET_KEY
  - ENV flag (example: `ENV=dev`) to switch environments at startup (if startup switching is not already implemented, add the minimal bootstrap code at app start that sets `AppConfig.environment` based on this single flag).
6) IMPORTANT constraint
- Do NOT hardcode any URL anywhere else in the project.
- Do NOT bypass `UrlService` for API/socket base URLs.
  Output:
- Add the above as Cursor rules/skills content so future generated code follows this exact pattern.
- If the UrlService/AppConfig/Environment structure already exists, only update the rule/skill guidance (do not refactor existing logic).

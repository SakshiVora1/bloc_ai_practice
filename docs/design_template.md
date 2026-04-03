# Design & architecture template

**How to use:** Copy this file to `docs/plans/<feature_name>_design.md` (or your team’s naming convention). Replace every placeholder and remove instructional *italics*. One document per feature or major screen.

**Project alignment (this repo):** State management is **`Bloc` + events** only (no `Cubit`, no `setState` for feature logic). User-facing strings, colors, fonts, images, and routes live under **`lib/core/constants/`** and **`RouteNames`**. API access goes through **`ApiService`** inside repositories. API errors for users use **`AppToast`** (**toastification** via `lib/core/services/app_toast.dart`; not `SnackBar` for that pattern). Navigation reactions belong in **`BlocListener`**, not inside the Bloc.

---

## 1. Feature overview

| Item | Fill in |
|------|---------|
| **Feature / screen name** | _e.g. Login, Order details_ |
| **Purpose** | _One paragraph: what this screen or flow does._ |
| **Problem it solves** | _User or business problem; why it exists._ |
| **Target users** | _Role, context, assumptions (authenticated vs guest, etc.)._ |

---

## 2. User flow

- **Entry point:** _Where the user lands from (deeplink, previous route, push notification, cold start)._
- **Step-by-step flow:**  
  1. _…_  
  2. _…_  
  3. _…_
- **Exit point:** _Where the user goes next (success path, cancel, back)._
- **Navigation behavior:** _Push vs replace vs pop; guard routes; “double back” to exit app if applicable._  
  _Align with `RouteNames` / `AppRoutes.routes`; document listener-driven navigation on success._

---

## 3. UI structure (widget / layout tree)

Provide a clear hierarchical structure (adapt naming to actual widgets).

```
Screen (<Feature>View)
├── Scaffold (or custom shell)
│   ├── AppBar / header (if any)
│   ├── Body
│   │   ├── … scroll / column …
│   │   ├── Section A
│   │   ├── Section B
│   │   └── …
│   └── Bottom bar / FAB (if any)
└── Overlays (dialogs, sheets — when they appear)
```

_Add notes for: keyboard inset (`resizeToAvoidBottomInset`), scroll-to-focused field, loading overlays._

---

## 4. Design system

Document values **before** hard-coding; map to **`AppColors`**, **`AppFonts`**, **`AppStrings`**, **`AppAssets`**.

- **Colors:** _Primary, surface, text primary/secondary, borders, error, success, disabled — hex or token names._
- **Typography:** _Headings, body, captions, button labels — family, size, weight._
- **Spacing:** _Padding scale, section gaps, card padding, button height (e.g. primary 40)._  
  _Prefer `MediaQuery` for responsive sizing per project rules._
- **Component styles:** _Primary/secondary buttons, text fields (decoration, radius), checkbox, links, icons._

_Reference design file path if applicable (e.g. Figma export under `assets/images/figma/`)._

---

## 5. State management design

**Stack:** `flutter_bloc` — **`Bloc`** + **immutable events** and **immutable states**. Use `part` / `part of` across bloc, event, and state files when matching this repo’s feature layout.

### Events

_List every event the UI or system can dispatch. One line each: name + when it fires + payload (if any)._

- _Example: `FeatureStarted` — screen opened, no payload._
- _Example: `FeatureSubmitted` — user tapped submit; carries validated fields (no password in state if policy says so)._

### States

_List every state the UI can render. Note what data each carries (loading flag, error message, domain model ids, etc.). Avoid storing secrets in states._

- _Example: `FeatureInitial`_
- _Example: `FeatureLoading`_
- _Example: `FeatureSuccess` — carries safe subset of response_
- _Example: `FeatureFailure` — user-safe message for toast or inline display_

### Bloc responsibilities

- _Validate business rules that belong in bloc (keep field format rules in form/UI if that’s the team standard)._
- _Call repository methods; interpret `response_type` or typed results._
- _Emit states; after `await`, guard with `isClosed` before emit._
- _No `Navigator`, no `ScaffoldMessenger` for API errors — **`BlocListener`** + **`AppToast`**._
- _Constructor injection for repositories._

---

## 6. Data flow

Describe end-to-end flow in one diagram + bullets.

**Canonical flow (adapt labels):**

```
UI → dispatch Event → Bloc → Repository → ApiService → API
API → Repository (map / failure) → Bloc → emit State → UI (BlocBuilder)
Side effects (navigate, toast) → BlocListener on State change
```

- **Read path:** _If this feature loads existing data, describe triggers and caching._
- **Write path:** _Submit, optimistic updates (if any), refresh after success._
- **Persistence:** _SharedPreferences, secure storage, none — be explicit._

---

## 7. API design / integration

- **Endpoint(s):** _Path(s), version, environment-specific notes._
- **Method:** _GET / POST / …_
- **Request payload:** _JSON shape, required/optional fields, encryption/signing if any._
- **Response structure:** _Success body; where `response_type` or status lives per backend contract._
- **Error handling:** _HTTP vs body errors; mapping to typed failures or messages; what the user sees (`AppToast` vs inline); retry policy (if any)._

_Repositories use **`ApiService` only**; no UI types in repositories._

---

## 8. Validation rules

- **Field validations:** _Per-field rules (format, length, required). Clarify **when** validation runs: on submit only vs on change._
- **Error messages:** _Copy via `AppStrings`; list keys or exact wording._
- **Edge validation cases:** _Whitespace trimming, paste, autofill, international formats, max length while typing._

---

## 9. Edge cases & error handling

- **Network failure:** _Offline, timeout, DNS — user message and whether retry is offered._
- **Empty states:** _No data, first-time user._
- **API failure:** _4xx/5xx, business errors in body — map to states and toasts._
- **Unexpected user behavior:** _Double tap submit, background/foreground during request, bloc disposed mid-flight._

---

## 10. Components & reusability

- **Reusable widgets / components:** _List widgets under `lib/widgets/` or feature `widgets/` with rationale._
- **Shared utilities:** _Formatters, extensions, validators shared across features._
- **Custom abstractions:** _Base button style, form field wrapper, result types — new vs existing._

---

## 11. Folder structure

Provide a **scalable** layout for **this** feature (match repo: `lib/screens/<feature>/` or future `lib/features/<feature>/`).

```
lib/screens/<feature>_screen/
├── bloc/
│   ├── <feature>_screen_bloc.dart
│   ├── <feature>_screen_event.dart
│   └── <feature>_screen_state.dart
├── view/
│   └── <feature>_screen_view.dart
├── repository/
│   └── <feature>_repository.dart
└── widgets/          # optional — only if feature-local reuse
```

_Data models in `lib/data/models/` when shared; enums in `lib/core/enums/`._

---

## 12. Navigation & routing

- **Route name:** _Must match `RouteNames.*` (leading `/`)._
- **Navigation logic:** _Who navigates (listener on which state); push vs `pushReplacementNamed`._
- **Parameters passed:** _Arguments, `extra`, query — or explicit “none”._

---

## 13. Performance considerations

- **Avoid unnecessary rebuilds:** _Use `BlocBuilder` + `buildWhen`, `BlocSelector`, or small child widgets._
- **Lazy loading:** _Pagination, deferred lists, images (`cacheWidth` / precache if needed)._
- **Caching strategy:** _Memory cache for GET, ETag, or “always fresh”; document invalidation._

---

## 14. Security considerations

- **Data protection:** _PII on screen, logging redaction._
- **Token handling:** _Where tokens are stored; never log tokens; clear on logout._
- **Input sanitization:** _Server-side assumption; client-side length limits and dangerous patterns if applicable._

---

## 15. Assumptions & notes

_List everything you assumed (backend contract stable, design final, single locale, etc.)._

_List constraints (offline not supported, min OS version, feature flag)._ 

---

## 16. Future enhancements

- **Possible improvements:** _Biometrics, social login, analytics, accessibility upgrades._
- **Scalability considerations:** _Multi-tenant, theming, localization, tablet layout._

---

## Sign-off checklist (optional)

- [ ] All sections filled; no `[TODO]` left for release scope  
- [ ] Design tokens mapped to `AppColors` / `AppFonts` / `AppStrings` / `AppAssets`  
- [ ] Events/states cover loading, success, failure, and edge cases  
- [ ] API contract reviewed with backend  
- [ ] Accessibility: semantics, contrast, focus order (if reviewed)

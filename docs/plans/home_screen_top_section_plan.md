# Plan name

**HomeScreen — top section (schedule bar, date navigation, search/filter/actions)**

# Description

## Scope

Implement the **top section** of the home (schedule) screen: section title, a main `Row` with **left** controls (search, filter, schedule visit) and **right** controls (previous day, date display, next day), backed by **`HomeScreenBloc`** (extend the existing bloc in `lib/features/home/presentation/bloc/`), with **clean architecture** layers and **reusable widgets**. No API work in this slice unless explicitly added later.

**Out of scope for this plan (unless you expand):** drawer panel *content* beyond a placeholder shell, visit list, API-driven schedule data.

## Alignment with the repo

| Prompt | Repo decision |
|--------|----------------|
| `HomeBloc` | Keep **`HomeScreenBloc`**, **`HomeScreenEvent`**, **`HomeScreenState`** naming to match **`login_screen_*`** and existing **`home_screen_bloc.dart`**. |
| `displayLabel` in state | Store **`startDate`**, **`endDate`**, and **`displayLabel`**; recompute **`displayLabel`** inside the bloc whenever dates change via a **pure formatter** (single source of rules). |
| Centralized copy | **Do not** embed user-visible strings in widgets when avoidable: add **`AppStrings`** entries for section title, button labels, smart date labels (**Today** / **Yesterday** / **Tomorrow**), range separator text if needed. *Logic* for when to show those labels stays in Dart (compare calendar dates to “today”), not hardcoded in the UI layer. |
| Colors | Add **`AppColors.scheduleVisitAccent`** (or similar) for **`#5B5BE1`** if not already represented; reuse **`AppColors.splashBackground`** only if product confirms same token — prefer a named semantic color for schedule CTA. |
| Assets | Register **`calendar_white.svg`** in **`AppAssets`** (file exists under `assets/images/` per project). |

## Clean architecture layout

```
lib/features/home/
  domain/
    home_date_display.dart    # Pure: formatDisplayDate(start, end) + helpers (date-only compare)
  presentation/
    view/
      home View               # Compose top section; wire Scaffold endDrawer if needed
    widgets/
      home_schedule_top_section.dart   # Optional: one composed strip (one primary widget per file rule)
    bloc/
      home_screen_bloc.dart, *_event.dart, *_state.dart
lib/widgets/                 # Shared, configurable controls (if used beyond home)
  common_button.dart
  common_icon_button.dart    # Or icon_button_widget.dart — match existing naming in lib/widgets/
  date_selector_widget.dart
  search_bar_widget.dart
```

- **Domain:** `formatDisplayDate(DateTime? start, DateTime? end)` and small private helpers for “is same calendar day as today/yesterday/tomorrow” using **`DateTime.now()`** stripped to date — **no** `context`, no Flutter imports if possible.
- **Presentation:** Bloc owns **`startDate` / `endDate`** updates and emits refreshed **`displayLabel`**. View/widgets dispatch events only.

## BLoC — events and state

**Events** (names can be prefixed with `HomeScreen` to match existing style):

- **`HomeScreenDateForward`** — maps to “next day” behavior below.
- **`HomeScreenDateBackward`** — maps to “previous day” behavior below.
- **`HomeScreenDateSelected`** — carries `DateTime? start`, `DateTime? end` (single: set `start`, `end == null`; range: both non-null, `start <= end`).
- **`HomeScreenFilterPanelOpened`** — UI listener opens end drawer / panel (see side effects).
- **`HomeScreenScheduleVisitOpened`** — same, distinct panel mode if product needs different content.

**State** (extend **`HomeScreenReady`** or introduce a richer “ready” state class with fields):

- **`DateTime? startDate`**
- **`DateTime? endDate`**
- **`String displayLabel`** — always synced by bloc after mutations.

**Navigation / drawer side effects:** Per **`AGENTS.md`**, do **not** navigate from inside the bloc. Prefer:

- Either **flags on state** (`PanelKind? openPanel`) consumed once in **`BlocListener`**, or
- View dispatches event and **immediately** calls a small callback / opens drawer — (*prefer listener + state flag for testability*).

Initial dates: default **`startDate`** to **today (date only)**, **`endDate`** **`null`** on first **`HomeScreenReady`**.

## Date rules (implementation checklist)

1. **Single date** (`endDate == null`, `startDate != null`):  
   - If **`startDate`** is today / yesterday / tomorrow (calendar equality in local timezone) → label from **`AppStrings`** (e.g. `scheduleDateToday`).  
   - Else → **`MM/dd/yyyy`** with **zero-padded** month and day.
2. **Range** (`endDate != null`): always **`MM/dd/yyyy - MM/dd/yyyy`**, no smart labels, even if range includes today.
3. Helper:** `formatDisplayDate`** implemented in **domain**; bloc calls it when emitting.

## Date navigation

- **Backward:** If range mode is active, define product behavior explicitly (recommended: **collapse to single day** = previous calendar day from `startDate`, clear `endDate`; document in code comment). If already single: decrement **`startDate`** by one day (date-only).
- **Forward:** Symmetric.
- Recompute **`displayLabel`** after each change; use **`BlocSelector`** / **`buildWhen`** for the date strip if rebuild cost matters.

## Date picker UX

- **Requirement:** Calendar as **popup anchored to the date control**, not **`showDatePicker`** dialog.
- **Approach options:** `OverlayEntry` + positioned `Material`, or **`showMenu`** with an embedded calendar widget, or a thin third-party widget that supports **range** and can live inside an overlay. **Evaluate** adding a small dependency vs. custom **`CalendarDatePicker`** / **`DateRangePickerDialog`** — *dialog* variants are **not** desired; prefer **overlay/menu** hosting `CalendarDatePicker` / custom grid.
- On selection complete: dispatch **`HomeScreenDateSelected`** with single or range.

## Reusable widgets (contract sketch)

| Widget | Responsibility |
|--------|------------------|
| **`SearchBarWidget`** | Fixed width/height via constructor; decoration consistent with theme; **`onChanged` / optional `controller`**; no bloc inside. |
| **`CommonButton`** | Filled/outlined variants; **`height`**, **`borderRadius`**, colors from theme/constants; optional leading **`SvgPicture`**. |
| **`IconButtonWidget`** | Rounded (`10`), icon-only; configurable tap. |
| **`DateSelectorWidget`** | Shows **`displayLabel`**; left/right **`IconButtonWidget`**; center tappable; callbacks **`onPrev` / `onNext` / `onPickDate`**. |

Keep **one widget class per file** under **`widgets/`** as the tree grows ( **`general.mdc`** / project conventions).

## Design system touches

- **Title “Schedule”:** **`AppFonts`** at **16** with **medium** (`FontWeight.w500` or project’s **`AppFonts.medium`**).
- **Schedule visit button:** height **40**, radius **6**, background from **`AppColors`**, text **14** medium, white; icon **`AppAssets.calendarWhite`** (new key).
- **Filter button:** height **40**, radius **6** (outline vs filled per design — default outline if unspecified).

## Implementation steps (order)

1. **Domain:** `formatDisplayDate` + unit tests (edge cases: null start, range order, midnight boundaries).
2. **Constants:** `AppStrings`, `AppColors`, `AppAssets` updates.
3. **Bloc:** new events/state fields; handlers; preserve existing **`HomeScreenStarted`** flow.
4. **Widgets:** build shared widgets, then home top section composition.
5. **`HomeView`:** replace placeholder **`_HomeContent`** center text with top section; add **`endDrawer`** shell (placeholder) driven by bloc listener.
6. **`flutter analyze`** clean; optional **`bloc_test`** for date navigation and label computation.

# `.cursor/` impact

- **Rules:** No change expected; implementation must stay within **`bloc-patterns.mdc`** (listener for drawer/navigation, **`part`/`part of`**, no Cubit), **`general.mdc`** (centralized strings/assets/colors), **`flutter-development.mdc`** (feature layout), **one-widget-per-file** when splitting widgets.
- **Skills:** **`flutter-package-install`** only if a calendar package is chosen; otherwise rely on **rules** only.

# Risk hotspots

| Risk | Mitigation |
|------|-------------|
| **Row overflow** on narrow devices (fixed **170** search + many buttons) | Use **`LayoutBuilder`**, **`Flexible`/`Expanded`**, or horizontal **`SingleChildScrollView`** for the left group; consider breaking to two lines below a width threshold. |
| **Range + arrow keys** ambiguity | Document and implement one clear rule (e.g. arrows always work on **`startDate`** as single day and clear range). |
| **Timezone / “today”** | Normalize with **`DateUtils`** or custom date-only comparison in **local** timezone consistently. |
| **Duplicate `displayLabel` drift** | Only mutate label inside bloc via **`formatDisplayDate`** after every date mutation. |
| **Calendar popup complexity** | Timebox: start with **`OverlayEntry`** + `CalendarDatePicker` / range custom; upgrade to package if range UX is too costly. |

# Typography standard

All new text styles for this feature must use **`AppFonts`** (e.g. **`AppFonts.medium(16, AppColors.primaryText)`** for the section title, **`AppFonts.medium(14, AppColors.white)`** for schedule CTA). Do **not** introduce ad-hoc **`TextStyle`** literals in widgets when a centralized font helper exists.

---

**Mode:** This document is a **`--plan`** deliverable only. Implementation waits for explicit approval (e.g. **`--implement`** or “proceed”).

# Plan name

**Home schedule — Current / Upcoming / Completed sections (static JSON, local pagination)**

# Description

## Scope

Implement the **visit list** area on Home using **`ScheduleBloc`** only for this flow: partition **`HomeModels.visitTable`** into three buckets by **`visit_date`** (local calendar day vs today), render **`CustomScrollView`** with **`SliverMainAxisGroup`** (pinned header + **`SliverList`**) per **non-empty** section, simulate **10-at-a-time** pagination per section, sticky headers that **stack** (cumulative behavior), header **tap → scroll** via **`GlobalKey` + `Scrollable.ensureVisible`**, row UI per spec, and a **Record Now** FAB. **No API**, **no repository**.

**Companion feature:** existing **`HomeScreenBloc`** remains responsible for the schedule toolbar (dates, search, drawers). **`ScheduleBloc`** owns list sections only.

## Data & domain

| Step | Detail |
|------|--------|
| Source | `lib/core/models/home_models.dart` → `HomeModels.visitTable` |
| Model | New **`HomeVisit`** (`lib/core/models/home_visit.dart`) with **`fromJson`**; nullable fields handled |
| Bucketing | Parse `visit_date` with **`DateTime.parse`**, normalize to **local date-only**; **Current** = same day as today; **Upcoming** = strictly after; **Completed** = strictly before |
| Catalog | After parse, split into three **full** lists in the bloc; UI pages slice **`pageSize = 10`** from each list independently |

## BLoC

| Item | Detail |
|------|--------|
| Name | **`ScheduleBloc`** — `part` / `part of` triad under `lib/features/home/presentation/bloc/` |
| Events | **`ScheduleStarted`**; **`ScheduleSectionLoadMore(ScheduleSectionKind)`** |
| State | **`ScheduleState`** ( **`Equatable`** per product prompt ) with three **`ScheduleSectionSlice`** values: **`items`**, **`hasMore`**, **`page`**, **`isLoading`** |
| Pagination | **`SliverChildBuilderDelegate`** **`childCount = items.length + (hasMore ? 1 : 0)`**; trailing cell is loader + **`ScheduleLoadMoreTrigger`** post-frame **`LoadMore`** when **`!isLoading && hasMore`** |
| Edge | Empty bucket → **omit** that section’s entire group (no header). Duplicates allowed |

## UI structure

- **`HomeBodyContent`:** top **`HomeScheduleTopSection`**, then **`Expanded`** **`Stack`** with **custom scroll** + bottom-right FAB ( **`AppStrings.drawerRecordNow`** / **`AppColors.recordNow`** ).
- **Scroll:** **`CustomScrollView`** with ordered **Current → Upcoming → Completed** groups; each group = **`SliverMainAxisGroup`** → **`SliverPersistentHeader(pinned: true)`** + **`SliverList`**.
- **Header:** fixed height delegate; **`KeyedSubtree`** + **`GlobalKey`** for **`ensureVisible`**; **`InkWell`/`GestureDetector`** dispatches scroll.
- **Row:** time + relative/e **`MM/dd/yyyy`** date column; avatar (**`CircleAvatar`**, **network** + **initials** fallback); name; gender · age; visit type name & description; status chip (Scheduled → blue, Completed → green, Paused → yellow).

## Centralized resources

Add **`AppStrings`** keys for section titles (if not reused) and any new user-visible fallbacks; add **`AppColors`** for status chips if missing. Typography via **`AppFonts`** direct style helpers.

## `.cursor/` impact

- **`flutter-development.mdc` / `bloc-patterns.mdc`**: static data only for this slice — ignore repository / `response_type` / `AppToast` where not applicable.
- **`bloc-patterns.mdc`**: product asks **`Equatable`** on **`ScheduleState`** — intentional exception for rebuild optimization.
- **`one-widget-per-file`**: keep **one primary widget** per file under **`presentation/widgets/`** for new schedule widgets.

## Risk hotspots

| Risk | Mitigation |
|------|------------|
| Sample JSON dates are all **2025** while “today” is **2026** | Only **Completed** may show data; **Current/Upcoming** empty — acceptable; confirms empty-section behavior |
| **`SliverMainAxisGroup`** API / behavior | Requires recent stable Flutter (project **3.35.x**); verify pinned stacking in device run |
| **`Image.network`** failures | **`errorBuilder`** → initials avatar |
| Load-more trigger firing twice | Bloc **no-ops** when **`isLoading`** or **`!hasMore`** |

## Typography standard

Shared text for new schedule rows and headers should use **`AppFonts`** direct helpers (for example `AppFonts.medium(size, color)`) — avoid raw ad-hoc `TextStyle` when reusable helpers exist.

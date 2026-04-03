# Plan name

Settings: personal settings edit dialog (SVG edit icon, form, validation, layout)

## Description

### Scope

- Replace the Material **edit icon** in the settings profile header with the **`edit.svg`** asset (via `flutter_svg`), wired through **`AppAssets`**.
- On edit tap, **open a modal dialog** instead of the current info toast (`AppStrings.settingsEditNotImplemented`).
- Dialog shell:
  - **Background:** white.
  - **Corner radius:** 12 on the card; **header** uses purple with **top-left and top-right** radius 12 so the header visually matches the dialog top.
  - **Width:** `MediaQuery.sizeOf(context).width * 0.80` (clamp if needed for very small screens—optional follow-up).
- **Header row:** title copy **`Personal Setting`** (singular per spec; see note below vs `AppStrings.settingsPersonalSettingsTitle`), **white** text, **font size 14**, **medium** weight via **`AppFonts.medium(14, …)`**; header **background:** project purple (reuse **`AppColors.drawerItemSelected`** / **`AppColors.scheduleVisitAccent`** / **`AppColors.splashBackground`** — same `0xFF5B5BE1` family).

### Form content (mirror settings screen)

Fields must match what **`SettingsBody`** already shows, with layout rules:

| Section | Layout |
|--------|--------|
| **Personal information** | **Two fields per row** (e.g. First name + Last name). |
| **Contact** | **One field per row** (full width): Email, then Phone. |
| **Practitioner details** | Shown only when **`settingsIsDoctorRole(user)`** is true (same as today). **Two fields per row** for pairs; if an odd field remains (e.g. Specialization), use a **single full-width** row for that field. |

Field set from current UI:

- Personal: First name, Last name  
- Contact: Email ID, Phone number  
- Practitioner (doctor): Title, Degree, Medical license number, License expiry date, National provider identifier, Taxonomy code, Specialization  

Use **`AppStrings`** for labels. Add **`AppStrings`** entries for **dialog title** (if keeping “Personal Setting” vs screen title), **Cancel**, **Save**, and **per-field hints** (user requested hints on every field).

### Phone field

- Add dependency **`mask_text_input_formatter`** and use  
  `MaskTextInputFormatter(mask: '+1 (###) ###-####')`  
  (import from that package). Wire **`inputFormatters`** on the phone **`TextFormField`**.

### License expiry date

- **Read-only styled** or formatted text field showing the selected date.
- **Calendar icon** on the **trailing** side of the field (e.g. `suffixIcon`: `AppAssets.calendarWhite` with tinted color or a neutral calendar icon if white-on-white is wrong inside the dialog—adjust tint to **`AppColors.drawerItemSelected`** or use `Icons.calendar_today` only if design requires; prefer existing **`AppAssets`** where possible).
- **`showDatePicker`** (or existing **`calendar_date_picker2`** if you want consistency with other flows) when the user taps **anywhere on the text field** (focus/tap on the field), **not** only when tapping the icon—icon remains a secondary affordance that can call the same handler.

### Validation

- **First name, last name, email:** required / format validators on **`TextFormField`** (email pattern or `parse` check).
- Per **`.cursor/rules/bloc-patterns.mdc`**: validate on **Save** (and optionally show errors after first submit attempt); keep validators in the **UI** layer, not in the BLoC.

### Footer actions (aligned end / right)

- **Cancel:** white background, purple **border** and **label** color, **medium** font.
- **Save:** purple **background** and **border**, **white** label, **medium** font.
- Use **`OutlinedButton`** / **`FilledButton`** or **`TextButton`** with `Side` borders as needed so both match the spec; minimum tap target ~44 logical pixels on mobile.

### State and persistence (implementation phase)

- **Open/close dialog:** can stay **local** to the widget that owns the edit action (e.g. pass `User?` / `SessionUserInfo` into the dialog, or use a `BlocListener` only if Save must drive API flows).
- **Save:** today **`SettingsRepository`** exposes **`fetchCurrentUser`**, **`persistSessionUser`**, **`logout`** — **no update-profile API**. Decide explicitly:
  - **A)** Save = validate + **stub** (toast “saved” / close dialog) until API exists, or  
  - **B)** add **`PUT`/`PATCH` user** via **`ApiService`** in repository, then BLoC handles **`response_type`** and **`persistSessionUser`** on success.  
  The plan assumes **B** for a real Save; if blocked, document **A** in the PR.

### Implementation steps (for `--implement`)

1. Add **`AppAssets.edit`** → `'assets/images/edit.svg'`; ensure asset exists under **`assets/images/`** (already untracked in repo snapshot).
2. Add **`mask_text_input_formatter`** (`flutter pub add mask_text_input_formatter` per project skill).
3. Replace icon in **`SettingsProfileHeader`** with **`SvgPicture.asset(AppAssets.edit, …)`** (size/color to match previous ~18px icon; tint via **`colorFilter`** if SVG is monochrome).
4. Extract or add **`PersonalSettingsEditDialog`** (or similarly named) widget under **`lib/features/settings/presentation/widgets/`**, **`one-widget-per-file`** skill for any extra extracted rows/sections.
5. Build **`Form`** + **`TextFormField`**s with section subtitles reusing **`SettingsSectionTitle`** or lightweight equivalents; use **`Row`** + **`Expanded`** pairs for 2-column rows; single **`TextFormField`** width for contact.
6. Wire date picker + trailing calendar for license expiry.
7. Add **`AppStrings`** for dialog-specific copy and hints; add any missing purple/border styles if not expressible from existing **`AppColors`** alone.
8. If Save calls API: extend repository + BLoC + tests per **`repository-boundaries.mdc`** and **`bloc-patterns.mdc`**.

## `.cursor/` impact

- **`bloc-patterns.mdc`:** Dialog side effects from **`BlocListener`** if Save emits success/failure; no navigation inside BLoC; **`AppToast`** for API errors after save attempts.
- **`flutter-development.mdc` / one-widget-per-file:** New dialog and possibly section row widgets split by file under **`widgets/`**.
- **`flutter-package-install`:** **`mask_text_input_formatter`**.
- **`flutter-assets.mdc`:** Register **`edit`** in **`AppAssets`**; **`pubspec`** already includes **`assets/images/`**.
- **`general.mdc`:** No **`Cubit`**; no **`setState`** for feature state beyond ephemeral dialog controllers if you use **`StatefulWidget`** for pickers—prefer local controllers; if edit state must sync app-wide, use BLoC events.

## Risk hotspots

- **Profile update API** may not exist; Save behavior must be agreed (stub vs real persistence).
- **Phone mask** vs stored **`user.contactNo`** format: loading existing values into the mask may need a small **normalization** step (digits-only → mask).
- **License expiry** type on **`User`** is **`dynamic`**; parsing/display must stay consistent with **`settingsDisplayDateOrDash`** in **`settings_display_format.dart`**.
- **Dialog title** “Personal Setting” vs **`AppStrings.settingsPersonalSettingsTitle`** (“Personal Settings”) — align with product or add a dedicated string key for the dialog header.
- **`isSecureContext`:** Interpreted as user intent that the **date picker opens on text field tap**, not **only** on the icon; icon is additional, not exclusive.

## Typography standard

All specified **14 / medium** (header) and **medium** button labels must use **`AppFonts`** (e.g. **`AppFonts.medium`**) with colors from **`AppColors`**, not ad-hoc **`TextStyle`** literals scattered outside shared styles.

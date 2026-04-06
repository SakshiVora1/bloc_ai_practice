<!-- c7c7b4f9-ba60-449d-832d-ef67f12200d5 -->
---
todos:
  - id: "add-shared-dialog-widget"
    content: "Create reusable `common_dialog.dart` with configurable title/description/confirm action and requested styling."
    status: pending
  - id: "add-centralized-constants"
    content: "Add new `AppStrings` entries and `AppAssets.confirmCheck` for dialog copy and asset path reuse."
    status: pending
  - id: "wire-settings-actions"
    content: "Update `settings_action_row.dart` to open shared dialog for Logout and Delete account with variant-specific labels/actions."
    status: pending
  - id: "implement-delete-account-api-flow"
    content: "Add delete-account API call (`user/delete/$userId`) through repository and handle `response_type` in BLoC with success/error state transitions."
    status: pending
  - id: "verify-format-and-behavior"
    content: "Format touched files and validate dialog visuals + behavior in Settings flow, including delete success/error outcomes."
    status: pending
isProject: false
---
# Reusable Settings Confirmation Dialog Plan

## Scope
Implement a shared confirmation dialog widget for Settings actions so Logout and Delete account use the same UI structure and styling, with configurable title, description, and confirm label.

Strictly follow all workspace rules in `.cursor/rules/` and apply relevant skills in `.cursor/skills/` during implementation.

## Target Files
- `lib/features/settings/presentation/widgets/common_dialog.dart` (new reusable dialog)
- `lib/features/settings/presentation/widgets/settings_action_row.dart` (trigger dialog from both buttons)
- `lib/core/constants/app_strings.dart` (add dialog strings)
- `lib/core/constants/app_assets.dart` (add `confirm_check.svg` constant)
- `lib/features/settings/domain/repositories/settings_repository.dart` (add delete-account contract)
- `lib/features/settings/data/settings_repository_impl.dart` (call `user/delete/$userId`)
- `lib/features/settings/presentation/bloc/settings_event.dart` (add delete event)
- `lib/features/settings/presentation/bloc/settings_state.dart` (add delete loading/error state handling as needed)
- `lib/features/settings/presentation/bloc/settings_bloc.dart` (handle `response_type` success/error for delete flow)
- `lib/features/settings/presentation/view/settings_view.dart` (navigate to login on delete success via listener)

## Implementation Steps
- Create `common_dialog.dart` with a reusable API like:
  - `title`, `description`, `confirmLabel`
  - `imageAsset` (default to confirm check)
  - `onConfirm`
- Build dialog UI to match requested spec:
  - Outer dialog with radius `12`
  - Header container with purple background and top-left/top-right radius `12`
  - Left title text (`AppFonts.medium(15, AppColors.white)`)
  - Right close icon
  - Center image using `SvgPicture.asset(AppAssets.confirmCheck)`
  - Center description text (`AppFonts.medium(17, AppColors.black)`)
  - Bottom row: Cancel + Confirm/Delete buttons
- Reuse button visual style from `personal_settings_edit_panel.dart`:
  - Cancel: white bg, purple text/border, `FontWeight.w500`, existing size/padding/height
  - Primary action: purple bg, white text, `FontWeight.w500`, existing size/padding/height
- Replace direct button actions in `settings_action_row.dart`:
  - Logout button opens dialog with:
    - title: `Confirm`
    - description: `Are you sure want to logout?`
    - confirm label: `Confirm`
    - on confirm: dispatch `SettingsLogoutPressed`
  - Delete account button opens same dialog with:
    - title: `Delete account`
    - description: `Are you sure want to delete an account?`
    - confirm label: `Delete`
    - on confirm: dispatch delete event with current user id
- Implement delete-account API flow:
  - Source user id from the already-loaded settings user data (`SettingsReady.user`)
  - Add repository method that calls endpoint `user/delete/$userId`
  - Keep repository limited to API call + response mapping only
  - In `SettingsBloc`, inspect returned `response_type`:
    - `success` -> emit success/logout-oriented state and trigger navigation to login screen
    - non-success/error -> emit error state and keep user on settings screen
  - Ensure UI side effects stay in listener:
    - navigate to login only on successful delete
    - show error feedback for delete failure via existing toast pattern
- Add new centralized strings and asset constants (no hardcoded literals in widgets):
  - Title/description/labels for both variants
  - `AppAssets.confirmCheck = 'assets/images/confirm_check.svg'`

## Validation
- Run `dart format` on touched files
- Run focused analysis/test checks for Settings UI (`flutter analyze` target set or full if quick)
- Manually verify in Settings screen:
  - Header radius/color and title alignment
  - Image and description alignment
  - Button typography/colors match personal settings panel
  - Close icon and cancel dismiss behavior
  - Logout confirm triggers bloc event
  - Delete confirm calls `user/delete/$userId` with the loaded user id
  - Delete success path navigates to login screen
  - Delete error path does not navigate and shows error feedback
/// Asset paths. Several features share placeholders until full artwork is added
/// under [assets/images/].
abstract final class AppAssets {
  AppAssets._();

  static const String subqdocsWhite = 'assets/images/subqdocs_white.svg';
  static const String backgroundVisit = 'assets/images/background_visit.svg';
  static const String loginImage = 'assets/images/login_image.png';
  static const String visitPage = 'assets/images/visit_page.png';

  // Drawer / shell (stub: reuse white logo SVG until dedicated icons exist).
  static const String visitsMenu = 'assets/images/visits_menu.svg';
  static const String patientsMenu = 'assets/images/patients_menu.svg';
  static const String prescription = 'assets/images/prescription.svg';
  static const String notepad = 'assets/images/notepad.svg';
  static const String email = 'assets/images/email.svg';
  static const String settingsDrawer = 'assets/images/settings_drawer.svg';
  static const String quickStart = 'assets/images/quick_start.svg';
  static const String calendarWhite = 'assets/images/calendar_white.svg';
  static const String filterLogo = 'assets/images/filter_logo.svg';
  static const String logoDrawer = 'assets/images/logo_drawer.svg';
  static const String subqdocsLogoAppbar =
      'assets/images/subqdocs_logo_appbar.svg';
}

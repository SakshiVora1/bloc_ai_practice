abstract final class AppStrings {
  AppStrings._();

  static const String appTitle = 'SubQ Docs';
  static const String loginScreenTitle = 'Login';
  static const String splashLogoSemanticsLabel = 'SubQ Docs logo';

  static const String loginTitle = 'Log In';
  static const String loginSubtitle = 'Welcome back';
  static const String emailAddressLabel = 'Email Address';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot Password?';
  static const String loginButton = 'Log In';
  static const String loginEmailHint = 'johndoe@medical.com';
  static const String loginPasswordHint = '******';
  static const String loginBottomNote =
      'You must have a registered subQdocs account to login.';
  static const String loginRequiredEmail = 'Please enter email address';
  static const String loginInvalidEmail = 'Please enter a valid email address';
  static const String loginRequiredPassword = 'Please enter password';
  static const String loginPasswordLength =
      'Password must be 8 to 20 characters';
  static const String loginPasswordLetter =
      'Password must contain at least one letter';
  static const String loginPasswordNumber =
      'Password must contain at least one number';
  static const String loginPasswordSpecial =
      'Password must contain at least one special character';
  static const String loginGenericFailure =
      'Unable to login right now. Please try again.';
  static const String loginCryptoConfigError =
      'Login is not configured. Please check app encryption settings.';

  static const String homeTitle = 'Home';
  static const String homeSubtitle =
      'Your schedule and visits will appear here.';
  static const String homeLogout = 'Log out';
  static const String homeWelcome = 'Welcome';
  static const String homeUnknownLabel = '—';
  static const String homeCurrentLabel = 'Current';
  static const String homeUpcomingLabel = 'Upcoming';
  static const String homeCompletedLabel = 'Completed';
  static const String homeNoVisitsFound = 'No visits found';

  static const String drawerSchedule = 'Schedule';
  static const String drawerPatients = 'Patients';
  static const String drawerPrescription = 'Prescription';
  static const String drawerPatientCheckIn = 'Patient Check-In';
  static const String drawerContactSupport = 'Contact Support';
  static const String drawerSettings = 'Settings';
  static const String drawerRecordNow = 'Record Now';
  static const String drawerVersionLabel = 'Version: 1.0.0 (1)';
  static const String drawerFeatureComingSoon = 'This section is coming soon.';
  static const String drawerCloseSemantics = 'Close navigation drawer';
  static const String drawerProviderFallback = 'Provider';
  static const String drawerVersionValue = '1.0.0 (1)';

  static const String invalidEmail = 'Please enter a valid email';
  static const String requiredEmail = 'Email is required';
  static const String requiredPassword = 'Password is required';
  static const String weakPassword =
      '8–20 chars, include uppercase, lowercase, number, and special character';

  static const String homeScheduleTopTitle = 'Schedule';
  static const String homeScheduleFilter = 'Filter';
  static const String homeScheduleVisit = 'Schedule Visit';
  static const String homeScheduleDateToday = 'Today';
  static const String homeScheduleDateYesterday = 'Yesterday';
  static const String homeScheduleDateTomorrow = 'Tomorrow';
  static const String homeScheduleSearchHint = 'Search';

  static const String homeScheduleSearchInitial = 'search';
  static const String homeEndDrawerFilterTitle = 'Filters';
  static const String homeEndDrawerScheduleVisitTitle = 'Schedule visit';

  static const String homeDatePickerRangeHint =
      'Tap a date to update; tap again to set the end of a range';

  static const List<String> calendarWeekdayShort = <String>[
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  static const String calendarApply = 'Apply';
  static const String calendarCancel = 'Cancel';
  static const String calendarModeRange = 'Range';
  static const String calendarModeSingle = 'Single day';
  static const String calendarPickerTitle = 'Select dates';
  static const String cancelButton = 'Cancel';

  static const String dateRangePlaceholder = 'Select date range';
  static const String dateShortcutToday = 'Today';
  static const String dateShortcutThisWeek = 'This week';
  static const String dateShortcutThisMonth = 'This month';

  static const String filterPanelTitle = 'Filters';
  static const String filterCloseSemantics = 'Close filters';
  static const String filterDateShortcuts = 'Quick dates';
  static const String filterStatus = 'Status';
  static const String filterProvider = 'Provider';
  static const String filterOffice = 'Office';
  static const String filterClear = 'Clear filters';
  static const String filterButton = 'Filter';

  static const String searchHint = 'Search';

  static const String scheduleListHeading = 'Schedule';
  static const String scheduleListPlaceholder = 'No visits in this range.';
  static const String scheduleVisitButton = 'Schedule visit';
  static const String scheduleVisitPanelTitle = 'Schedule visit';
  static const String scheduleVisitCloseSemantics =
      'Close schedule visit panel';
  static const String scheduleVisitFieldPlaceholder = 'Enter details';
  static const String scheduleVisitSubmit = 'Submit';

  static const String medicalRecordTitle = 'Medical record';
  static String medicalRecordBody(int patientId) =>
      'Medical record for patient $patientId is not available yet.';

  static const String patientsScreenTitle = 'Patients';
  static const String patientsSearchHint = 'Search';
  static const String patientsColPatientName = 'Patient Name';
  static const String patientsColGender = 'Gender';
  static const String patientsColAge = 'Age';
  static const String patientsColLastVisit = 'Last Visit Date';
  static const String patientsColPreviousVisits = 'Previous Visits';
  static const String patientsColAction = 'Action';
  static const String patientsNotAvailable = 'N/A';
  static const String patientsEmptyTitle = 'Your Patient List is Empty';
  static const String patientsEmptyDescription =
      'Start by adding your first patient to manage appointments, view '
      'medical history, and keep track of visits-all in one place';
  static const String patientsRecordNow = 'Record now';
  static const String patientsActionMedicalRecord = 'Medical Record';
  static const String patientsActionSchedule = 'Schedule';
  static const String patientsActionStartVisit = 'Start Visit';
  static const String patientsActionEditPatient = 'Edit Patient';
  static const String patientsAddPatient = 'Add Patient';
  static const String patientsAddPatientComingSoon =
      'Add patient is not available yet.';
  static const String patientsEditPatientComingSoon =
      'Edit patient is not available yet.';
  static const String patientsScheduleComingSoon =
      'Schedule from the list is not available yet.';
  static const String patientsStartVisitComingSoon =
      'Start visit is not available yet.';
  static const String patientsListGenericFailure =
      'Unable to load patients. Please try again.';
  static const String patientsRetry = 'Retry';
  static const String patientsPrev = 'Previous';
  static const String patientsNext = 'Next';

  static const String patientLabel = 'Patient';
  static const String patientSelectorHint = 'Select patient';
  static const String providerLabel = 'Provider';
  static const String providerSelectorHint = 'Select provider';
  static const String officeLocationLabel = 'Office';
  static const String officeSelectorHint = 'Select office';

  static const String visitDateLabel = 'Visit date';
  static const String visitTimeLabel = 'Visit time';
  static const String visitTypeLabel = 'Visit type';
  static const String visitTypeHint = 'Select visit type';

  static const String settingsPersonalSettingsTitle = 'Settings';
  static const String settingsScreenTitle = 'Settings';
  static const String settingsPersonalInformationTitle = 'Personal information';
  static const String settingsContactTitle = 'Contact';
  static const String settingsPractitionerDetailsTitle = 'Practitioner details';
  static const String settingsFirstNameLabel = 'First name';
  static const String settingsLastNameLabel = 'Last name';
  static const String settingsEmailIdLabel = 'Email';
  static const String settingsPhoneNumberLabel = 'Phone';
  static const String settingsOfficeLocationLabel = 'Office locations';
  static const String settingsTitleLabel = 'Title';
  static const String settingsDegreeLabel = 'Degree';
  static const String settingsMedicalLicenseNumberLabel =
      'Medical license number';
  static const String settingsLicenseExpiryDateLabel = 'License expiry';
  static const String settingsNationalProviderIdentifierLabel = 'NPI';
  static const String settingsTaxonomyCodeLabel = 'Taxonomy code';
  static const String settingsSpecializationLabel = 'Specialization';
  static const String settingsFirstNameRequired = 'First name is required';
  static const String settingsLastNameRequired = 'Last name is required';
  static const String settingsHintFirstName = 'First name';
  static const String settingsHintLastName = 'Last name';
  static const String settingsHintEmail = 'Email';
  static const String settingsHintPhone = '+1 (555) 000-0000';
  static const String settingsHintTitle = 'Title';
  static const String settingsHintDegree = 'Degree';
  static const String settingsHintMedicalLicense = 'License number';
  static const String settingsHintLicenseExpiry = 'MM/dd/yyyy';
  static const String settingsHintNpi = 'NPI';
  static const String settingsHintTaxonomy = 'Taxonomy';
  static const String settingsHintSpecialization = 'Specialization';
  static const String settingsPersonalSettingDialogTitle = 'Edit profile';
  static const String settingsDialogCancel = 'Cancel';
  static const String settingsDialogSave = 'Save';
  static const String settingsProfileSaved = 'Profile saved';
  static const String settingsLoadUserFailure =
      'Unable to load your profile. Please try again.';
  static const String settingsLogoutButton = 'Logout';
  static const String settingsDeleteAccountButton = 'Delete account';
  static const String settingsDeleteNotImplemented =
      'Account deletion is not available in this build.';
  static const String settingsEditNotImplemented =
      'Editing is not available in this build.';

  static const String unauthorizedUser =
      'Your session has expired. Please log in again.';
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/data/models/current_user_response.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/data/models/settings_office_location_response.dart';
import 'package:subqdocs_bloc/features/settings/domain/repositories/settings_repository.dart';
import 'package:subqdocs_bloc/features/settings/presentation/bloc/settings_bloc.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    mockRepository = MockSettingsRepository();
  });

  setUpAll(() {
    registerFallbackValue(User(id: 1));
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits SettingsLoading then SettingsReady when fetch succeeds',
    setUp: () {
      when(() => mockRepository.fetchCurrentUser()).thenAnswer(
        (_) async => CurrentUserResponse(
          responseType: 'success',
          responseData: User(id: 9, email: 'u@test.com', firstName: 'A'),
        ),
      );
      when(
        () => mockRepository.persistSessionUser(any()),
      ).thenAnswer((_) async {});
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) => b.add(const SettingsStarted()),
    expect: () => <Matcher>[
      isA<SettingsLoading>(),
      isA<SettingsReady>().having((SettingsReady s) => s.user.id, 'user id', 9),
    ],
    verify: (_) {
      verify(() => mockRepository.fetchCurrentUser()).called(1);
      verify(() => mockRepository.persistSessionUser(any())).called(1);
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits SettingsLoadFailed when response_type is not success',
    setUp: () {
      when(() => mockRepository.fetchCurrentUser()).thenAnswer(
        (_) async =>
            CurrentUserResponse(responseType: 'error', message: 'No user'),
      );
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) => b.add(const SettingsStarted()),
    expect: () => <Matcher>[
      isA<SettingsLoading>(),
      isA<SettingsLoadFailed>().having(
        (SettingsLoadFailed s) => s.message,
        'message',
        'No user',
      ),
    ],
    verify: (_) {
      verifyNever(() => mockRepository.persistSessionUser(any()));
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits SettingsLoadFailed on ApiException',
    setUp: () {
      when(
        () => mockRepository.fetchCurrentUser(),
      ).thenThrow(const NetworkApiException(message: 'offline'));
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) => b.add(const SettingsStarted()),
    expect: () => <Matcher>[
      isA<SettingsLoading>(),
      isA<SettingsLoadFailed>().having(
        (SettingsLoadFailed s) => s.message,
        'message',
        'offline',
      ),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'logout emits logging out then logged out',
    setUp: () {
      when(() => mockRepository.fetchCurrentUser()).thenAnswer(
        (_) async => CurrentUserResponse(
          responseType: 'success',
          responseData: User(id: 1),
        ),
      );
      when(
        () => mockRepository.persistSessionUser(any()),
      ).thenAnswer((_) async {});
      when(() => mockRepository.logout()).thenAnswer((_) async {});
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) async {
      b.add(const SettingsStarted());
      await Future<void>.delayed(Duration.zero);
      b.add(const SettingsLogoutPressed());
    },
    expect: () => <Matcher>[
      isA<SettingsLoading>(),
      isA<SettingsReady>(),
      isA<SettingsLoggingOut>(),
      isA<SettingsLoggedOut>(),
    ],
    verify: (_) {
      verify(() => mockRepository.logout()).called(1);
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'logout works after SettingsLoadFailed',
    setUp: () {
      when(
        () => mockRepository.fetchCurrentUser(),
      ).thenAnswer((_) async => CurrentUserResponse(responseType: 'error'));
      when(() => mockRepository.logout()).thenAnswer((_) async {});
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) async {
      b.add(const SettingsStarted());
      await Future<void>.delayed(Duration.zero);
      b.add(const SettingsLogoutPressed());
    },
    expect: () => <Matcher>[
      isA<SettingsLoading>(),
      isA<SettingsLoadFailed>().having(
        (SettingsLoadFailed s) => s.message,
        'message',
        AppStrings.settingsLoadUserFailure,
      ),
      isA<SettingsLoggingOut>().having(
        (SettingsLoggingOut s) => s.user,
        'user',
        isNull,
      ),
      isA<SettingsLoggedOut>(),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'delete account emits deleting then logged out on success',
    seed: () => SettingsReady(user: User(id: 15)),
    setUp: () {
      when(
        () => mockRepository.deleteCurrentUser(15),
      ).thenAnswer((_) async => CurrentUserResponse(responseType: 'success'));
      when(() => mockRepository.logout()).thenAnswer((_) async {});
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) {
      b.add(const SettingsDeleteAccountPressed(userId: 15));
    },
    expect: () => <Matcher>[
      isA<SettingsDeletingAccount>().having(
        (SettingsDeletingAccount s) => s.user.id,
        'user id',
        15,
      ),
      isA<SettingsLoggedOut>().having(
        (SettingsLoggedOut s) => s.user?.id,
        'user id',
        15,
      ),
    ],
    verify: (_) {
      verify(() => mockRepository.deleteCurrentUser(15)).called(1);
      verify(() => mockRepository.logout()).called(1);
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'delete account emits failure state when response_type is error',
    seed: () => SettingsReady(user: User(id: 8)),
    setUp: () {
      when(() => mockRepository.deleteCurrentUser(8)).thenAnswer(
        (_) async =>
            CurrentUserResponse(responseType: 'error', message: 'not allowed'),
      );
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) {
      b.add(const SettingsDeleteAccountPressed(userId: 8));
    },
    expect: () => <Matcher>[
      isA<SettingsDeletingAccount>(),
      isA<SettingsDeleteAccountFailed>().having(
        (SettingsDeleteAccountFailed s) => s.message,
        'message',
        'not allowed',
      ),
    ],
    verify: (_) {
      verifyNever(() => mockRepository.logout());
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'panel open fetches office locations and preselects ids',
    setUp: () {
      final User user = User(
        id: 3,
        officeLocations: <OfficeLocation>[OfficeLocation(id: 7, name: 'Main')],
      );
      when(() => mockRepository.fetchCurrentUser()).thenAnswer(
        (_) async =>
            CurrentUserResponse(responseType: 'success', responseData: user),
      );
      when(
        () => mockRepository.persistSessionUser(any()),
      ).thenAnswer((_) async {});
      when(() => mockRepository.fetchOfficeLocations()).thenAnswer(
        (_) async => SettingsOfficeLocationResponse(
          responseType: 'success',
          responseData: <SettingsOfficeLocation>[
            SettingsOfficeLocation(id: 7, name: 'Main'),
            SettingsOfficeLocation(id: 8, name: 'North'),
          ],
        ),
      );
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) async {
      b.add(const SettingsStarted());
      await Future<void>.delayed(Duration.zero);
      b.add(const SettingsEditPanelOpened());
    },
    expect: () => <Matcher>[
      isA<SettingsLoading>(),
      isA<SettingsReady>().having(
        (SettingsReady s) => s.selectedOfficeLocationIds,
        'seed ids',
        <int>[7],
      ),
      isA<SettingsReady>().having(
        (SettingsReady s) => s.isOfficeLocationsLoading,
        'loading office locations',
        true,
      ),
      isA<SettingsReady>()
          .having(
            (SettingsReady s) => s.isOfficeLocationsLoading,
            'loading',
            false,
          )
          .having(
            (SettingsReady s) => s.selectedOfficeLocationIds,
            'reconciled ids',
            <int>[7],
          ),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'toggle office location updates selected ids',
    seed: () => SettingsReady(
      user: User(id: 5),
      officeLocations: <SettingsOfficeLocation>[
        SettingsOfficeLocation(id: 1, name: 'A'),
      ],
      selectedOfficeLocationIds: const <int>[],
    ),
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) => b.add(
      const SettingsOfficeLocationSelectionToggled(officeLocationId: 1),
    ),
    expect: () => <Matcher>[
      isA<SettingsReady>().having(
        (SettingsReady s) => s.selectedOfficeLocationIds,
        'selected ids',
        <int>[1],
      ),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'panel open emits office locations failure when API fails',
    setUp: () {
      when(() => mockRepository.fetchCurrentUser()).thenAnswer(
        (_) async => CurrentUserResponse(
          responseType: 'success',
          responseData: User(id: 9),
        ),
      );
      when(
        () => mockRepository.persistSessionUser(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRepository.fetchOfficeLocations(),
      ).thenThrow(const NetworkApiException(message: 'office api down'));
    },
    build: () => SettingsBloc(settingsRepository: mockRepository),
    act: (SettingsBloc b) async {
      b.add(const SettingsStarted());
      await Future<void>.delayed(Duration.zero);
      b.add(const SettingsEditPanelOpened());
    },
    expect: () => <Matcher>[
      isA<SettingsLoading>(),
      isA<SettingsReady>(),
      isA<SettingsReady>().having(
        (SettingsReady s) => s.isOfficeLocationsLoading,
        'loading',
        true,
      ),
      isA<SettingsReady>().having(
        (SettingsReady s) => s.officeLocationsErrorMessage,
        'error message',
        'office api down',
      ),
    ],
  );
}

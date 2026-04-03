import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/data/models/current_user_response.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
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
}

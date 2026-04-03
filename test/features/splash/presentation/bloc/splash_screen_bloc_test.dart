import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/splash/presentation/bloc/splash_screen_bloc.dart';

class MockAppPreferences extends Mock implements AppPreferences {}

void main() {
  late MockAppPreferences mockPrefs;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockPrefs = MockAppPreferences();
    when(() => mockPrefs.initialize()).thenAnswer((_) async {});
  });

  blocTest<SplashScreenBloc, SplashScreenState>(
    'emits SplashComplete with hasSession false when login payload is absent',
    setUp: () {
      when(() => mockPrefs.getString(any())).thenAnswer((_) async => null);
    },
    build: () => SplashScreenBloc(preferences: mockPrefs),
    act: (SplashScreenBloc b) => b.add(const SplashStarted()),
    expect: () => <Matcher>[
      isA<SplashComplete>().having(
        (SplashScreenState s) => (s as SplashComplete).hasSession,
        'hasSession',
        false,
      ),
    ],
    verify: (_) {
      verify(() => mockPrefs.initialize()).called(1);
      verify(
        () => mockPrefs.getString(AppPreferencesKeys.loginResponse),
      ).called(1);
    },
  );

  blocTest<SplashScreenBloc, SplashScreenState>(
    'emits SplashComplete with hasSession true when stored token exists',
    setUp: () {
      when(() => mockPrefs.getString(any())).thenAnswer(
        (_) async => loginModelToJson(
          LoginModel(
            responseType: 'success',
            responseData: ResponseData(token: 'bearer-token'),
          ),
        ),
      );
    },
    build: () => SplashScreenBloc(preferences: mockPrefs),
    act: (SplashScreenBloc b) => b.add(const SplashStarted()),
    expect: () => <Matcher>[
      isA<SplashComplete>().having(
        (SplashScreenState s) => (s as SplashComplete).hasSession,
        'hasSession',
        true,
      ),
    ],
  );

  blocTest<SplashScreenBloc, SplashScreenState>(
    'emits SplashComplete with hasSession false when stored payload is invalid',
    setUp: () {
      when(
        () => mockPrefs.getString(any()),
      ).thenAnswer((_) async => 'not-valid-json');
    },
    build: () => SplashScreenBloc(preferences: mockPrefs),
    act: (SplashScreenBloc b) => b.add(const SplashStarted()),
    expect: () => <Matcher>[
      isA<SplashComplete>().having(
        (SplashScreenState s) => (s as SplashComplete).hasSession,
        'hasSession',
        false,
      ),
    ],
  );
}

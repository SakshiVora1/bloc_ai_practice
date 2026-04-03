import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/login/domain/repositories/login_repository.dart';
import 'package:subqdocs_bloc/features/login/presentation/bloc/login_screen_bloc.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late MockLoginRepository mockRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    mockRepository = MockLoginRepository();
  });

  setUpAll(() {
    registerFallbackValue('');
  });

  blocTest<LoginScreenBloc, LoginScreenState>(
    'toggles obscurePassword',
    build: () => LoginScreenBloc(loginRepository: mockRepository),
    act: (LoginScreenBloc b) => b.add(const LoginPasswordVisibilityToggled()),
    expect: () => <Matcher>[
      isA<LoginScreenState>().having(
        (LoginScreenState s) => s.obscurePassword,
        'obscurePassword',
        false,
      ),
    ],
  );

  blocTest<LoginScreenBloc, LoginScreenState>(
    'updates rememberMe',
    build: () => LoginScreenBloc(loginRepository: mockRepository),
    act: (LoginScreenBloc b) => b.add(const LoginRememberMeChanged(true)),
    expect: () => <Matcher>[
      isA<LoginScreenState>().having(
        (LoginScreenState s) => s.rememberMe,
        'rememberMe',
        true,
      ),
    ],
  );

  blocTest<LoginScreenBloc, LoginScreenState>(
    'emits submitting then success when response_type is success',
    setUp: () {
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => LoginModel(responseType: 'success'));
    },
    build: () => LoginScreenBloc(loginRepository: mockRepository),
    act: (LoginScreenBloc b) =>
        b.add(const LoginSubmitted(email: 'a@b.com', password: 'Valid1!pass')),
    expect: () => <Matcher>[
      isA<LoginScreenState>().having(
        (LoginScreenState s) => s.isSubmitting,
        'isSubmitting',
        true,
      ),
      isA<LoginScreenState>()
          .having((LoginScreenState s) => s.isSubmitting, 'isSubmitting', false)
          .having((LoginScreenState s) => s.didSucceed, 'didSucceed', true),
    ],
    verify: (_) {
      verify(
        () => mockRepository.login(email: 'a@b.com', password: 'Valid1!pass'),
      ).called(1);
    },
  );

  blocTest<LoginScreenBloc, LoginScreenState>(
    'emits submitting then error when response_type is not success',
    setUp: () {
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async =>
            LoginModel(responseType: 'error', message: 'Invalid credentials'),
      );
    },
    build: () => LoginScreenBloc(loginRepository: mockRepository),
    act: (LoginScreenBloc b) =>
        b.add(const LoginSubmitted(email: 'a@b.com', password: 'Valid1!pass')),
    expect: () => <Matcher>[
      isA<LoginScreenState>().having(
        (LoginScreenState s) => s.isSubmitting,
        'isSubmitting',
        true,
      ),
      isA<LoginScreenState>()
          .having((LoginScreenState s) => s.isSubmitting, 'isSubmitting', false)
          .having(
            (LoginScreenState s) => s.errorMessage,
            'errorMessage',
            'Invalid credentials',
          ),
    ],
  );

  blocTest<LoginScreenBloc, LoginScreenState>(
    'emits generic error when repository throws',
    setUp: () {
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('network'));
    },
    build: () => LoginScreenBloc(loginRepository: mockRepository),
    act: (LoginScreenBloc b) =>
        b.add(const LoginSubmitted(email: 'a@b.com', password: 'x')),
    expect: () => <Matcher>[
      isA<LoginScreenState>().having(
        (LoginScreenState s) => s.isSubmitting,
        'isSubmitting',
        true,
      ),
      isA<LoginScreenState>()
          .having((LoginScreenState s) => s.isSubmitting, 'isSubmitting', false)
          .having(
            (LoginScreenState s) => s.errorMessage,
            'errorMessage',
            'Unable to log in. Please try again.',
          ),
    ],
  );
}

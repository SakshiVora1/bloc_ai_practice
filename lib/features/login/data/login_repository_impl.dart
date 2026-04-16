import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/api_service.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/login/domain/repositories/login_repository.dart';

final class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  static const String loginPath = 'auth/login';

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final dynamic data = await _apiService.post(
      loginPath,
      body: <String, dynamic>{'email': email, 'password': password},
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'Login API returned non-object response',
      );
    }
    try {
      return LoginModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw parseApiExceptionFrom(e);
    }
  }
}

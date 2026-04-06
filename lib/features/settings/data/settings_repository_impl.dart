import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/api_service.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/current_user_response.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/data/models/settings_office_location_response.dart';
import 'package:subqdocs_bloc/features/settings/data/settings_user_update_payload.dart';
import 'package:subqdocs_bloc/features/settings/domain/repositories/settings_repository.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({ApiService? apiService, AppPreferences? preferences})
    : _apiService = apiService ?? ApiService(),
      _preferences = preferences ?? AppPreferences.instance;

  final ApiService _apiService;
  final AppPreferences _preferences;

  static const String userPath = 'user';
  static const String officeLocationsPath = 'office-locations';

  @override
  Future<CurrentUserResponse> fetchCurrentUser() async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(userPath, bearerToken: bearer);
    if (data is! Map) {
      throw const ParseApiException(
        message: 'User API returned non-object response',
      );
    }
    try {
      return CurrentUserResponse.fromJson(Map<String, dynamic>.from(data));
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  @override
  Future<CurrentUserResponse> updateCurrentUser(User user) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.put(
      userPath,
      bearerToken: bearer,
      body: settingsUserUpdateRequestBody(user),
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'User update API returned non-object response',
      );
    }
    try {
      return CurrentUserResponse.fromJson(Map<String, dynamic>.from(data));
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  @override
  Future<CurrentUserResponse> deleteCurrentUser(int userId) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.delete(
      '$userPath/delete/$userId',
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'User delete API returned non-object response',
      );
    }
    try {
      return CurrentUserResponse.fromJson(Map<String, dynamic>.from(data));
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  @override
  Future<SettingsOfficeLocationResponse> fetchOfficeLocations() async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(
      officeLocationsPath,
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'Office locations API returned non-object response',
      );
    }
    try {
      return SettingsOfficeLocationResponse.fromJson(
        Map<String, dynamic>.from(data),
      );
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  @override
  Future<void> persistSessionUser(User user, {String? token}) async {
    final String? raw = await _preferences.getString(
      AppPreferencesKeys.loginResponse,
    );
    if (raw == null || raw.trim().isEmpty) {
      return;
    }
    try {
      final LoginModel model = loginModelFromJson(raw);
      if (model.responseData == null) {
        model.responseData = ResponseData(user: user);
      } else {
        model.responseData!.user = user;
      }
      final String resolvedToken = (token != null && token.trim().isNotEmpty)
          ? token.trim()
          : (model.responseData?.token?.trim() ?? '');
      if (resolvedToken.isNotEmpty) {
        model.responseData!.token = resolvedToken;
        user.token = resolvedToken;
      }
      await _preferences.setString(
        AppPreferencesKeys.loginResponse,
        loginModelToJson(model),
      );
    } catch (_) {
      // Ignore corrupt pref payload; session fetch still succeeded in memory.
    }
  }

  @override
  Future<void> logout() async {
    await _preferences.clearAll();
  }

  Future<String?> _sessionBearerToken() async {
    final String? raw = await _preferences.getString(
      AppPreferencesKeys.loginResponse,
    );
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    try {
      final LoginModel model = loginModelFromJson(raw);
      return model.responseData?.token?.trim();
    } catch (_) {
      return null;
    }
  }
}

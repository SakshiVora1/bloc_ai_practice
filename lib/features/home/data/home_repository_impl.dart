import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/api_service.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';
import 'package:subqdocs_bloc/features/home/domain/repositories/home_repository.dart';

final class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({ApiService? apiService, AppPreferences? preferences})
      : _apiService = apiService ?? ApiService(),
        _preferences = preferences ?? AppPreferences.instance;

  final ApiService _apiService;
  final AppPreferences _preferences;

  static const String organizationPath = 'organization';

  @override
  Future<OrganizationModel> getOrganization() async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(organizationPath, bearerToken: bearer);
    if (data is! Map) {
      throw const ParseApiException(
        message: 'Organization API returned non-object response',
      );
    }
    try {
      final dynamic responseData = data['responseData'];
      if (responseData == null || responseData is! Map) {
        throw const ParseApiException(
          message: 'Organization API missing responseData object',
        );
      }
      return OrganizationModel.fromJson(Map<String, dynamic>.from(responseData));
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  static const String getUsersByRolePath = 'getUsersByRole';

  @override
  Future<List<StaffModel>> getUsersByRole({required String role}) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(
      getUsersByRolePath,
      queryParameters: {'role': role},
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(message: 'getUsersByRole API returned non-object response');
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! List) {
      throw const ParseApiException(message: 'getUsersByRole API missing or invalid responseData');
    }
    try {
      return responseData.map((e) => StaffModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  static const String officeLocationsPath = 'office-locations';

  @override
  Future<List<OfficeLocationModel>> getOfficeLocations() async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(officeLocationsPath, bearerToken: bearer);
    if (data is! Map) {
      throw const ParseApiException(message: 'office-locations API returned non-object response');
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! List) {
      throw const ParseApiException(message: 'office-locations API missing or invalid responseData');
    }
    try {
      return responseData.map((e) => OfficeLocationModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  static const String visitTypesPath = 'visit-types';

  @override
  Future<List<VisitTypeModel>> getVisitTypes({int limit = 50, bool isVisibleToUser = true}) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(
      visitTypesPath,
      queryParameters: {
        'limit': limit,
        'is_visible_to_user': isVisibleToUser,
      },
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(message: 'visit-types API returned non-object response');
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! Map) {
      throw const ParseApiException(message: 'visit-types API missing or invalid responseData object');
    }
    final dynamic visitTypesList = responseData['visit_types'];
    if (visitTypesList == null || visitTypesList is! List) {
      throw const ParseApiException(message: 'visit-types API missing or invalid visit_types array');
    }
    try {
      return visitTypesList.map((e) => VisitTypeModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  static const String savedVisitFiltersPath = 'filters/visit';

  @override
  Future<SavedVisitFilters> getSavedVisitFilters() async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(savedVisitFiltersPath, bearerToken: bearer);
    if (data is! Map) {
      throw const ParseApiException(message: 'filters/visit API returned non-object response');
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! Map) {
      throw const ParseApiException(message: 'filters/visit API missing responseData object');
    }
    try {
      return SavedVisitFilters.fromJson(Map<String, dynamic>.from(responseData));
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> updateSavedVisitFilters(SavedVisitFilters filters) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.put(
      savedVisitFiltersPath,
      body: filters.toJson(),
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(message: 'filters/visit API returned non-object response');
    }
    return Map<String, dynamic>.from(data);
  }

  Future<String?> _sessionBearerToken() async {
    return _preferences.getString(
      AppPreferencesKeys.bearerToken,
    );
  }
}

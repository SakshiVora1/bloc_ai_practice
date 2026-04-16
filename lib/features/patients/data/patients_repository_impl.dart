import 'dart:convert';

import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/api_service.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';
import 'package:subqdocs_bloc/features/patients/domain/repositories/patients_repository.dart';

final class PatientsRepositoryImpl implements PatientsRepository {
  PatientsRepositoryImpl({ApiService? apiService, AppPreferences? preferences})
    : _apiService = apiService ?? ApiService(),
      _preferences = preferences ?? AppPreferences.instance;

  final ApiService _apiService;
  final AppPreferences _preferences;

  static const String getAllPatientsPath = 'patient/getAllPatients';

  @override
  Future<PatientsListApiEnvelope> fetchPatients({
    required int page,
    required int limit,
    String search = '',
    List<Map<String, dynamic>> sorting = const <Map<String, dynamic>>[],
  }) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final Map<String, dynamic> query = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    final String trimmedSearch = search.trim();
    if (trimmedSearch.isNotEmpty) {
      query['search'] = trimmedSearch;
    }
    if (sorting.isNotEmpty) {
      query['sorting'] = jsonEncode(sorting);
    }

    final dynamic data = await _apiService.get(
      getAllPatientsPath,
      queryParameters: query,
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'Patients API returned non-object response',
      );
    }
    try {
      return PatientsListApiEnvelope.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw parseApiExceptionFrom(e);
    }
  }

  Future<String?> _sessionBearerToken() async {
    return _preferences.getString(AppPreferencesKeys.bearerToken);
  }
}

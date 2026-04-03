import 'dart:convert';

import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/api_service.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/domain/repositories/patients_repository.dart';

final class PatientsRepositoryImpl implements PatientsRepository {
  PatientsRepositoryImpl({ApiService? apiService, AppPreferences? preferences})
    : _apiService = apiService ?? ApiService(),
      _preferences = preferences ?? AppPreferences.instance;

  final ApiService _apiService;
  final AppPreferences _preferences;

  static const String getAllPatientsPath = 'patient/getAllPatients';

  @override
  Future<PatientsListPageResult> fetchPatientsPage({
    required int page,
    required int limit,
    String? search,
    required List<Map<String, dynamic>> sorting,
  }) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final String trimmed = search?.trim() ?? '';
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sorting': jsonEncode(sorting),
    };
    if (trimmed.isNotEmpty) {
      queryParameters['search'] = trimmed;
    }

    final dynamic data = await _apiService.get(
      getAllPatientsPath,
      queryParameters: queryParameters,
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'Patients API returned non-object response',
      );
    }

    final Map<String, dynamic> map = Map<String, dynamic>.from(data);
    try {
      return _parseEnvelope(map);
    } on FormatException catch (e) {
      throw ParseApiException(message: e.message);
    }
  }

  PatientsListPageResult _parseEnvelope(Map<String, dynamic> json) {
    final String? responseType = json['response_type'] as String?;
    final String? message = json['message'] as String?;
    final dynamic rd = json['responseData'];
    if (rd == null || rd is! Map) {
      return PatientsListPageResult(
        rows: const <PatientListRow>[],
        totalCount: 0,
        totalPage: 0,
        page: 1,
        limit: 80,
        responseType: responseType,
        message: message,
      );
    }
    final Map<String, dynamic> d = Map<String, dynamic>.from(rd);
    final List<dynamic> rawList =
        d['data'] as List<dynamic>? ?? const <dynamic>[];
    final List<PatientListRow> rows = rawList
        .whereType<Map>()
        .map((Map<dynamic, dynamic> e) => _mapRow(Map<String, dynamic>.from(e)))
        .toList();

    return PatientsListPageResult(
      rows: rows,
      totalCount: _parseInt(d['totalCount']) ?? 0,
      totalPage: _parseInt(d['totalPage']) ?? 0,
      page: _parseInt(d['page']) ?? 1,
      limit: _parseInt(d['limit']) ?? 80,
      responseType: responseType,
      message: message,
    );
  }

  PatientListRow _mapRow(Map<String, dynamic> json) {
    final String first = (json['first_name'] as String?)?.trim() ?? '';
    final String last = (json['last_name'] as String?)?.trim() ?? '';
    final String fullName = _joinName(first, last);
    final String? imageUrl = (json['profile_image'] as String?)?.trim();
    final String? imageUrlOrNull = imageUrl != null && imageUrl.isNotEmpty
        ? imageUrl
        : null;

    final int? age = _parseInt(json['age']);
    final String ageDisplay = age == null
        ? AppStringsPatients.naDisplay
        : '$age';

    final String? genderRaw = json['gender'] as String?;
    final String genderInitial = _genderInitial(genderRaw);

    final String? lastVisitRaw = json['lastVisitDate'] as String?;
    final String lastVisitDisplay =
        lastVisitRaw != null && lastVisitRaw.trim().isNotEmpty
        ? lastVisitRaw.trim()
        : AppStringsPatients.naDisplay;

    final int previousVisits = _parseInt(json['previousVisitCount']) ?? 0;

    return PatientListRow(
      id: _parseInt(json['id']) ?? 0,
      fullName: fullName.isEmpty ? AppStringsPatients.naDisplay : fullName,
      profileImageUrl: imageUrlOrNull,
      initials: _initials(first, last, fullName),
      ageDisplay: ageDisplay,
      genderInitial: genderInitial,
      lastVisitDisplay: lastVisitDisplay,
      previousVisitsCount: previousVisits,
      visitId: _parseInt(json['visit_id']),
    );
  }

  static String _joinName(String first, String last) {
    if (first.isEmpty && last.isEmpty) {
      return '';
    }
    if (first.isEmpty) {
      return last;
    }
    if (last.isEmpty) {
      return first;
    }
    return '$first $last';
  }

  static String _initials(String first, String last, String fullName) {
    if (first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    }
    final String f = fullName.trim();
    if (f.isEmpty) {
      return '?';
    }
    final List<String> parts = f
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  static String _genderInitial(String? gender) {
    if (gender == null || gender.trim().isEmpty) {
      return AppStringsPatients.naDisplay;
    }
    return gender.trim()[0].toUpperCase();
  }

  static int? _parseInt(dynamic v) {
    if (v == null) {
      return null;
    }
    if (v is int) {
      return v;
    }
    if (v is num) {
      return v.toInt();
    }
    return int.tryParse(v.toString());
  }

  Future<String?> _sessionBearerToken() async {
    final String? raw = await _preferences.getString(
      AppPreferencesKeys.loginResponse,
    );
    LoginModel? model;
    try {
      if (raw == null || raw.trim().isEmpty) {
        return null;
      }
      model = loginModelFromJson(raw);
    } catch (_) {
      return null;
    }
    return model.responseData?.token?.trim();
  }
}

/// Shared N/A label for repository mapping (avoid circular imports to AppStrings).
abstract final class AppStringsPatients {
  static const String naDisplay = 'N/A';
}

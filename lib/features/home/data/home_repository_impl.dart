import 'dart:convert';
import 'dart:developer';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_maps_apis/places.dart';
import 'package:subqdocs_bloc/core/constants/app_preferences_keys.dart';
import 'package:subqdocs_bloc/core/models/country_option.dart';
import 'package:subqdocs_bloc/core/config/url_service.dart';
import 'package:subqdocs_bloc/core/services/api_exceptions.dart';
import 'package:subqdocs_bloc/core/services/api_service.dart';
import 'package:subqdocs_bloc/core/services/app_preferences.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/data/models/visit_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/schedule_visit_address_suggestion.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';
import 'package:subqdocs_bloc/features/home/domain/repositories/home_repository.dart';
import 'package:subqdocs_bloc/features/patients/data/patients_list_api_envelope.dart';

final class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    ApiService? apiService,
    AppPreferences? preferences,
    GoogleMapsPlaces? googleMapsPlaces,
  }) : _apiService = apiService ?? ApiService(),
       _preferences = preferences ?? AppPreferences.instance,
       _googleMapsPlaces =
           googleMapsPlaces ??
           GoogleMapsPlaces(apiKey: UrlService.googleMapApiKey);

  final ApiService _apiService;
  final AppPreferences _preferences;
  final GoogleMapsPlaces _googleMapsPlaces;

  static const String organizationPath = 'organization';

  @override
  Future<OrganizationModel> getOrganization() async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(
      organizationPath,
      bearerToken: bearer,
    );
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
      return OrganizationModel.fromJson(
        Map<String, dynamic>.from(responseData),
      );
    } catch (e) {
      throw parseApiExceptionFrom(e);
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
      throw const ParseApiException(
        message: 'getUsersByRole API returned non-object response',
      );
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! List) {
      throw const ParseApiException(
        message: 'getUsersByRole API missing or invalid responseData',
      );
    }
    try {
      return responseData
          .map((e) => StaffModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      throw parseApiExceptionFrom(e);
    }
  }

  static const String officeLocationsPath = 'office-locations';

  @override
  Future<List<OfficeLocationModel>> getOfficeLocations() async {
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
        message: 'office-locations API returned non-object response',
      );
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! List) {
      throw const ParseApiException(
        message: 'office-locations API missing or invalid responseData',
      );
    }
    try {
      return responseData
          .map(
            (e) => OfficeLocationModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (e) {
      throw parseApiExceptionFrom(e);
    }
  }

  static const String visitTypesPath = 'visit-types';

  @override
  Future<List<VisitTypeModel>> getVisitTypes({
    int limit = 50,
    bool isVisibleToUser = true,
  }) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(
      visitTypesPath,
      queryParameters: {'limit': limit, 'is_visible_to_user': isVisibleToUser},
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'visit-types API returned non-object response',
      );
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! Map) {
      throw const ParseApiException(
        message: 'visit-types API missing or invalid responseData object',
      );
    }
    final dynamic visitTypesList = responseData['visit_types'];
    if (visitTypesList == null || visitTypesList is! List) {
      throw const ParseApiException(
        message: 'visit-types API missing or invalid visit_types array',
      );
    }
    try {
      return visitTypesList
          .map(
            (e) => VisitTypeModel.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } catch (e) {
      throw parseApiExceptionFrom(e);
    }
  }

  static const String savedVisitFiltersPath = 'filters/visit';
  static const String getAllPatientsPath = 'patient/getAllPatients';

  @override
  Future<SavedVisitFilters> getSavedVisitFilters() async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final dynamic data = await _apiService.get(
      savedVisitFiltersPath,
      bearerToken: bearer,
    );
    if (data is! Map) {
      throw const ParseApiException(
        message: 'filters/visit API returned non-object response',
      );
    }
    final dynamic responseData = data['responseData'];
    if (responseData == null || responseData is! Map) {
      throw const ParseApiException(
        message: 'filters/visit API missing responseData object',
      );
    }
    try {
      return SavedVisitFilters.fromJson(
        Map<String, dynamic>.from(responseData),
      );
    } catch (e) {
      throw parseApiExceptionFrom(e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateSavedVisitFilters(
    SavedVisitFilters filters,
  ) async {
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
      throw const ParseApiException(
        message: 'filters/visit API returned non-object response',
      );
    }
    return Map<String, dynamic>.from(data);
  }

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

  @override
  Future<List<ScheduleVisitAddressSuggestion>> fetchStreetAddressSuggestions({
    required String search,
    required CountryOption country,
  }) async {
    final String trimmedSearch = search.trim();
    if (trimmedSearch.isEmpty) {
      return const <ScheduleVisitAddressSuggestion>[];
    }

    if (UrlService.googleMapApiKey.trim().isEmpty) {
      throw const ParseApiException(
        message: 'Google Maps API key is not configured',
      );
    }

    final PlacesAutocompleteResponse response = await _googleMapsPlaces
        .autocomplete(
          trimmedSearch,
          components: <Component>[
            Component(Component.country, country.isoCode.toLowerCase()),
          ],
          types: const <String>['address'],
        );

    if (response.isOk) {
      final List<Prediction> predictions =
          response.predictions ?? const <Prediction>[];
      return predictions
          .where(
            (Prediction prediction) =>
                (prediction.placeId ?? '').trim().isNotEmpty &&
                (prediction.description ?? '').trim().isNotEmpty,
          )
          .map(
            (Prediction prediction) => ScheduleVisitAddressSuggestion(
              placeId: prediction.placeId!.trim(),
              description: prediction.description!.trim(),
              primaryText: prediction.structuredFormatting?.mainText?.trim(),
              secondaryText: prediction.structuredFormatting?.secondaryText
                  ?.trim(),
            ),
          )
          .toList();
    }

    if (response.hasNoResults) {
      return const <ScheduleVisitAddressSuggestion>[];
    }

    throw ParseApiException(
      message: response.errorMessage?.trim().isNotEmpty == true
          ? response.errorMessage!.trim()
          : 'Unable to load street addresses',
    );
  }

  @override
  Future<ScheduleVisitAddressDetails> fetchStreetAddressDetails({
    required String placeId,
  }) async {
    if (UrlService.googleMapApiKey.trim().isEmpty) {
      throw const ParseApiException(
        message: 'Google Maps API key is not configured',
      );
    }

    final PlacesDetailsResponse response = await _googleMapsPlaces
        .getDetailsByPlaceId(
          placeId,
          fields: const <String>['address_component', 'formatted_address'],
        );

    if (!response.isOk || response.result == null) {
      throw ParseApiException(
        message: response.errorMessage?.trim().isNotEmpty == true
            ? response.errorMessage!.trim()
            : 'Unable to load street address details',
      );
    }

    final PlaceDetails details = response.result!;
    final List<AddressComponent> components =
        details.addressComponents ?? const <AddressComponent>[];

    String componentLongName(String type) {
      for (final AddressComponent component in components) {
        if (component.types?.contains(type) ?? false) {
          return component.longName?.trim() ?? '';
        }
      }
      return '';
    }

    String buildStreetAddress() {
      final String streetNumber = componentLongName('street_number');
      final String route = componentLongName('route');
      final String joined = '$streetNumber $route'.trim();
      if (joined.isNotEmpty) {
        return joined;
      }
      return details.formattedAddress?.trim() ?? '';
    }

    final String city = componentLongName('locality').isNotEmpty
        ? componentLongName('locality')
        : componentLongName('postal_town');

    return ScheduleVisitAddressDetails(
      streetAddress: buildStreetAddress(),
      city: city,
      state: componentLongName('administrative_area_level_1'),
      postalCode: componentLongName('postal_code'),
    );
  }

  static const String currentVisitsPath = 'patient/visits/current';
  static const String upcomingVisitsPath = 'patient/visits/upcoming';
  static const String recordedVisitsPath = 'patient/visits/recorded';

  @override
  Future<VisitListResponse> getCurrentVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  }) async {
    return _getVisits(currentVisitsPath, filters, page, limit);
  }

  @override
  Future<VisitListResponse> getUpcomingVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  }) async {
    return _getVisits(upcomingVisitsPath, filters, page, limit);
  }

  @override
  Future<VisitListResponse> getRecordedVisits({
    required SavedVisitFilters filters,
    int page = 1,
    int limit = 100,
  }) async {
    return _getVisits(recordedVisitsPath, filters, page, limit);
  }

  Future<VisitListResponse> _getVisits(
    String path,
    SavedVisitFilters filters,
    int page,
    int limit,
  ) async {
    final String? bearer = await _sessionBearerToken();
    if (bearer == null || bearer.isEmpty) {
      throw const UnauthorizedApiException(message: 'No active session');
    }

    final String timezone =
        (await FlutterTimezone.getLocalTimezone()).identifier;

    // Construct query parameters as requested
    final Map<String, dynamic> params = {
      'dateRange[startDate]': filters.startDate != null
          ? formatYyyyMmDd(filters.startDate!)
          : formatYyyyMmDd(DateTime.now()),
      'dateRange[endDate]': filters.endDate != null
          ? formatYyyyMmDd(filters.endDate!)
          : (filters.startDate != null
                ? formatYyyyMmDd(filters.startDate!)
                : formatYyyyMmDd(DateTime.now())),
      'timezone': timezone,
      'page': page,
      'limit': limit,
    };

    if (filters.locationIds.isNotEmpty) {
      params['officeLocations[]'] = filters.locationIds;
    }
    if (filters.status.isNotEmpty) {
      params['status[]'] = filters.status;
    }
    if (filters.doctorIds.isNotEmpty) {
      params['doctorsName[]'] = filters.doctorIds;
    }

    log("Parameters : $params");
    final dynamic data = await _apiService.get(
      path,
      queryParameters: params,
      bearerToken: bearer,
    );

    if (data is! Map) {
      throw const ParseApiException(
        message: 'Visits API returned non-object response',
      );
    }

    try {
      return VisitListResponse.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw parseApiExceptionFrom(e);
    }
  }

  Future<String?> _sessionBearerToken() async {
    return _preferences.getString(AppPreferencesKeys.bearerToken);
  }
}

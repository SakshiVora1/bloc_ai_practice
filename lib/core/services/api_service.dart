import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/config/app_config.dart';

import 'device_info_service.dart';
import 'api_exceptions.dart';
import 'unauthorized_session_handler.dart';

class ApiService {
  final Dio _dio;

  ApiService({String? baseUrl, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? AppConfig.baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              responseType: ResponseType.json,
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException err, ErrorInterceptorHandler handler) {
          // Normalize DioException into our typed ApiException.
          final ApiException apiException = _mapDioError(err);
          handler.reject(
            err.copyWith(error: apiException, message: apiException.message),
          );
        },
      ),
    );
  }

  Future<dynamic> _execute(Future<Response<dynamic>> Function() request) async {
    try {
      final Response<dynamic> response = await request();
      return response.data;
    } on DioException catch (e) {
      final ApiException apiException = _unwrapApiException(e);
      if (apiException is UnauthorizedApiException) {
        await UnauthorizedSessionHandler.handleHttpUnauthorized();
      }
      throw apiException;
    } on SocketException catch (_) {
      throw const NetworkApiException(
        message: AppStrings.internetConnectionError,
      );
    } on FormatException catch (e) {
      throw ParseApiException(
        message: readableExceptionMessage(
          e,
          fallbackMessage: AppStrings.invalidServerResponseError,
        ),
        data: e.source,
      );
    } catch (e) {
      throw UnknownApiException(
        message: readableExceptionMessage(
          e,
          fallbackMessage: AppStrings.genericApiError,
        ),
      );
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? bearerToken,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final headers = await _buildHeaders(bearerToken: bearerToken);
    return _execute(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _mergeOptions(options, headers: headers),
      ),
    );
  }

  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    String? bearerToken,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final headers = await _buildHeaders(bearerToken: bearerToken);
    return _execute(
      () => _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _mergeOptions(options, headers: headers),
      ),
    );
  }

  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    String? bearerToken,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final headers = await _buildHeaders(bearerToken: bearerToken);
    return _execute(
      () => _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _mergeOptions(options, headers: headers),
      ),
    );
  }

  /// PUT with `multipart/form-data`. Do not set `Content-Type` manually; Dio
  /// sets the boundary when [data] is [FormData].
  Future<dynamic> putMultipart(
    String path, {
    required FormData data,
    Map<String, dynamic>? queryParameters,
    String? bearerToken,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final Map<String, String> headers = await _buildHeaders(
      bearerToken: bearerToken,
      includeJsonContentType: false,
    );
    return _execute(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _mergeOptions(options, headers: headers),
      ),
    );
  }

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    String? bearerToken,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final headers = await _buildHeaders(bearerToken: bearerToken);
    return _execute(
      () => _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _mergeOptions(options, headers: headers),
      ),
    );
  }

  Options _mergeOptions(
    Options? options, {
    required Map<String, String> headers,
  }) {
    if (options == null) {
      return Options(headers: headers);
    }

    // Merge caller headers with required headers (required keys win).
    final mergedHeaders = <String, dynamic>{...?options.headers, ...headers};

    return options.copyWith(headers: mergedHeaders);
  }

  Future<Map<String, String>> _buildHeaders({
    String? bearerToken,
    bool includeJsonContentType = true,
  }) async {
    final Map<String, String> deviceInfo =
        await DeviceInfoService.getDeviceInfoAsJson();
    final String timezone = await _getCurrentTimezone();

    final Map<String, String> headers = <String, String>{
      'accept': '*/*',
      'x-device-info': jsonEncode(deviceInfo),
      'x-timezone': timezone,
    };
    if (includeJsonContentType) {
      headers['Content-Type'] = 'application/json';
    }

    final String? token = bearerToken?.trim();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<String> _getCurrentTimezone() async {
    final TimezoneInfo localTimezone = await FlutterTimezone.getLocalTimezone();
    return localTimezone.identifier;
  }

  ApiException _unwrapApiException(DioException e) {
    final Object? error = e.error;
    if (error is ApiException) {
      return error;
    }
    return _mapDioError(e);
  }

  ApiException _mapDioError(DioException err) {
    // Timeout handling (explicitly via interceptor as requested).
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return TimeoutApiException(
        message: AppStrings.requestTimeoutError,
        statusCode: err.response?.statusCode,
        data: err.response?.data,
        dioType: err.type,
      );
    }

    if (err.type == DioExceptionType.cancel) {
      return CancelledApiException(
        message: err.message ?? 'Request cancelled',
        statusCode: err.response?.statusCode,
        data: err.response?.data,
        dioType: err.type,
      );
    }

    if (err.type == DioExceptionType.badCertificate) {
      return CertificateApiException(
        message: AppStrings.secureConnectionError,
        statusCode: err.response?.statusCode,
        data: err.response?.data,
        dioType: err.type,
      );
    }

    if (err.type == DioExceptionType.connectionError ||
        err.error is SocketException) {
      return NetworkApiException(
        message: AppStrings.internetConnectionError,
        statusCode: err.response?.statusCode,
        data: err.response?.data,
        dioType: err.type,
      );
    }

    final int? statusCode = err.response?.statusCode;
    final dynamic responseData = err.response?.data;
    final String message = _resolveErrorMessage(
      statusCode: statusCode,
      responseData: responseData,
      dioMessage: err.message,
    );

    // HTTP status mapping.
    switch (statusCode) {
      case 400:
        return BadRequestApiException(
          message: message,
          statusCode: statusCode,
          data: responseData,
          dioType: err.type,
        );
      case 401:
        return UnauthorizedApiException(
          message: AppStrings.unauthorizedUser,
          statusCode: statusCode,
          data: responseData,
          dioType: err.type,
        );
      case 403:
        return ForbiddenApiException(
          message: message,
          statusCode: statusCode,
          data: responseData,
          dioType: err.type,
        );
      case 404:
        return NotFoundApiException(
          message: message,
          statusCode: statusCode,
          data: responseData,
          dioType: err.type,
        );
      case 409:
        return ConflictApiException(
          message: message,
          statusCode: statusCode,
          data: responseData,
          dioType: err.type,
        );
      case 422:
        return UnprocessableEntityApiException(
          message: message,
          statusCode: statusCode,
          data: responseData,
          dioType: err.type,
        );
      default:
        // 500-599 server errors.
        if (statusCode != null && statusCode >= 500 && statusCode <= 599) {
          return ServerErrorApiException(
            message: _isFriendlyMessage(message)
                ? message
                : AppStrings.serverUnavailableError,
            statusCode: statusCode,
            data: responseData,
            dioType: err.type,
          );
        }

        // Unknown mapping.
        if (err.type == DioExceptionType.unknown) {
          return UnknownApiException(
            message: message,
            statusCode: statusCode,
            data: responseData,
            dioType: err.type,
          );
        }

        return UnknownApiException(
          message: message,
          statusCode: statusCode,
          data: responseData,
          dioType: err.type,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      final dynamic message =
          data['message'] ??
          data['error'] ??
          data['detail'] ??
          data['response_message'];
      if (message is String) {
        return _sanitizeMessage(message);
      }
    }

    if (data is String) {
      return _sanitizeMessage(data);
    }

    return null;
  }

  String _resolveErrorMessage({
    required int? statusCode,
    required dynamic responseData,
    required String? dioMessage,
  }) {
    final String? extractedMessage = _extractMessage(responseData);
    final String? sanitizedDioMessage = _sanitizeMessage(dioMessage);

    if (statusCode == 401) {
      return AppStrings.unauthorizedUser;
    }

    if (statusCode != null && statusCode >= 500 && statusCode <= 599) {
      return extractedMessage ?? AppStrings.serverUnavailableError;
    }

    return extractedMessage ??
        sanitizedDioMessage ??
        AppStrings.genericApiError;
  }

  String? _sanitizeMessage(String? message) {
    final String trimmed = message?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }

    final String lowerCased = trimmed.toLowerCase();
    if (lowerCased.contains('status code of') ||
        lowerCased.contains('dioexception') ||
        lowerCased.contains('apiexception(') ||
        lowerCased.startsWith('exception:')) {
      return null;
    }

    return trimmed;
  }

  bool _isFriendlyMessage(String? message) {
    return _sanitizeMessage(message) != null;
  }
}

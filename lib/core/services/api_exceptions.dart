import 'package:dio/dio.dart';

/// Base type for all API failures thrown by [ApiService].
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final DioExceptionType? dioType;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.dioType,
  });

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, dioType: $dioType, message: $message)';
  }
}

class TimeoutApiException extends ApiException {
  const TimeoutApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class BadRequestApiException extends ApiException {
  const BadRequestApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class UnauthorizedApiException extends ApiException {
  const UnauthorizedApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class ForbiddenApiException extends ApiException {
  const ForbiddenApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class NotFoundApiException extends ApiException {
  const NotFoundApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class ConflictApiException extends ApiException {
  const ConflictApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class UnprocessableEntityApiException extends ApiException {
  const UnprocessableEntityApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class ServerErrorApiException extends ApiException {
  const ServerErrorApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class CancelledApiException extends ApiException {
  const CancelledApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class NetworkApiException extends ApiException {
  const NetworkApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class CertificateApiException extends ApiException {
  const CertificateApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class ParseApiException extends ApiException {
  const ParseApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

class UnknownApiException extends ApiException {
  const UnknownApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.dioType,
  });
}

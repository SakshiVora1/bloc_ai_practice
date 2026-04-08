import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/data/settings_user_update_payload.dart';

String _formFieldString(dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is String) {
    return value;
  }
  if (value is num || value is bool) {
    return value.toString();
  }
  return jsonEncode(value);
}

/// Multipart body for profile update with optional `user_image` file and/or
/// `isDeleteProfileImage`.
Future<FormData> buildSettingsUserUpdateFormData({
  required User user,
  String? profileImageFilePath,
  bool deleteProfileImage = false,
}) async {
  final Map<String, dynamic> body = settingsUserUpdateRequestBody(user);
  final Map<String, dynamic> map = <String, dynamic>{};
  for (final MapEntry<String, dynamic> e in body.entries) {
    if (e.value == null) {
      continue;
    }
    map[e.key] = _formFieldString(e.value);
  }
  final String trimmedPath = profileImageFilePath?.trim() ?? '';
  final bool hasFile = trimmedPath.isNotEmpty;
  if (deleteProfileImage && !hasFile) {
    map['isDeleteProfileImage'] = 'true';
  }
  if (hasFile) {
    final String? mime = lookupMimeType(trimmedPath);
    final MediaType contentType = MediaType.parse(mime ?? 'image/jpeg');
    map['user_image'] = await MultipartFile.fromFile(
      trimmedPath,
      filename: Uri.file(trimmedPath).pathSegments.last,
      contentType: contentType,
    );
  }
  return FormData.fromMap(map);
}

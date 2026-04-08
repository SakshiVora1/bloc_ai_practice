import 'package:subqdocs_bloc/data/models/current_user_response.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';
import 'package:subqdocs_bloc/features/settings/data/models/settings_office_location_response.dart';

abstract interface class SettingsRepository {
  Future<CurrentUserResponse> fetchCurrentUser();

  /// Persists profile fields. Use [profileImageFilePath] and/or
  /// [deleteProfileImage] to send multipart `user_image` / `isDeleteProfileImage`.
  Future<CurrentUserResponse> updateCurrentUser(
    User user, {
    String? profileImageFilePath,
    bool deleteProfileImage = false,
  });

  Future<CurrentUserResponse> deleteCurrentUser(int userId);

  Future<SettingsOfficeLocationResponse> fetchOfficeLocations();

  Future<void> persistSessionUser(User user, {String? token});

  Future<void> logout();
}

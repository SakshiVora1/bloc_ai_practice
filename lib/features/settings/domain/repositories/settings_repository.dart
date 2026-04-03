import 'package:subqdocs_bloc/data/models/current_user_response.dart';
import 'package:subqdocs_bloc/data/models/login_model.dart';

abstract interface class SettingsRepository {
  Future<CurrentUserResponse> fetchCurrentUser();

  Future<void> persistSessionUser(User user);

  Future<void> logout();
}

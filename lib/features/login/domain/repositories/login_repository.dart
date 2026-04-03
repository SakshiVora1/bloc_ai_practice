import 'package:subqdocs_bloc/data/models/login_model.dart';

abstract interface class LoginRepository {
  Future<LoginModel> login({required String email, required String password});
}

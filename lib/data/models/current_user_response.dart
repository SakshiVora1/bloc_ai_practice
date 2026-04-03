import 'package:subqdocs_bloc/data/models/login_model.dart';

/// Envelope for GET `user` where [responseData] is a flat [User] object,
/// or a map containing `user` plus optional `token`.
class CurrentUserResponse {
  CurrentUserResponse({
    this.responseData,
    this.message,
    this.toast,
    this.responseType,
  });

  final User? responseData;
  final String? message;
  final bool? toast;
  final String? responseType;

  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) {
    return CurrentUserResponse(
      responseData: _parseResponseUser(json['responseData']),
      message: json['message'] as String?,
      toast: json['toast'] as bool?,
      responseType: json['response_type'] as String?,
    );
  }

  static User? _parseResponseUser(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is! Map) {
      return null;
    }
    final Map<String, dynamic> m = Map<String, dynamic>.from(raw);
    final Object? nestedUser = m['user'];
    if (nestedUser is Map) {
      final User u = User.fromJson(Map<String, dynamic>.from(nestedUser));
      final String? t = m['token'] as String?;
      if (t != null && t.isNotEmpty) {
        u.token = t;
      }
      return u;
    }
    return User.fromJson(m);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'responseData': responseData?.toJson(),
    'message': message,
    'toast': toast,
    'response_type': responseType,
  };
}

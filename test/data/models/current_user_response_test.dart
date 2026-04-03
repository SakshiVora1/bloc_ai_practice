import 'package:flutter_test/flutter_test.dart';
import 'package:subqdocs_bloc/data/models/current_user_response.dart';

void main() {
  test('fromJson reads flat responseData user and token on user', () {
    final CurrentUserResponse r = CurrentUserResponse.fromJson(
      <String, dynamic>{
        'response_type': 'success',
        'responseData': <String, dynamic>{
          'id': 9,
          'first_name': 'A',
          'token': 'tok-from-flat',
        },
      },
    );
    expect(r.responseData?.token, 'tok-from-flat');
    expect(r.responseData?.id, 9);
  });

  test('fromJson reads nested user and sibling token', () {
    final CurrentUserResponse r = CurrentUserResponse.fromJson(
      <String, dynamic>{
        'response_type': 'success',
        'responseData': <String, dynamic>{
          'user': <String, dynamic>{'id': 9, 'first_name': 'A'},
          'token': 'tok-envelope',
        },
      },
    );
    expect(r.responseData?.token, 'tok-envelope');
    expect(r.responseData?.id, 9);
    expect(r.responseData?.firstName, 'A');
  });
}

class SettingsOfficeLocationResponse {
  SettingsOfficeLocationResponse({
    this.responseType,
    this.message,
    this.responseData = const <SettingsOfficeLocation>[],
  });

  factory SettingsOfficeLocationResponse.fromJson(Map<String, dynamic> json) {
    return SettingsOfficeLocationResponse(
      responseType: json['response_type'] as String?,
      message: json['message'] as String?,
      responseData:
          (json['responseData'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(SettingsOfficeLocation.fromJson)
              .toList() ??
          <SettingsOfficeLocation>[],
    );
  }

  final String? responseType;
  final String? message;
  final List<SettingsOfficeLocation> responseData;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'response_type': responseType,
    'message': message,
    'responseData': responseData
        .map((SettingsOfficeLocation office) => office.toJson())
        .toList(),
  };
}

class SettingsOfficeLocation {
  SettingsOfficeLocation({this.id, this.name});

  factory SettingsOfficeLocation.fromJson(Map<String, dynamic> json) {
    return SettingsOfficeLocation(
      id: _readInt(json['id']),
      name: json['name'] as String?,
    );
  }

  final int? id;
  final String? name;

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

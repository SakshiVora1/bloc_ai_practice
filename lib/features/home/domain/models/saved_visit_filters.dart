import 'package:subqdocs_bloc/core/utils/date_formatters.dart';

class SavedVisitFilters {
  SavedVisitFilters({
    this.status = const [],
    this.doctorIds = const [],
    this.maIds = const [],
    this.locationIds = const [],
    this.startDate,
    this.endDate,
  });

  factory SavedVisitFilters.fromJson(Map<String, dynamic> json) {
    return SavedVisitFilters(
      status: (json['status'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      doctorIds: (json['doctorsName'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString()) ?? 0).where((id) => id != 0).toList() ?? const [],
      maIds: (json['medicalAssistantsName'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString()) ?? 0).where((id) => id != 0).toList() ?? const [],
      locationIds: (json['officeLocations'] as List<dynamic>?)?.map((e) => int.tryParse(e.toString()) ?? 0).where((id) => id != 0).toList() ?? const [],
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'].toString()) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate'].toString()) : null,
    );
  }

  final List<String> status;
  final List<int> doctorIds;
  final List<int> maIds;
  final List<int> locationIds;
  final DateTime? startDate;
  final DateTime? endDate;

  Map<String, dynamic> toJson() {
    final DateTime now = DateTime.now();
    final String startStr = startDate != null ? formatYyyyMmDd(startDate!) : formatYyyyMmDd(now);
    final String endStr = endDate != null ? formatYyyyMmDd(endDate!) : startStr;

    return {
      'status': status,
      'doctorsName': doctorIds,
      'medicalAssistantsName': maIds,
      'officeLocations': locationIds,
      'thirdPartyVisitStatus': [],
      'startDate': startStr,
      'endDate': endStr,
    };
  }
}

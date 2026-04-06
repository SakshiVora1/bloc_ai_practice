import 'package:meta/meta.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';

@immutable
final class PatientsListApiEnvelope {
  const PatientsListApiEnvelope({
    required this.responseType,
    required this.message,
    required this.responseData,
  });

  final String? responseType;
  final String? message;
  final PatientsListPageData? responseData;

  factory PatientsListApiEnvelope.fromJson(Map<String, dynamic> json) {
    final dynamic rd = json['responseData'];
    return PatientsListApiEnvelope(
      responseType: json['response_type'] as String?,
      message: json['message'] as String?,
      responseData: rd is Map<String, dynamic>
          ? PatientsListPageData.fromJson(rd)
          : null,
    );
  }
}

@immutable
final class PatientsListPageData {
  const PatientsListPageData({
    required this.rows,
    required this.totalCount,
    required this.totalPage,
    required this.page,
    required this.limit,
  });

  final List<PatientListRow> rows;
  final int totalCount;
  final int totalPage;
  final int page;
  final int limit;

  factory PatientsListPageData.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? rawList = json['data'] as List<dynamic>?;
    final List<PatientListRow> rows = <PatientListRow>[];
    if (rawList != null) {
      for (final dynamic e in rawList) {
        if (e is Map<String, dynamic>) {
          rows.add(PatientListRow.fromApiJson(e));
        } else if (e is Map) {
          rows.add(PatientListRow.fromApiJson(Map<String, dynamic>.from(e)));
        }
      }
    }

    int parseInt(dynamic v, {int fallback = 0}) {
      if (v is int) {
        return v;
      }
      if (v is num) {
        return v.toInt();
      }
      return int.tryParse(v?.toString() ?? '') ?? fallback;
    }

    return PatientsListPageData(
      rows: rows,
      totalCount: parseInt(json['totalCount']),
      totalPage: parseInt(json['totalPage'], fallback: 1),
      page: parseInt(json['page'], fallback: 1),
      limit: parseInt(json['limit'], fallback: 80),
    );
  }
}

import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/features/home/domain/models/saved_visit_filters.dart';

abstract interface class HomeRepository {
  Future<OrganizationModel> getOrganization();
  Future<List<StaffModel>> getUsersByRole({required String role});
  Future<List<OfficeLocationModel>> getOfficeLocations();
  Future<List<VisitTypeModel>> getVisitTypes({int limit = 50, bool isVisibleToUser = true});
  Future<SavedVisitFilters> getSavedVisitFilters();
  Future<Map<String, dynamic>> updateSavedVisitFilters(SavedVisitFilters filters);
}

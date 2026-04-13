import 'package:subqdocs_bloc/data/models/organization_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';

class OrganizationSingleton {
  static final OrganizationSingleton _instance = OrganizationSingleton._internal();

  factory OrganizationSingleton() {
    return _instance;
  }

  OrganizationSingleton._internal();

  OrganizationModel? organization;
  List<StaffModel> doctors = [];
  List<StaffModel> medicalAssistants = [];
  List<OfficeLocationModel> officeLocations = [];
  List<VisitTypeModel> visitTypes = [];
}

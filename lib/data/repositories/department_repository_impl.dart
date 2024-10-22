import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/department.dart';

import '../../domain/repositories/department_repository.dart';

class DepartmentRepositoryImpl
    with DatabaseService<Department>
    implements DepartmentRepository {

  @override
  Future<List<Department>> getAllDepartments() {
    return getAll(
      fromMap: (Map<String, dynamic> json) => Department.fromMap(json),
      table: DatabaseRequest.tableDepartments,
    );
  }
}

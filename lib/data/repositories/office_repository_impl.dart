import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/office.dart';

import '../../domain/repositories/office_repository.dart';

class OfficeRepositoryImpl
    with DatabaseService<Office>
    implements OfficeRepository {
  @override
  Future<Office> createOffice(
      {String? officeNumber,
      required int departmentId,
      required int printerId}) {
    return createObject(
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
      data: Office(
        departmentId: departmentId,
        printerId: printerId,
        officeNumber: officeNumber,
      ).toMap(),
    );
  }

  @override
  Future<List<Office>> getAllOffices() {
    return getAll(
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
    );
  }

  @override
  Future<Office?> updateOffice(
      {required int id,
      String? officeNumber,
      required int departmentId,
      required int printerId}) {
    return updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
      data: Office(
        departmentId: departmentId,
        printerId: printerId,
        officeNumber: officeNumber,
      ).toMap(),
    );
  }
}

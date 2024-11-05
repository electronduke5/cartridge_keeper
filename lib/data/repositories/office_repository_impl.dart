import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/common/failure.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/office.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/office_repository.dart';
import '../models/cartridge.dart';
import '../models/department.dart';

class OfficeRepositoryImpl
    with DatabaseService<Office>
    implements OfficeRepository {
  @override
  Future<Either<Failure, Office>> createOffice({
    String? officeNumber,
    required String replacementDate,
    required Department department,
    required Cartridge cartridge,
  }) async {
    return await createObject(
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
      data: Office(
        department: department,
        replacementDate: replacementDate,
        cartridge: cartridge,
        officeNumber: officeNumber,
      ).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Office>>> getAllOffices() async {
    return await getAllWithReference(
      referenceColumns: ['department_id', 'cartridge_id'],
      referenceTables: [
        DatabaseRequest.tableDepartments,
        DatabaseRequest.tableCartridges,
      ],
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, Office>> updateOffice({
    required int id,
    String? officeNumber,
    required String replacementDate,
    required Department department,
    required Cartridge cartridge,
  }) async {
    return await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
      data: Office(
        replacementDate: replacementDate,
        department: department,
        cartridge: cartridge,
        officeNumber: officeNumber,
      ).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, String>> deleteOffice(int id) async {
    return await deleteObject(
      id: id,
      table: DatabaseRequest.tableOffices,
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }
}

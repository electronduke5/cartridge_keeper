import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/common/failure.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/office.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/office_repository.dart';

class OfficeRepositoryImpl
    with DatabaseService<Office>
    implements OfficeRepository {
  @override
  Future<Either<Failure, Office>> createOffice(
      {String? officeNumber,
      required int departmentId,
      required int printerId}) async {
    return await createObject(
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
      data: Office(
        departmentId: departmentId,
        printerId: printerId,
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
    return await getAll(
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
  Future<Either<Failure, Office>> updateOffice(
      {required int id,
      String? officeNumber,
      required int departmentId,
      required int printerId}) async {
    return await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Office.fromMap(json),
      table: DatabaseRequest.tableOffices,
      data: Office(
        departmentId: departmentId,
        printerId: printerId,
        officeNumber: officeNumber,
      ).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }
}

import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/compatibility.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../domain/repositories/compatibility_repository.dart';

class CompatibilityRepositoryImpl
    with DatabaseService<Compatibility>
    implements CompatibilityRepository {
  @override
  Future<Either<Failure, Compatibility>> createCompatibility(
      {required printerId, required cartridgeModel}) async {
    return await createObject(
      fromMap: (Map<String, dynamic> json) => Compatibility.fromMap(json),
      table: DatabaseRequest.tableCompatibility,
      data:
          Compatibility(printerId: printerId, cartridgeModel: cartridgeModel).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Compatibility>>> getAllCompatibility() async {
    return await getAll(
      fromMap: (Map<String, dynamic> json) => Compatibility.fromMap(json),
      table: DatabaseRequest.tableCompatibility,
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, String>> cleanCompatibilitiesByPrinter(int printerId) {
    return deleteObjectWhere(
      table: DatabaseRequest.tableCompatibility,
      whereColumn: 'printer_id',
      whereArgs: [printerId],
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }
}

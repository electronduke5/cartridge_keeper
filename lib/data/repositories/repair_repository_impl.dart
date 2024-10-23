import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../domain/repositories/repair_repository.dart';

class RepairRepositoryImpl
    with DatabaseService<Repair>
    implements RepairRepository {
  @override
  Future<Either<Failure, Repair>> createRepair(
      {required DateTime startDate, required int cartridgeId}) async {
    return await createObject(
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
      data: Repair(startDate: startDate, cartridgeId: cartridgeId).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Repair>>> getAllRepairs() async {
    return await getAll(
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
    );
  }

  @override
  Future<Either<Failure, Repair>> updateRepair(
      {required int id,
      required DateTime startDate,
      DateTime? endDate,
      required int cartridgeId}) async {
    return await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
      data: Repair(
              startDate: startDate, cartridgeId: cartridgeId, endDate: endDate)
          .toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }
}

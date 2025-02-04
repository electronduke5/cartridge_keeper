import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../domain/repositories/repair_repository.dart';
import '../models/cartridge.dart';

class RepairRepositoryImpl
    with DatabaseService<Repair>
    implements RepairRepository {
  @override
  Future<Either<Failure, Repair>> createRepair(
      {required String? startDate, required Cartridge cartridge}) async {
    return await createObject(
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
      data: Repair(startDate: startDate, cartridge: cartridge).toMap(),
    ).then(
      (result) {
        //TODO: Тут проверить что возвращается, почему то 0
        return result.fold(
          (l) => Left(l),
          (r) => Right(r),
        );
      },
    );
  }

  @override
  Future<Either<Failure, List<Repair>>> getAllRepairs() async {
    return await getAllWithReference(
      referenceTables: [DatabaseRequest.tableCartridges],
      referenceColumns: ['cartridge_id'],
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
    );
  }

  @override
  Future<Either<Failure, Repair>> updateRepair(
      {required int id,
      required String startDate,
      String? endDate,
      required Cartridge cartridge}) async {
    return await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
      data: Repair(startDate: startDate, cartridge: cartridge, endDate: endDate)
          .toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> finishRepair({
    required int id,
    required String endDate,
  }) async {
    final repair = await updateObject(
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      id: id,
      table: DatabaseRequest.tableRepairs,
      data: {'end_date': endDate},
    );
    return repair.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> startRepair({required int id}) async {
    final repair = await updateObject(
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      id: id,
      table: DatabaseRequest.tableRepairs,
      data: {'start_date': DateTime.now().toLocalFormat},
    );
    return repair.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, String>> deleteRepair(int id) async {
    final resultDelete =
        await deleteObject(table: DatabaseRequest.tableRepairs, id: id);
    return resultDelete.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Repair>>> getAllRepairsByCartridge(
      int cartridgeId) async {
    return await getAllWithReference(
      referenceTables: [DatabaseRequest.tableCartridges],
      referenceColumns: ['cartridge_id'],
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
      whereColumn: 'cartridge_id',
      whereArg: cartridgeId.toString(),
    );
  }
}

import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/repair.dart';

import '../../domain/repositories/repair_repository.dart';

class RepairRepositoryImpl
    with DatabaseService<Repair>
    implements RepairRepository {
  @override
  Future<Repair> createRepair(
      {required DateTime startDate, required int cartridgeId}) {
    return createObject(
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
      data: Repair(startDate: startDate, cartridgeId: cartridgeId).toMap(),
    );
  }

  @override
  Future<List<Repair>> getAllRepairs() {
    return getAll(
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
    );
  }

  @override
  Future<Repair> updateRepair(
      {required int id,
      required DateTime startDate,
      DateTime? endDate,
      required int cartridgeId}) {
    return updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Repair.fromMap(json),
      table: DatabaseRequest.tableRepairs,
      data: Repair(
              startDate: startDate, cartridgeId: cartridgeId, endDate: endDate)
          .toMap(),
    );
  }
}

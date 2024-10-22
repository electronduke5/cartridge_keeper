import 'package:cartridge_keeper/data/models/repair.dart';

abstract class RepairRepository {
  Future<List<Repair>> getAllRepairs();

  Future<Repair> createRepair({
    required DateTime startDate,
    required int cartridgeId,
  });

  Future<Repair> updateRepair({
    required int id,
    required DateTime startDate,
    DateTime? endDate,
    required int cartridgeId,
  });
}

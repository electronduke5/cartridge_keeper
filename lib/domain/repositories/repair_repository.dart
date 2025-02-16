import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/models/cartridge.dart';

abstract class RepairRepository {
  Future<Either<Failure,List<Repair>>> getAllRepairs();
  Future<Either<Failure,List<Repair>>> getAllRepairsByCartridge(int cartridgeId);

  Future<Either<Failure,String>> deleteRepair(int id);

  Future<Either<Failure,Repair>> createRepair({
    required String? startDate,
    required Cartridge cartridge,
  });

  Future<Either<Failure,Repair>> updateRepair({
    required int id,
    required String startDate,
    String? endDate,
    required Cartridge cartridge,
  });

  Future<Either<Failure, void>> finishRepair({
    required int id,
    required String endDate,
  });

  Future<Either<Failure, void>> startRepair({required int id});
}

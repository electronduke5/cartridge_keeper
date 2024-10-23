import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

abstract class RepairRepository {
  Future<Either<Failure,List<Repair>>> getAllRepairs();

  Future<Either<Failure,Repair>> createRepair({
    required DateTime startDate,
    required int cartridgeId,
  });

  Future<Either<Failure,Repair>> updateRepair({
    required int id,
    required DateTime startDate,
    DateTime? endDate,
    required int cartridgeId,
  });
}

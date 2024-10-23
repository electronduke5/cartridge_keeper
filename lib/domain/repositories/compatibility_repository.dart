import 'package:cartridge_keeper/data/models/compatibility.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

abstract class CompatibilityRepository{
  Future<Either<Failure, List<Compatibility>>> getAllCompatibility();

  Future<Either<Failure, Compatibility>> createCompatibility({required printerId, required cartridgeId});
}
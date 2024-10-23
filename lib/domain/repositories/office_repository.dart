import 'package:cartridge_keeper/data/models/office.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

abstract class OfficeRepository {
  Future<Either<Failure,List<Office>>> getAllOffices();

  Future<Either<Failure, Office>> createOffice({
    String officeNumber,
    required int departmentId,
    required int printerId,
  });

  Future<Either<Failure, Office>> updateOffice({
    required int id,
    String officeNumber,
    required int departmentId,
    required int printerId,
  });
}

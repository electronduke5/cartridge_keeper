import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:cartridge_keeper/data/models/department.dart';
import 'package:cartridge_keeper/data/models/office.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

abstract class OfficeRepository {
  Future<Either<Failure,List<Office>>> getAllOffices();

  Future<Either<Failure, Office>> createOffice({
    String officeNumber,
    required String replacementDate,
    required Department department,
    required Cartridge cartridge,
  });

  Future<Either<Failure, Office>> updateOffice({
    required int id,
    String officeNumber,
    required String replacementDate,
    required Department department,
    required Cartridge cartridge,
  });

  Future<Either<Failure, String>> deleteOffice(int id);
}

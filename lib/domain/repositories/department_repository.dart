import 'package:cartridge_keeper/data/models/department.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

abstract class DepartmentRepository{
  Future<Either<Failure, List<Department>>> getAllDepartments();
}
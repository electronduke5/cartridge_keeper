import 'package:cartridge_keeper/data/models/department.dart';

abstract class DepartmentRepository{
  Future<List<Department>> getAllDepartments();
}
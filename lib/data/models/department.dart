import 'package:cartridge_keeper/domain/entity/department.dart';

class Department extends DepartmentEntity {
  Department({required super.name});

  Map<String, dynamic> toMap() => {'name': name};

  factory Department.fromMap(Map<String, dynamic> json) =>
      Department(name: json['name']);
}

import 'package:cartridge_keeper/domain/entity/department.dart';

class Department extends DepartmentEntity {
  Department({required super.name, super.id});

  Map<String, dynamic> toMap() => {'name': name};

  factory Department.fromMap(Map<String, dynamic> json) => Department(
        id: json['id'] as int,
        name: json['name'],
      );
}

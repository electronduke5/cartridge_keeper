import 'package:cartridge_keeper/domain/entity/office.dart';

import 'cartridge.dart';
import 'department.dart';

class Office extends OfficeEntity {
  Office({
    super.id,
    super.officeNumber,
    required super.department,
    required super.cartridge,
    required super.replacementDate,
  });

  Map<String, dynamic> toMap() => {
        'office_number': officeNumber,
        'replacement_date': replacementDate,
        'department_id': department.id,
        'cartridge_id': cartridge.id,
      };

  factory Office.fromMap(Map<String, dynamic> json) => Office(
        id: json['id'] as int,
        officeNumber: json['office_number'],
        replacementDate: json['replacement_date'],
        department: Department.fromMap(<String, dynamic>{
          'id': json['department_id'] as int,
          'name': json['name'],
        }),
        cartridge: Cartridge.fromMap(<String, dynamic>{
          'id': json['cartridge_id'] as int,
          'mark': json['mark']?.toString(),
          'model': json['model'],
          'inventory_number': json['inventory_number'],
        }),
      );
}

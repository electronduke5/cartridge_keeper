import 'package:cartridge_keeper/domain/entity/office.dart';

class Office extends OfficeEntity {
  Office({
    super.officeNumber,
    required super.departmentId,
    required super.printerId,
  });

  Map<String, dynamic> toMap() => {
        'office_number': officeNumber,
        'department_id': departmentId,
        'printer_id': printerId,
      };

  factory Office.fromMap(Map<String, dynamic> json) => Office(
        officeNumber: json['office_number'],
        departmentId: json['department_id'] as int,
        printerId: json['printer_id'] as int,
      );
}

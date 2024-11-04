import 'package:cartridge_keeper/data/models/department.dart';

import '../../data/models/cartridge.dart';

class OfficeEntity {
  late int id;
  final String? officeNumber;
  final Department department;
  final Cartridge cartridge;
  final String replacementDate;

  OfficeEntity({
    this.id = 0,
    this.officeNumber,
    required this.department,
    required this.cartridge,
    required this.replacementDate,
  });
}

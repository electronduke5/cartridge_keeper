import 'package:cartridge_keeper/domain/entity/repair.dart';

import 'cartridge.dart';

class Repair extends RepairEntity {
  Repair({
    super.id,
    super.startDate,
    super.endDate,
    required super.cartridge,
  });

  Map<String, dynamic> toMap() => {
        'start_date': startDate,
        'end_date': endDate,
        'cartridge_id': cartridge.id,
      };

  factory Repair.fromMap(Map<String, dynamic> json) => Repair(
        id: json['id'] as int,
        startDate: json['start_date'],
        endDate: json['end_date'],
        cartridge: Cartridge.fromMap(<String, dynamic>{
          'id': json['cartridge_id'] as int,
          'mark': json['mark']?.toString(),
          'model': json['model'],
          'inventory_number': json['inventory_number'],
        }),
      );
}

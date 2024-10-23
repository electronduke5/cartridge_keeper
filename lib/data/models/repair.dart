import 'package:cartridge_keeper/domain/entity/repair.dart';

class Repair extends RepairEntity {
  Repair({
    super.id,
    required super.startDate,
    super.endDate,
    required super.cartridgeId,
  });

  Map<String, dynamic> toMap() => {
        'start_date': startDate,
        'end_date': endDate,
        'cartridge_id': cartridgeId,
      };

  factory Repair.fromMap(Map<String, dynamic> json) => Repair(
        id: json['id'] as int,
        startDate: json['start_date'] as DateTime,
        endDate: json['end_date'] as DateTime,
        cartridgeId: json['cartridge_id'] as int,
      );
}

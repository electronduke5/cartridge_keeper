import 'package:cartridge_keeper/domain/entity/cartridge.dart';

class Cartridge extends CartridgeEntity {
  Cartridge({
    super.mark,
    required super.model,
    required super.inventoryNumber,
    super.id,
    required super.isInRepair,
    required super.isDeleted,
    required super.isReplaced,
  });

  Map<String, dynamic> toMap() => {
        'mark': mark,
        'model': model,
        'inventory_number': inventoryNumber,
        'is_in_repair': isInRepair ? 1 : 0,
        'is_deleted': isDeleted ? 1 : 0,
        'is_replaced': isReplaced ? 1 : 0,
      };

  factory Cartridge.fromMap(Map<String, dynamic> json) => Cartridge(
        id: json['id'] as int,
        mark: json['mark'],
        model: json['model'],
        inventoryNumber: json['inventory_number'],
        isInRepair: json['is_in_repair'] == 1,
        isDeleted: json['is_deleted'] == 1,
        isReplaced: json['is_replaced'] == 1,
      );
}

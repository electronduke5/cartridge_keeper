import 'package:cartridge_keeper/domain/entity/printer_inventory.dart';

class PrinterInventory extends PrinterInventoryEntity {
  PrinterInventory({
    super.id,
    super.serialNumber,
    required super.inventoryNumber,
    required super.cartridgeId,
    required super.printerId,
  });

  Map<String, dynamic> toMap() => {
    'serial_number': serialNumber,
    'inventory_number': inventoryNumber,
    'cartridge_id': cartridgeId,
    'printer_id': printerId,
  };

  factory PrinterInventory.fromMap(Map<String, dynamic> json) =>
      PrinterInventory(
        id: json['id'] as int,
        serialNumber: json['serial_number'],
        inventoryNumber: json['inventory_number'],
        printerId: json['printer_id'] as int,
        cartridgeId: json['cartridge_id'] as int,
      );
}

class PrinterInventoryEntity {
  late int id;
  final String? serialNumber;
  final String inventoryNumber;
  final int cartridgeId;
  final int printerId;

  PrinterInventoryEntity({
    this.id = 0,
    this.serialNumber,
    required this.inventoryNumber,
    required this.cartridgeId,
    required this.printerId,
  });
}
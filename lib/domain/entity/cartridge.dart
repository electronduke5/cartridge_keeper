class CartridgeEntity {
  late int id;
  final String? mark;
  final String model;
  final String? inventoryNumber;
  final bool isInRepair;
  final bool isInDeleted;

  CartridgeEntity({
    this.id = 0,
    this.mark,
    required this.model,
    this.inventoryNumber,
    required this.isInRepair,
    required this.isInDeleted,
  });
}

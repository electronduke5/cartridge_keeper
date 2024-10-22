class CartridgeEntity {
  late int id;
  final String? mark;
  final String model;
  final String? inventoryNumber;

  CartridgeEntity({
    this.id = 0,
    this.mark,
    required this.model,
    this.inventoryNumber,
  });
}

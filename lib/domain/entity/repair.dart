class RepairEntity {
  late int id;
  final DateTime startDate;
  final DateTime? endDate;
  final int cartridgeId;

  RepairEntity({
    this.id = 0,
    required this.startDate,
    this.endDate,
    required this.cartridgeId,
  });
}

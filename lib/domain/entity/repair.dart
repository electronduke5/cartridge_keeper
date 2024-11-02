import '../../data/models/cartridge.dart';

class RepairEntity {
  late int id;
  final String startDate;
  final String? endDate;
  final Cartridge cartridge;

  RepairEntity({
    this.id = 0,
    required this.startDate,
    this.endDate,
    required this.cartridge,
  });
}

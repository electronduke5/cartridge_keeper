import 'package:cartridge_keeper/domain/entity/cartridge.dart';

class Cartridge extends CartridgeEntity {
  Cartridge({
    super.mark,
    required super.model,
    required super.inventoryNumber,
    super.id,
  });

  Map<String, dynamic> toMap() => {
        'mark': mark,
        'model': model,
        'inventory_number': inventoryNumber,
      };

  factory Cartridge.fromMap(Map<String, dynamic> json) {
    print('cartridge JSON = $json');
    return Cartridge(
      id: json['id'] as int,
      mark: json['mark'],
      model: json['model'],
      inventoryNumber: json['inventory_number'],
    );
  }
}

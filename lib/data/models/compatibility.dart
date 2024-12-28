import 'package:cartridge_keeper/domain/entity/compatibility.dart';

class Compatibility extends CompatibilityEntity {
  Compatibility({required super.printerId, required super.cartridgeModel});

  Map<String, dynamic> toMap() => {
        'printer_id': printerId,
        'cartridge_model': cartridgeModel,
      };

  factory Compatibility.fromMap(Map<String, dynamic> json) => Compatibility(
        printerId: json['printer_id'] as int,
        cartridgeModel: json['cartridge_model'] as String,
      );
}

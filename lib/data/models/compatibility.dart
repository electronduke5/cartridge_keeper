import 'package:cartridge_keeper/domain/entity/compatibility.dart';

class Compatibility extends CompatibilityEntity {
  Compatibility({required super.printerId, required super.cartridgeId});

  Map<String, dynamic> toMap() => {
        'printer_id': printerId,
        'cartridge_id': cartridgeId,
      };

  factory Compatibility.fromMap(Map<String, dynamic> json) => Compatibility(
        printerId: json['printer_id'] as int,
        cartridgeId: json['cartridge_id'] as int,
      );
}

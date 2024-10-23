import 'package:cartridge_keeper/domain/entity/printer.dart';

class Printer extends PrinterEntity {
  Printer({
    super.id,
    required super.mark,
    required super.model,
  });

  Map<String, dynamic> toMap() => {'mark': mark, 'model': model};

  factory Printer.fromMap(Map<String, dynamic> json) => Printer(
        id: json['id'] as int,
        mark: json['mark'],
        model: json['model'],
      );
}

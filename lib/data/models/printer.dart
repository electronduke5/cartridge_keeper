import 'package:cartridge_keeper/domain/entity/printer.dart';

class Printer extends PrinterEntity {
  Printer({required super.mark, required super.model});

  Map<String, dynamic> toMap() => {'mark': mark, 'model': model};

  factory Printer.fromMap(Map<String, dynamic> json) =>
      Printer(mark: json['mark'], model: json['model']);
}

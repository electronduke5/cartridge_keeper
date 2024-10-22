import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/printer.dart';
import 'package:cartridge_keeper/domain/repositories/printer_repository.dart';

class PrinterRepositoryImpl
    with DatabaseService<Printer>
    implements PrinterRepository {
  @override
  Future<Printer> createPrinter(String mark, String model) {
    return createObject(
      fromMap: (Map<String, dynamic> json) => Printer.fromMap(json),
      table: DatabaseRequest.tablePrinters,
      data: Printer(model: model, mark: mark).toMap(),
    );
  }

  @override
  Future<void> deletePrinter(int id) {
    // TODO: implement deletePrinter
    throw UnimplementedError();
  }

  @override
  Future<List<Printer>> getAllPrinters() {
    return getAll(
      fromMap: (Map<String, dynamic> json) => Printer.fromMap(json),
      table: DatabaseRequest.tablePrinters,
    );
  }

  @override
  Future<Printer?> updatePrinter(int id, String mark, String model) {
    return updateObject(
      fromMap: (Map<String, dynamic> json) => Printer.fromMap(json),
      table: DatabaseRequest.tablePrinters,
      data: Printer(mark: mark, model: model).toMap(),
      id: id,
    );
  }
}

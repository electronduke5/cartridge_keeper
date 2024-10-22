import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/printer_inventory.dart';

import '../../domain/repositories/printer_inventory_repository.dart';

class PrinterInventoryRepositoryImpl
    with DatabaseService<PrinterInventory>
    implements PrinterInventoryRepository {
  @override
  Future<PrinterInventory> createPrinterInventory(
      {String? serialNumber,
      required String inventoryNumber,
      required int cartridgeId,
      required int printerId}) {
    return createObject(
      fromMap: (Map<String, dynamic> json) => PrinterInventory.fromMap(json),
      table: DatabaseRequest.tablePrinterInventory,
      data: PrinterInventory(
        serialNumber: serialNumber,
        inventoryNumber: inventoryNumber,
        cartridgeId: cartridgeId,
        printerId: printerId,
      ).toMap(),
    );
  }

  @override
  Future<void> deletePrinterInventory(int id) {
    // TODO: implement deletePrinterInventory
    throw UnimplementedError();
  }

  @override
  Future<List<PrinterInventory>> getAllPrinterInventory() {
    // TODO: implement getAllPrinterInventory
    throw UnimplementedError();
  }

  @override
  Future<PrinterInventory?> updatePrinterInventory(
      {required int id,
      String? serialNumber,
      required String inventoryNumber,
      required int cartridgeId,
      required int printerId}) {
    return updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => PrinterInventory.fromMap(json),
      table: DatabaseRequest.tablePrinterInventory,
      data: PrinterInventory(
        serialNumber: serialNumber,
        inventoryNumber: inventoryNumber,
        cartridgeId: cartridgeId,
        printerId: printerId,
      ).toMap(),
    );
  }
}

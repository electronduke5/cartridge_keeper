import 'package:cartridge_keeper/data/models/printer_inventory.dart';

abstract class PrinterInventoryRepository {
  Future<List<PrinterInventory>> getAllPrinterInventory();

  Future<PrinterInventory> createPrinterInventory({
    String? serialNumber,
    required String inventoryNumber,
    required int cartridgeId,
    required int printerId,
  });

  Future<PrinterInventory?> updatePrinterInventory({
    required int id,
    String? serialNumber,
    required String inventoryNumber,
    required int cartridgeId,
    required int printerId,
  });

  Future<void> deletePrinterInventory(int id);
}

import 'package:cartridge_keeper/data/models/printer_inventory.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

abstract class PrinterInventoryRepository {
  Future<Either<Failure, List<PrinterInventory>>> getAllPrinterInventory();

  Future<Either<Failure, PrinterInventory>> createPrinterInventory({
    String? serialNumber,
    required String inventoryNumber,
    required int cartridgeId,
    required int printerId,
  });

  Future<Either<Failure, PrinterInventory>> updatePrinterInventory({
    required int id,
    String? serialNumber,
    required String inventoryNumber,
    required int cartridgeId,
    required int printerId,
  });

  Future<void> deletePrinterInventory(int id);
}

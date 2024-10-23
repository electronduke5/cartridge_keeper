import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/printer_inventory.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../domain/repositories/printer_inventory_repository.dart';

class PrinterInventoryRepositoryImpl
    with DatabaseService<PrinterInventory>
    implements PrinterInventoryRepository {
  @override
  Future<Either<Failure, PrinterInventory>> createPrinterInventory(
      {String? serialNumber,
      required String inventoryNumber,
      required int cartridgeId,
      required int printerId}) async {
    return await createObject(
      fromMap: (Map<String, dynamic> json) => PrinterInventory.fromMap(json),
      table: DatabaseRequest.tablePrinterInventory,
      data: PrinterInventory(
        serialNumber: serialNumber,
        inventoryNumber: inventoryNumber,
        cartridgeId: cartridgeId,
        printerId: printerId,
      ).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<void> deletePrinterInventory(int id) {
    // TODO: implement deletePrinterInventory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<PrinterInventory>>>
      getAllPrinterInventory() async {
    return await getAll(
      fromMap: (Map<String, dynamic> json) => PrinterInventory.fromMap(json),
      table: DatabaseRequest.tablePrinterInventory,
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, PrinterInventory>> updatePrinterInventory(
      {required int id,
      String? serialNumber,
      required String inventoryNumber,
      required int cartridgeId,
      required int printerId}) async {
    return await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => PrinterInventory.fromMap(json),
      table: DatabaseRequest.tablePrinterInventory,
      data: PrinterInventory(
        serialNumber: serialNumber,
        inventoryNumber: inventoryNumber,
        cartridgeId: cartridgeId,
        printerId: printerId,
      ).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }
}

import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';

import '../../domain/repositories/cartridge_repository.dart';
import '../models/cartridge.dart';

class CartridgeRepositoryImpl
    with DatabaseService<Cartridge>
    implements CartridgeRepository {
  @override
  Future<Cartridge> createCartridge(
      {String? mark, required String model, String? inventoryNumber}) {
    return createObject(
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data:
          Cartridge(mark: mark, model: model, inventoryNumber: inventoryNumber)
              .toMap(),
    );
  }

  @override
  Future<void> deleteCartridge(int id) {
    // TODO: implement deleteCartridge
    throw UnimplementedError();
  }

  @override
  Future<List<Cartridge>> getAllCartridges() {
    return getAll(
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
    );
  }

  @override
  Future<Cartridge?> updatePrinter(
      {required int id,
      String? mark,
      required String model,
      String? inventoryNumber}) {
    return updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data:
          Cartridge(mark: mark, model: model, inventoryNumber: inventoryNumber)
              .toMap(),
    );
  }
}

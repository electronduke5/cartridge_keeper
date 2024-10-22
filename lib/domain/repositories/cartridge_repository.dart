import '../../data/models/cartridge.dart';

abstract class CartridgeRepository {
  Future<List<Cartridge>> getAllCartridges();

  Future<Cartridge> createCartridge({
    String mark,
    required String model,
    String inventoryNumber,
  });

  ///Списание в утиль
  Future<void> deleteCartridge(int id);

  Future<Cartridge?> updatePrinter({
    required int id,
    String? mark,
    required String model,
    String? inventoryNumber,
  });
}

import 'package:cartridge_keeper/common/failure.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/cartridge.dart';

abstract class CartridgeRepository {
  Future<Either<Failure, List<Cartridge>>> getAllCartridges();

  Future<Either<Failure, Cartridge>> createCartridge({
    String mark,
    required String model,
    String inventoryNumber,
  });

  ///Списание в утиль
  Future<void> deleteCartridge(int id);

  Future<Either<Failure, Cartridge>> updatePrinter({
    required int id,
    String? mark,
    required String model,
    String? inventoryNumber,
  });
}

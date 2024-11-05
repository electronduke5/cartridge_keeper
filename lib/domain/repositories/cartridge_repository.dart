import 'package:cartridge_keeper/common/failure.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/cartridge.dart';

abstract class CartridgeRepository {
  Future<Either<Failure, List<Cartridge>>> getAllCartridges();

  Future<Either<Failure, Cartridge?>> getCartridgeById(int id);

  // Future<Either<Failure, Cartridge?>> getCartridgeByColumn(String column, dynamic columnValue);
  Future<Either<Failure, List<Cartridge>>> searchCartridges(String searchValue);

  Future<Either<Failure, Cartridge>> sendToRepair(int id);
  Future<Either<Failure, Cartridge>> returnFromRepair(int id);


  Future<Either<Failure, Cartridge>> createCartridge({
    String? mark,
    required String model,
    String? inventoryNumber,
  });

  ///Списание в утиль
  Future<Either<Failure, Cartridge>> deleteCartridge(int id);

  Future<Either<Failure, Cartridge>> updatePrinter({
    required int id,
    String? mark,
    required String model,
    String? inventoryNumber,
    required bool isInRepair,
    required bool isDeleted,
  });
}

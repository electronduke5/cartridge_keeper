import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../domain/repositories/cartridge_repository.dart';
import '../models/cartridge.dart';

class CartridgeRepositoryImpl
    with DatabaseService<Cartridge>
    implements CartridgeRepository {
  @override
  Future<Either<Failure, Cartridge>> createCartridge(
      {String? mark, required String model, String? inventoryNumber}) async {
    final createdCartridge = await createObject(
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data:
          Cartridge(mark: mark, model: model, inventoryNumber: inventoryNumber)
              .toMap(),
    );
    return createdCartridge.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<void> deleteCartridge(int id) {
    // TODO: implement deleteCartridge
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Cartridge>>> getAllCartridges() async {
    final cartridges = await getAll(
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
    );
    return cartridges.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, Cartridge>> updatePrinter(
      {required int id,
      String? mark,
      required String model,
      String? inventoryNumber}) async {
    return await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data:
          Cartridge(mark: mark, model: model, inventoryNumber: inventoryNumber)
              .toMap(),
    ).then(
      (value) => value.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }
}

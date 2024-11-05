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
      data: Cartridge(
        mark: mark,
        model: model,
        inventoryNumber: inventoryNumber,
        isInRepair: false,
        isInDeleted: false,
      ).toMap(),
    );
    return createdCartridge.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, Cartridge>> deleteCartridge(int id) async {
    final resultSoftDelete = await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data: {'is_deleted': 1},
    );

    return resultSoftDelete.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Cartridge>>> getAllCartridges() async {
    final cartridges = await getAll(
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      whereColumn: 'is_deleted',
      whereArg: 0,
    );
    return cartridges.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, Cartridge>> updatePrinter({
    required int id,
    String? mark,
    required String model,
    String? inventoryNumber,
    required bool isInRepair,
    required bool isDeleted,
  }) async {
    return await updateObject(
      id: id,
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data: Cartridge(
        mark: mark,
        model: model,
        inventoryNumber: inventoryNumber,
        isInRepair: isInRepair,
        isInDeleted: isDeleted,
      ).toMap(),
    ).then(
      (value) => value.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, Cartridge?>> getCartridgeById(int id) async {
    return await getObjectById(
      id: id,
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
    ).then(
      (value) => value.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Cartridge>>> searchCartridges(
      String searchValue) async {
    final cartridges = await search(
      searchingColumn: 'inventory_number',
      searchingValue: searchValue,
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
    );
    print(
        'searchCartridges: ${cartridges.fold((l) => l, (r) => r.map((element) => element.toMap()))}');
    return cartridges.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, Cartridge>> returnFromRepair(int id) async {
    final cartridge = await updateObject(
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data: {'is_in_repair': 0},
      id: id,
    );
    print('returnFromRepair: ${cartridge.fold((l) => l, (r) => r.toMap())}');
    return cartridge.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, Cartridge>> sendToRepair(int id) async {
    final cartridge = await updateObject(
      fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
      table: DatabaseRequest.tableCartridges,
      data: {'is_in_repair': 1},
      id: id,
    );
    print('sendToRepair: ${cartridge.fold((l) => l, (r) => r.toMap())}');
    return cartridge.fold((l) => Left(l), (r) => Right(r));
  }

// @override
// Future<Either<Failure, Cartridge?>> getCartridgeByColumn( String columnName, dynamic columnValue) async {
//   return await getObjectByColumn(
//     columnName: columnName,
//     columnValue: columnValue,
//     table: DatabaseRequest.tableCartridges,
//     fromMap: (Map<String, dynamic> json) => Cartridge.fromMap(json),
//   ).then((value) => value.fold(
//         (l) => Left(l),
//         (r) => Right(r),
//       ));
// }
}

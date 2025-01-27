import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/printer.dart';
import 'package:cartridge_keeper/domain/repositories/printer_repository.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

class PrinterRepositoryImpl
    with DatabaseService<Printer>
    implements PrinterRepository {
  @override
  Future<Either<Failure, Printer>> createPrinter(
      String mark, String model) async {
    return await createObject(
      fromMap: (Map<String, dynamic> json) => Printer.fromMap(json),
      table: DatabaseRequest.tablePrinters,
      data: Printer(model: model, mark: mark).toMap(),
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, String>> deletePrinter(int id) {
    final result = deleteObject(
      table: DatabaseRequest.tablePrinters,
      id: id,
    );
    return result.then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Printer>>> getAllPrinters() async {
    return await getAll(
      fromMap: (Map<String, dynamic> json) => Printer.fromMap(json),
      table: DatabaseRequest.tablePrinters,
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }

  @override
  Future<Either<Failure, Printer>> updatePrinter(
      int id, String mark, String model) async {
    return await updateObject(
      fromMap: (Map<String, dynamic> json) => Printer.fromMap(json),
      table: DatabaseRequest.tablePrinters,
      data: Printer(mark: mark, model: model).toMap(),
      id: id,
    ).then(
      (result) => result.fold(
        (l) => Left(l),
        (r) => Right(r),
      ),
    );
  }
}

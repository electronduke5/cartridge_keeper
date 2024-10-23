import 'package:cartridge_keeper/common/failure.dart';
import 'package:cartridge_keeper/core/db/database_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

mixin DatabaseService<T extends Object> {
  Future<Either<Failure, List<T>>> getAll(
      {required T Function(Map<String, dynamic>) fromMap,
        required String table}) async {
    try {
      Database db = DatabaseHelper.instance.db;
      final response = await db.query(table);

      List<T> listT = response.isNotEmpty
          ? response.map((element) => fromMap(element)).toList()
          : [];

      return Right(listT);
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString()));
    }
  }

  Future<Either<Failure, T>> getById({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required int id,
  }) async {
    try {
      Database db = DatabaseHelper.instance.db;
      final response = await db.query(table, where: 'id = ?', whereArgs: [id]);
      return Right(fromMap(response.first));
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString()));
    }
  }

  Future<Either<Failure, T>> createObject({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      Database db = DatabaseHelper.instance.db;
      int createdId = await db.insert(table, data);
      final response = await getById(
        fromMap: fromMap,
        table: table,
        id: createdId,
      );
      return response.fold(
            (l) => Left(l),
            (r) => Right(r),
      );
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString()));
    }
  }

  Future<Either<Failure, T>> updateObject({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required Map<String, dynamic> data,
    required int id,
  }) async {
    try {
      Database db = DatabaseHelper.instance.db;
      int updatedId =
      await db.update(table, data, where: 'id = ?', whereArgs: [id]);
      final response = await getById(
        fromMap: fromMap,
        table: table,
        id: updatedId,
      );
      return response.fold(
            (l) => Left(l),
            (r) => Right(r),
      );
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString()));
    }
  }
}

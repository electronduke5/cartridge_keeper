import 'package:cartridge_keeper/common/failure.dart';
import 'package:cartridge_keeper/core/db/database_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

mixin DatabaseService<T extends Object> {
  Future<Either<Failure, List<T>>> getAll({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    String? searchingColumn,
    String? searchingValue,
  }) async {
    try {
      final response = await DatabaseHelper.instance.queryAllRows(table, searchingColumn, searchingValue);

      //print('res!!!!!!:   $response');
      List<T> listT = response.map((element) => fromMap(element)).toList();

      return Right(listT);
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString(), error.getResultCode()));
    }
  }

  Future<Either<Failure, T>> getObjectById({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required int id,
  }) async {
    try {
      final response = await DatabaseHelper.instance.queryById(id, table);
      return Right(fromMap(response));
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString(), error.getResultCode()));
    }
  }

  // Future<Either<Failure, T>> getObjectByColumn({
  //   required T Function(Map<String, dynamic>) fromMap,
  //   required String table,
  //   required String columnName,
  //   required dynamic columnValue,
  // }) async {
  //   try {
  //     final response = await DatabaseHelper.instance.queryByColumn(table, columnName, columnValue);
  //     return Right(fromMap(response));
  //   } on DatabaseException catch (error) {
  //     return Left(Failure(error, error.toString(), error.getResultCode()));
  //   }
  // }

  Future<Either<Failure, T>> createObject({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await DatabaseHelper.instance.insert(data, table);
      return Right(fromMap(response));
    } on DatabaseException catch (error) {
      //print('DB UNIQUE ERROR: ${error}');
      //print('ERROR Result code: ${error.getResultCode()}');
      return Left(Failure(error, error.toString(), error.getResultCode()));
    }
  }

  Future<Either<Failure, T>> updateObject({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required Map<String, dynamic> data,
    required int id,
  }) async {
    try {
      final response = await DatabaseHelper.instance.update(id, data, table);
      return Right(fromMap(response));
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString(), error.getResultCode()));
    }
  }

  Future<Either<Failure, String>> deleteObject({
    required String table,
    required int id,
  }) async {
    try {
      final resultString = await DatabaseHelper.instance.delete(id, table).then(
          (value) =>
              value == 1 ? 'Успешно удалена 1 запись' : 'Ошибка удаления');
      return Right(resultString);
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString(), error.getResultCode()));
    }
  }
}

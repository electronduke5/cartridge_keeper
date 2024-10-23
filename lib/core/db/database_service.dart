import 'package:cartridge_keeper/common/failure.dart';
import 'package:cartridge_keeper/core/db/database_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

mixin DatabaseService<T extends Object> {
  Future<Either<Failure, List<T>>> getAll(
      {required T Function(Map<String, dynamic>) fromMap,
      required String table}) async {
    try {
      final response = await DatabaseHelper.instance.queryAllRows(table);

      print('res!!!!!!:   $response');
      List<T> listT =  response.map((element) => fromMap(element)).toList();

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
      final response = await DatabaseHelper.instance.queryById(id, table);
      return Right(fromMap(response));
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
      final response = await DatabaseHelper.instance.insert(data, table);
      return Right(fromMap(response));
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
      final response = await DatabaseHelper.instance.update(id, data, table);
      return Right(fromMap(response));
    } on DatabaseException catch (error) {
      return Left(Failure(error, error.toString()));
    }
  }
}

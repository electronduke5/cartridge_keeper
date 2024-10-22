import 'package:cartridge_keeper/core/db/database_helper.dart';
import 'package:sqflite/sqflite.dart';

mixin DatabaseService<T extends Object> {
  Future<List<T>> getAll(
      {required T Function(Map<String, dynamic>) fromMap,
      required String table}) async {
    Database db = DatabaseHelper.instance.db;
    final response = await db.query(table);
    List<T> listT = response.isNotEmpty
        ? response.map((element) => fromMap(element)).toList()
        : [];
    return listT;
  }

  Future<T?> getById({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required int id,
  }) async {
    Database db = DatabaseHelper.instance.db;
    final response = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return response.isNotEmpty ? fromMap(response.first) : null;
  }

  Future<T> createObject({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required Map<String, dynamic> data,
  }) async {
    Database db = DatabaseHelper.instance.db;
    int createdId = await db.insert(table, data);
    final response =
        await getById(fromMap: fromMap, table: table, id: createdId);
    return response!;
  }

  Future<T> updateObject({
    required T Function(Map<String, dynamic>) fromMap,
    required String table,
    required Map<String, dynamic> data,
    required int id,
  }) async {
    Database db = DatabaseHelper.instance.db;
    int updatedId =
        await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    final response =
        await getById(fromMap: fromMap, table: table, id: updatedId);
    return response!;
  }
}

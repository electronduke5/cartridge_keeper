import 'dart:io';

import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/data/models/department.dart';
import 'package:cartridge_keeper/data/models/printer.dart';
import 'package:cartridge_keeper/domain/entity/department.dart';
import 'package:cartridge_keeper/domain/entity/printer.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  factory DatabaseHelper() => instance;

  DatabaseHelper._instance();

  final int _version = 1;
  static String? _pathDB;
  static Directory? _appDocumentDirectory;
  static Database? _database;

  Future<Database> get database async => _database ??= await _init();

  Future<Database> _init() async {
    _appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    _pathDB = path.join(_appDocumentDirectory!.path, DatabaseRequest.dbName);

    sqfliteFfiInit();
    return _database = await databaseFactoryFfi.openDatabase(
      _pathDB!,
      options: OpenDatabaseOptions(
        version: _version,
        onCreate: (db, version) => onCreateTable(db),
        onUpgrade: (db, oldVersion, newVersion) => onUpdateTable(db),
      ),
    );
  }

  Future<Map<String, dynamic>> insert(
      Map<String, dynamic> data, String table) async {
    Database db = await instance.database;
    int createdId = await db.insert(table, data);
    return await queryById(createdId, table);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> searchQuery(
      String table, String searchingColumn, String searchingValue) async {
    Database db = await instance.database;
    return await db.query(table,
        where: '$searchingColumn LIKE \'%$searchingValue%\'');
  }

  Future<Map<String, dynamic>> update(
      int id, Map<String, dynamic> data, String table) async {
    Database db = await instance.database;
    await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    return await queryById(id, table);
  }

  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> queryById(int id, String table) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.first;
  }

  // Future<Map<String,dynamic>> queryByColumn(String table, String columnName, dynamic columnValue) async {
  //   Database db = await instance.database;
  //   List<Map<String, dynamic>> result = await db.query(table, where: '$columnName = ?', whereArgs: [columnValue]);
  //   return result.first;
  // }

  Future<void> onInitTable(Database db) async {
    try {
      for (var department in DepartmentEnum.values) {
        db.insert(DatabaseRequest.tableDepartments,
            Department(name: department.name).toMap());
      }
      for (var printer in PrinterEnum.values) {
        db.insert(
          DatabaseRequest.tablePrinters,
          Printer(mark: printer.mark, model: printer.model).toMap(),
        );
      }
    } on DatabaseException catch (error) {
      print(error.result);
    }
  }

  Future<void> onUpdateTable(Database db) async {
    var tables = await db.query('Select name from sqlite_master');
    for (var table in DatabaseRequest.tablesList.reversed) {
      if (tables.where((element) => element['name'] == table).isNotEmpty) {
        await db.execute(DatabaseRequest.deleteTable(table));
      }
    }
  }

  Future<void> onDropDatabase() async {
    await instance.database.then((db) => db.close());

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactoryFfi.deleteDatabase(_pathDB!);
    } else {
      deleteDatabase(_pathDB!);
    }
  }

  Future<void> onCreateTable(Database db) async {
    for (var tableCreateString in DatabaseRequest.tableCreateList) {
      await db.execute(tableCreateString);
    }
    await onInitTable(db);
  }
}

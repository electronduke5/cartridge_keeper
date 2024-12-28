import 'dart:io';

import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/data/models/department.dart';
import 'package:cartridge_keeper/data/models/printer.dart';
import 'package:cartridge_keeper/domain/entity/department.dart';
import 'package:cartridge_keeper/domain/entity/printer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
        onConfigure: _onConfigure,
        onCreate: (db, version) => onCreateTable(db),
        onUpgrade: (db, oldVersion, newVersion) => onUpdateTable(db),
      ),
    );
  }

  static String getPathForSaveDbCopy() =>
      path.join(_appDocumentDirectory!.path, 'Cartridge Keeper DB dumps');

  Future<Map<String, dynamic>> insert(
      Map<String, dynamic> data, String table) async {
    Database db = await instance.database;
    int createdId = await db.insert(table, data);
    return await queryById(createdId, table);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(
    String table, {
    Map<String, dynamic>? whereItems,
  }) async {
    Database db = await instance.database;
    if (whereItems == null || whereItems.isEmpty) {
      return await db.query(table);
    }
    return await db.query(table,
        where: whereItems.keys.map((key) => '$key = ?').join(' AND '),
        whereArgs: whereItems.values.toList());
  }

  Future<List<Map<String, dynamic>>> queryAllRowsWithReference({
    required String table,
    required List<String> referenceTables,
    required List<String> referenceColumns,
    String? whereColumn,
    String? whereArg,
  }) async {
    Database db = await instance.database;
    if (whereColumn != null && whereArg?.isEmpty == false) {}
    return await db.rawQuery(
      DatabaseSelectRequests.selectAllWithReference(
        table: table,
        referenceTables: referenceTables,
        referenceColumns: referenceColumns,
        whereColumn: whereColumn,
        whereArg: whereArg,
      ),
    );
  }

  Future<Map<String, dynamic>> queryByIdWithReference({
    required int id,
    required String table,
    required String referenceTable,
    required String referenceColumn,
  }) async {
    Database db = await instance.database;
    final result = await db.rawQuery(DatabaseSelectRequests.selectWithReference(
      table,
      referenceTable,
      referenceColumn,
      id,
    ));
    return result.first;
  }

  Future<List<Map<String, dynamic>>> searchQuery(
    String table,
    List<String> searchingColumns,
    String searchingValue, {
    String? whereColumn,
    String? whereArg,
  }) async {
    Database db = await instance.database;

    if (whereColumn != null && whereArg?.isEmpty == false) {
      return await db.query(
        table,
        where:
            '$whereColumn = $whereArg AND (${searchingColumns.map((column) => '$column LIKE \'%$searchingValue%\'').join(' OR ')})',
      );
    }
    return await db.query(
      table,
      where: searchingColumns
          .map((column) => '$column LIKE \'%$searchingValue%\'')
          .join(' AND '),
    );
  }

  Future<List<Map<String, dynamic>>> searchQueryWithReference({
    required String table,
    required List<String> searchingColumns,
    required String searchingValue,
    required List<String> referenceTables,
    required List<String> referenceColumns,
    String? whereColumn,
    String? whereArg,
  }) async {
    Database db = await instance.database;

    return await db.rawQuery(
      DatabaseSelectRequests.searchWithReference(
        table: table,
        referenceTables: referenceTables,
        referenceColumns: referenceColumns,
        searchingColumns: searchingColumns,
        searchingValue: searchingValue,
        whereColumn: whereColumn,
        whereArg: whereArg,
      ),
    );
  }

  Future<Map<String, dynamic>> update(
      int id, Map<String, dynamic> data, String table) async {
    Database db = await instance.database;
    await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    return await queryById(id, table);
  }

  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    int resDelete = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return resDelete;
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
    } on DatabaseException {}
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
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

  Future<File> dbToCopy() async {
    return File(_pathDB!);
  }
}

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
  late final String _pathDB;
  late final Directory _appDocumentDirectory;
  late final Database database;

  Database get db  => instance.db;

  Future<void> init() async {
    _appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    _pathDB = path.join(_appDocumentDirectory.path, DatabaseRequest.dbName);
    print('Path DB: $_pathDB');

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      database = await databaseFactoryFfi.openDatabase(
        _pathDB,
        options: OpenDatabaseOptions(
          version: _version,
          onCreate: (db, version) => onCreateTable(db),
          onUpgrade: (db, oldVersion, newVersion) => onUpdateTable(db),
        ),
      );
    }
  }

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
    database.close();

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactoryFfi.deleteDatabase(_pathDB);
    } else {
      deleteDatabase(_pathDB);
    }
  }

  Future<void> onCreateTable(Database db) async {
    for (var tableCreateString in DatabaseRequest.tableCreateList) {
      await db.execute(tableCreateString);
    }
    await onInitTable(db);
  }
}

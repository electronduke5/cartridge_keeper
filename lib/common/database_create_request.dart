part 'db_select_requests.dart';

abstract class DatabaseRequest {
  static const String dbName = 'CartridgeKeeper.db';

  /// Названия таблиц
  static const String tableCartridges = 'cartridges';
  static const String tablePrinters = 'printers';
  static const String tablePrinterInventory = 'printer_inventory';
  static const String tableCompatibility = 'compatibility';
  static const String tableRepairs = 'repairs';
  static const String tableDepartments = 'departments';
  static const String tableOffices = 'offices';

  /// Лист с названиями таблиц
  static const List<String> tablesList = [
    tableDepartments,
    tablePrinters,
    tablePrinterInventory,
    tableCartridges,
    tableCompatibility,
    tableRepairs,
    tableOffices,
  ];

  /// Лист с командами по созданию таблиц
  static const List<String> tableCreateList = [
    _createTableDepartments,
    _createTablePrinters,
    _createTableCartridges,
    _createTablePrinterInventory,
    _createTableCompatibility,
    _createTableRepairs,
    _createTableOffices,
    _createUniqueIndexCartridges,
  ];

  static const String _createTableDepartments =
      'CREATE TABLE $tableDepartments ('
      'id integer not NULL primary key,'
      'name text UNIQUE not NULL);';

  static const String _createTablePrinters = 'CREATE TABLE $tablePrinters ('
      'id integer not NULL primary key,'
      'mark text not NULL,'
      'model text not NULL);';

  static const String _createTablePrinterInventory =
      'CREATE TABLE $tablePrinterInventory ('
      'id integer not NULL primary key,'
      'serial_number text unique,'
      'inventory_number text unique not null,'
      'cartridge_id integer not null,'
      'printer_id integer not null,'
      'foreign key (printer_id) REFERENCES $tablePrinters(id),'
      'foreign key (cartridge_id) REFERENCES $tableCartridges(id));';

  static const String _createTableCartridges = 'CREATE TABLE $tableCartridges ('
      'id integer not NULL primary key,'
      'mark text,'
      'model text not NULL,'
      'inventory_number text,'
      'is_deleted integer not null default 0 check(is_deleted IN (0,1)),'
      'is_replaced integer not null default 0 check(is_deleted IN (0,1)),'
      'is_in_repair integer not null default 0 check(is_in_repair IN (0,1)));';

  static const String _createUniqueIndexCartridges =
      'CREATE UNIQUE INDEX unique_cartridge ON $tableCartridges (inventory_number) where is_deleted = 0;';

  static const String _createTableCompatibility =
      'CREATE TABLE $tableCompatibility ('
      'printer_id integer not NULL,'
      'cartridge_model text not NULL,'
      'foreign key (printer_id) REFERENCES $tablePrinters(id));';

  static const String _createTableRepairs = 'CREATE TABLE $tableRepairs ('
      'id integer not NULL primary key,'
      'start_date text not NULL,'
      'end_date text default null,'
      'cartridge_id integer not null,'
      'foreign key (cartridge_id) REFERENCES $tableCartridges(id));';

  static const String _createTableOffices = 'CREATE TABLE $tableOffices ('
      'id integer not NULL primary key,'
      'office_number text ,'
      'replacement_date text not NULL,'
      'department_id integer not NULL,'
      'cartridge_id integer not NULL,'
      'foreign key (department_id) REFERENCES $tableDepartments(id),'
      'foreign key (cartridge_id) REFERENCES $tableCartridges(id));';

  /// Строка для удаления таблицы
  static String deleteTable(String table) => 'DROP TABLE $table';
}

part of 'database_create_request.dart';

class DatabaseSelectRequests {
  static String selectAll(String table) => 'SELECT * FROM $table;';

  static String selectById(String table, int id) =>
      'SELECT * FROM $table where $table.id = $id;';
}

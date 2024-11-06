part of 'database_create_request.dart';

class DatabaseSelectRequests {
  static String selectAll(String table) => 'SELECT * FROM $table;';

  static String selectById(String table, int id) =>
      'SELECT * FROM $table where $table.id = $id;';

  static String selectWithReference(String table, String referenceTable,
          String referenceColumn, int tableId) =>
      'SELECT * FROM $referenceTable  join $table on $referenceTable.id = $referenceTable.$referenceColumn where $table.id = $tableId;';

  static String selectAllWithReference(String table,
      List<String> referenceTables, List<String> referenceColumns) {
    final request =
        'SELECT * FROM ${referenceTables.asMap().entries.map((refTable) => '${refTable.value} ')}  join $table on ${referenceTables.asMap().entries.map((refTable) => '${refTable.value}.id = $table.${referenceColumns[refTable.key]}').join(' and ')};';

    return request;
  }

  static String searchWithReference({
    required String table,
    required String searchingColumn,
    required String searchingValue,
    required List<String> referenceTables,
    required List<String> referenceColumns,
    String? whereColumn,
    String? whereArg,
  }) {
    if (whereColumn != null) {
      final request =
          'SELECT * FROM ${referenceTables.asMap().entries.map((refTable) => refTable.value)} join $table on ${referenceTables.asMap().entries.map((refTable) => '${refTable.value}.id = $table.${referenceColumns[refTable.key]}').join(' and ')} where $table.$searchingColumn = $searchingValue and $table.$whereColumn = $whereArg;';
      return request;
    }
    final request =
        'SELECT * FROM $table join ${referenceTables.asMap().entries.map((refTable) => '${refTable.value} on ${refTable.value}.id = $table.${referenceColumns[refTable.key]}').join(' join ')} where $table.$searchingColumn = $searchingValue;';
    return request;
  }
}

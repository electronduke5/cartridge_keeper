import 'package:sqflite/sqflite.dart';

class Failure {
  final DatabaseException databaseException;
  final String error;
  final int? errorCode;

  Failure(this.databaseException, this.error, this.errorCode);
}

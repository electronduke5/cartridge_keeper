import 'package:sqflite/sqflite.dart';

class Failure{
  final DatabaseException databaseException;
  final String error;

  Failure(this.databaseException, this.error);
}
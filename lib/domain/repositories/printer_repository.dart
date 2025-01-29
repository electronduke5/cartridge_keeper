import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/models/printer.dart';

abstract class PrinterRepository{
  Future<Either<Failure,List<Printer>>> getAllPrinters();

  Future<Either<Failure, Printer>> createPrinter(String mark, String model);

  Future<Either<Failure,String>> deletePrinter(int id);

  Future<Either<Failure,Printer>> updatePrinter(int id, String mark, String model);

  Future<Either<Failure, List<Printer>>> searchPrinters(String searchingValue);
}
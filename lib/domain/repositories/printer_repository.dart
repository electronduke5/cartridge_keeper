import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/models/printer.dart';

abstract class PrinterRepository{
  Future<Either<Failure,List<Printer>>> getAllPrinters();

  Future<Either<Failure, Printer>> createPrinter(String mark, String model);

  Future<void> deletePrinter(int id);

  Future<Either<Failure,Printer>> updatePrinter(int id, String mark, String model);
}
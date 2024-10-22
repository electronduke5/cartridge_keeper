import '../../data/models/printer.dart';

abstract class PrinterRepository{
  Future<List<Printer>> getAllPrinters();

  Future<Printer> createPrinter(String mark, String model);

  Future<void> deletePrinter(int id);

  Future<Printer?> updatePrinter(int id, String mark, String model);
}
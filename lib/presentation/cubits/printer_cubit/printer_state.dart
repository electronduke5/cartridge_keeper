part of 'printer_cubit.dart';

class PrinterState {
  final ModelState<List<Printer>> getPrintersState;
  final ModelState<Printer> createPrinterState;
  final ModelState<Printer> updatePrinterState;
  final ModelState<void> deletePrinterState;

  const PrinterState({
    this.getPrintersState = const IdleState(),
    this.createPrinterState = const IdleState(),
    this.updatePrinterState = const IdleState(),
    this.deletePrinterState = const IdleState(),
  });

  PrinterState copyWith({
    ModelState<List<Printer>>? getPrintersState,
    ModelState<Printer>? updatePrinterState,
    ModelState<Printer>? createPrinterState,
    ModelState<void>? deletePrinterState,
  }) =>
      PrinterState(
        getPrintersState: getPrintersState ?? this.getPrintersState,
        createPrinterState: createPrinterState ?? this.createPrinterState,
        updatePrinterState: updatePrinterState ?? this.updatePrinterState,
        deletePrinterState: deletePrinterState ?? this.deletePrinterState,
      );
}

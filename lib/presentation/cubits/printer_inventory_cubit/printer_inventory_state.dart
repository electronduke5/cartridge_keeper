part of 'printer_inventory_cubit.dart';

class PrinterInventoryState {
  final ModelState<List<PrinterInventory>> getPrinterInventoryState;
  final ModelState<PrinterInventory> createPrinterInventoryState;
  final ModelState<PrinterInventory> updatePrinterInventoryState;

  const PrinterInventoryState({
    this.getPrinterInventoryState = const IdleState(),
    this.createPrinterInventoryState = const IdleState(),
    this.updatePrinterInventoryState = const IdleState(),
  });

  PrinterInventoryState copyWith({
    ModelState<List<PrinterInventory>>? getPrinterInventoryState,
    ModelState<PrinterInventory>? createPrinterInventoryState,
    ModelState<PrinterInventory>? updatePrinterInventoryState,
  }) =>
      PrinterInventoryState(
        getPrinterInventoryState:
            getPrinterInventoryState ?? this.getPrinterInventoryState,
        createPrinterInventoryState:
            createPrinterInventoryState ?? this.createPrinterInventoryState,
        updatePrinterInventoryState:
            updatePrinterInventoryState ?? this.updatePrinterInventoryState,
      );
}

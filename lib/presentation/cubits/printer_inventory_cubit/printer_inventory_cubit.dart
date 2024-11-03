
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/printer_inventory.dart';
import '../../di/app_module.dart';
import '../model_state.dart';

part 'printer_inventory_state.dart';

class PrinterInventoryCubit extends Cubit<PrinterInventoryState> {
  PrinterInventoryCubit() : super(const PrinterInventoryState());

  final _repository = AppModule.getPrinterInventoryRepository();

  Future<void> loadAllPrinterInventory() async {
    emit(state.copyWith(getPrinterInventoryState: ModelState.loading()));

    await _repository.getAllPrinterInventory().then(
      (result) => result.fold(
        (l) => emit(
          state.copyWith(
            getPrinterInventoryState: ModelState.failed(l.error),
          ),
        ),
        (r) => emit(
          state.copyWith(
            getPrinterInventoryState: ModelState.loaded(r),
          ),
        ),
      ),
    );
  }

  Future<void> addPrinterInventory(String inventoryNumber, int cartridgeId, int printerId) async {
    emit(state.copyWith(createPrinterInventoryState: ModelState.loading()));

    await _repository.createPrinterInventory(
      inventoryNumber: inventoryNumber,
      cartridgeId: cartridgeId,
      printerId: printerId,
    ).then(
      (result) => result.fold(
        (l) => emit(
          state.copyWith(
            createPrinterInventoryState: ModelState.failed(l.error),
          ),
        ),
        (r) => emit(
          state.copyWith(
            createPrinterInventoryState: ModelState.loaded(r),
          ),
        ),
      ),
    );
  }

  Future<void> editPrinterInventory(int id, String inventoryNumber, int cartridgeId, int printerId) async {
    emit(state.copyWith(updatePrinterInventoryState: ModelState.loading()));

    await _repository.updatePrinterInventory(
      id: id,
      inventoryNumber: inventoryNumber,
      cartridgeId: cartridgeId,
      printerId: printerId,
    ).then(
      (result) => result.fold(
        (l) => emit(
          state.copyWith(
            updatePrinterInventoryState: ModelState.failed(l.error),
          ),
        ),
        (r) => emit(
          state.copyWith(
            updatePrinterInventoryState: ModelState.loaded(r),
          ),
        ),
      ),
    );
  }

}

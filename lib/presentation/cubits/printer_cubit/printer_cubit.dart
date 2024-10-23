import 'package:bloc/bloc.dart';
import 'package:cartridge_keeper/presentation/di/app_module.dart';
import 'package:meta/meta.dart';

import '../../../data/models/printer.dart';
import '../model_state.dart';

part 'printer_state.dart';

class PrinterCubit extends Cubit<PrinterState> {
  PrinterCubit() : super(const PrinterState());

  final _repository = AppModule.getPrinterRepository();

  Future<void> loadAllPrinters() async {
    emit(state.copyWith(getPrintersState: ModelState.loading()));

    await _repository.getAllPrinters().then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                getPrintersState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                getPrintersState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> addPrinter(String mark, String model) async {
    emit(state.copyWith(createPrinterState: ModelState.loading()));

    await _repository.createPrinter(mark, model).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                createPrinterState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                createPrinterState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> editPrinter(int id, String mark, String model) async {
    emit(state.copyWith(updatePrinterState: ModelState.loading()));

    await _repository.updatePrinter(id, mark, model).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                updatePrinterState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                updatePrinterState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }
}

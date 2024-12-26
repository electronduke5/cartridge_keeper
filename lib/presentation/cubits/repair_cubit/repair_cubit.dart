import 'dart:io';

import 'package:cartridge_keeper/presentation/pages/repairs_pdf_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cartridge.dart';
import '../../../data/models/repair.dart';
import '../../di/app_module.dart';
import '../model_state.dart';

import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:pdf/widgets.dart' as pw;

part 'repair_state.dart';

class RepairCubit extends Cubit<RepairState> {
  RepairCubit() : super(const RepairState());

  final _repository = AppModule.getRepairRepository();

  Future<void> creatingPDF({
    required List<Repair> list,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(await RepairsPdf.repairsPage(list, startDate, endDate));
    String? outputFile = await FilePicker.platform.saveFile(
      lockParentWindow: true,
      dialogTitle: 'Выберите папку для сохранения',
      fileName:
          'Отчёт по ремонтам картриджей (${startDate.toLocalFormat} - ${endDate.toLocalFormat}).pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    try {
      File file = File(outputFile!);
      await file.writeAsBytes(await pdf.save());
    } catch (e) {}
  }

  Future<void> changedCartridge(Cartridge? cartridge) async {
    emit(state.copyWith(changedCartridge: cartridge));
  }

  Future<void> loadAllRepairs() async {
    emit(state.copyWith(getRepairsState: ModelState.loading()));

    await _repository.getAllRepairs().then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                getRepairsState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                getRepairsState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> loadAllRepairsByCartridge(int cartridgeId) async {
    emit(state.copyWith(getRepairsState: ModelState.loading()));

    await _repository.getAllRepairsByCartridge(cartridgeId).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                getRepairsState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                getRepairsState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future deleteRepair(int id) async {
    emit(state.copyWith(deleteRepairState: ModelState.loading()));

    await _repository.deleteRepair(id).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                deleteRepairState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                deleteRepairState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> addRepair(String startDate, Cartridge cartridge) async {
    emit(state.copyWith(createRepairState: ModelState.loading()));
    await _repository
        .createRepair(startDate: startDate, cartridge: cartridge)
        .then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                createRepairState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                createRepairState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> editRepair(
      int id, String startDate, String? endDate, Cartridge cartridge) async {
    emit(state.copyWith(updateRepairState: ModelState.loading()));

    await _repository
        .updateRepair(
            id: id,
            startDate: startDate,
            endDate: endDate,
            cartridge: cartridge)
        .then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                updateRepairState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                updateRepairState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> returnFromRepair(int id, String endDate) async {
    emit(state.copyWith(updateRepairState: ModelState.loading()));

    await _repository.finishRepair(id: id, endDate: endDate).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                updateRepairState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                updateRepairState: ModelState.loaded(null),
              ),
            ),
          ),
        );
  }
}

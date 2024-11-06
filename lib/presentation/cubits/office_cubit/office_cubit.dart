import 'dart:io';

import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:cartridge_keeper/data/models/department.dart';
import 'package:cartridge_keeper/presentation/pages/replacement_pdf_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/office.dart';
import '../../di/app_module.dart';
import '../model_state.dart';

import 'package:pdf/widgets.dart' as pw;

part 'office_state.dart';

class OfficeCubit extends Cubit<OfficeState> {
  OfficeCubit() : super(const OfficeState());

  final _repository = AppModule.getOfficeRepository();

  Future<void> createPDF(List<Office> list) async {
    final pdf = pw.Document();

    pdf.addPage(await ReplacementPdf.replacementPage(list));
    String? outputFile = await FilePicker.platform.saveFile(
      lockParentWindow: true,
      dialogTitle: 'Выберите папку для сохранения',
      fileName: 'Отчёт по заменам картриджей ${DateTime.now().toLocalFormat}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    try {
      File file = File(outputFile!);
      await file.writeAsBytes(await pdf.save());
    } catch (e) {}
  }

  Future<void> filterByDepartment(int id) async {
    emit(state.copyWith(getOfficesState: LoadingState()));

    await _repository.getOfficesByDepartment(id).then(
      (result) => result.fold(
        (l) => emit(state.copyWith(getOfficesState: FailedState(l.error))),
        (r) => emit(state.copyWith(getOfficesState: LoadedState(r))),
      ),
    );
  }

  Future<void> changeCartridge(Cartridge? cartridge) async {
    emit(state.copyWith(changedCartridge: cartridge));
  }

  Future<void> changeDepartment(Department? department) async {
    emit(state.copyWith(changedDepartment: department));
  }

  Future<void> loadAllOffices() async {
    emit(state.copyWith(getOfficesState: ModelState.loading()));

    await _repository.getAllOffices().then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                getOfficesState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                getOfficesState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> addOffice({
    String? officeNumber,
    required String replacementDate,
    required Department department,
    required Cartridge cartridge,
  }) async {
    emit(state.copyWith(createOfficeState: ModelState.loading()));

    await _repository
        .createOffice(
            replacementDate: replacementDate,
            department: department,
            cartridge: cartridge,
            officeNumber: officeNumber!)
        .then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                createOfficeState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                createOfficeState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> deleteOffice(int id) async {
    emit(state.copyWith(deleteOfficeState: ModelState.loading()));

    await _repository.deleteOffice(id).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                deleteOfficeState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                deleteOfficeState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }
}

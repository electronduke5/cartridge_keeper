import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:cartridge_keeper/data/models/department.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/office.dart';
import '../../di/app_module.dart';
import '../model_state.dart';

part 'office_state.dart';

class OfficeCubit extends Cubit<OfficeState> {
  OfficeCubit() : super(const OfficeState());

  final _repository = AppModule.getOfficeRepository();

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
}

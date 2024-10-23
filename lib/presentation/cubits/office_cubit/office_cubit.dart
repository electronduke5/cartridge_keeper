import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/office.dart';
import '../../di/app_module.dart';
import '../model_state.dart';

part 'office_state.dart';

class OfficeCubit extends Cubit<OfficeState> {
  OfficeCubit() : super(const OfficeState());

  final _repository = AppModule.getOfficeRepository();

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
    required int departmentId,
    required int printerId,
  }) async {
    emit(state.copyWith(createOfficeState: ModelState.loading()));

    await _repository
        .createOffice(
            departmentId: departmentId,
            printerId: printerId,
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

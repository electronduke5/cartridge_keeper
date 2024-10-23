import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/repair.dart';
import '../../di/app_module.dart';
import '../model_state.dart';

part 'repair_state.dart';

class RepairCubit extends Cubit<RepairState> {
  RepairCubit() : super(const RepairState());

  final _repository = AppModule.getRepairRepository();

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

  Future<void> addRepair(DateTime startDate, int cartridgeId) async {
    emit(state.copyWith(createRepairState: ModelState.loading()));

    await _repository.createRepair(startDate: startDate, cartridgeId: cartridgeId).then(
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

  Future<void> editRepair(int id, DateTime startDate, DateTime? endDate, int cartridgeId) async {
    emit(state.copyWith(updateRepairState: ModelState.loading()));

    await _repository.updateRepair(id: id, startDate: startDate, endDate: endDate, cartridgeId: cartridgeId).then(
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
}

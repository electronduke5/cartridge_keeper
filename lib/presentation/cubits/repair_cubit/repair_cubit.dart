

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cartridge.dart';
import '../../../data/models/repair.dart';
import '../../di/app_module.dart';
import '../model_state.dart';

part 'repair_state.dart';

class RepairCubit extends Cubit<RepairState> {
  RepairCubit() : super(const RepairState());

  final _repository = AppModule.getRepairRepository();

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

  List<Cartridge> getAvailableCartridges(
      List<Cartridge> allCartridges, List<Repair> allRepairs) {
    final repairCartridgeIds =
        allRepairs.map((repair) => repair.cartridge.id).toSet();
    return allCartridges
        .where((cartridge) => !repairCartridgeIds.contains(cartridge.id))
        .toList();
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
}

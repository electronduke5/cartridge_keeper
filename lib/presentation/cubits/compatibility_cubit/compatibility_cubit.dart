import 'package:cartridge_keeper/data/models/compatibility.dart';
import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/app_module.dart';

part 'compatibility_state.dart';

class CompatibilityCubit extends Cubit<CompatibilityState> {
  CompatibilityCubit() : super(const CompatibilityState());

  final _repository = AppModule.getCompatibilityRepository();

  Future<void> loadAllCompatibilities() async {
    emit(state.copyWith(getCompatibilitiesState: ModelState.loading()));

    await _repository.getAllCompatibility().then(
      (result) => result.fold(
        (l) => emit(
          state.copyWith(
            getCompatibilitiesState: ModelState.failed(l.error),
          ),
        ),
        (r) => emit(
          state.copyWith(
            getCompatibilitiesState: ModelState.loaded(r),
          ),
        ),
      ),
    );
  }

  Future<void> addCompatibility(
      {required int printerId, required String cartridgeModel}) async {
    emit(state.copyWith(createCompatibilityState: ModelState.loading()));

    await _repository
        .createCompatibility(
            printerId: printerId, cartridgeModel: cartridgeModel)
        .then(
          (result) => result.fold(
            (l) => emit(
          state.copyWith(
            createCompatibilityState: ModelState.failed(l.error),
          ),
        ),
        (r) => emit(
          state.copyWith(
            createCompatibilityState: ModelState.loaded(r),
          ),
        ),
      ),
    );
  }

  Future<void> addCompatibilityList(
      {required int printerId, required List<String> cartridgeModels}) async {
    emit(state.copyWith(createCompatibilityState: ModelState.loading()));
    cleanCompatibilities(printerId);
    for (String cartridgeModel in cartridgeModels) {
      await _repository
          .createCompatibility(
              printerId: printerId, cartridgeModel: cartridgeModel)
          .then(
            (result) => result.fold(
              (l) => emit(
                state.copyWith(
                  createCompatibilityState: ModelState.failed(l.error),
                ),
              ),
              (r) => emit(
                state.copyWith(
                  createCompatibilityState: ModelState.loaded(r),
                ),
              ),
            ),
          );
    }
    loadAllCompatibilities();
  }

  Future<void> cleanCompatibilities(int printerId) async {
    emit(state.copyWith(deleteCompatibilityState: ModelState.loading()));

    await _repository.cleanCompatibilitiesByPrinter(printerId).then(
      (result) => result.fold(
        (l) => emit(
          state.copyWith(
            deleteCompatibilityState: ModelState.failed(l.error),
          ),
        ),
        (r) => emit(
          state.copyWith(
            deleteCompatibilityState: ModelState.loaded(r),
          ),
        ),
      ),
    );
  }
}

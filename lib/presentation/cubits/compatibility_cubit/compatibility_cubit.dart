import 'package:bloc/bloc.dart';
import 'package:cartridge_keeper/data/models/compatibility.dart';
import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:meta/meta.dart';

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

  Future<void> addCompatibility(int printerId, int cartridgeId) async {
    emit(state.copyWith(createCompatibilityState: ModelState.loading()));

    await _repository.createCompatibility(printerId: printerId, cartridgeId: cartridgeId).then(
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

}

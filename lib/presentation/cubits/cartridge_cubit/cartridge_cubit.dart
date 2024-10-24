import 'package:bloc/bloc.dart';
import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:cartridge_keeper/presentation/di/app_module.dart';
import 'package:meta/meta.dart';

import '../model_state.dart';

part 'cartridge_state.dart';

class CartridgeCubit extends Cubit<CartridgeState> {
  CartridgeCubit() : super(const CartridgeState());

  final _repository = AppModule.getCartridgeRepository();

  Future<void> loadAllCartridges() async {
    emit(state.copyWith(getCartridgesState: ModelState.loading()));

    await _repository.getAllCartridges().then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                getCartridgesState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                getCartridgesState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> addCartridge(
      {String? mark, required String model, String? inventoryNumber}) async {
    emit(state.copyWith(createCartridgeState: ModelState.loading()));

    await _repository
        .createCartridge(
            mark: mark!, model: model, inventoryNumber: inventoryNumber!)
        .then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                createCartridgeState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                createCartridgeState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> editCartridge(
      {required int id, String? mark, required String model, String? inventoryNumber}) async {
    emit(state.copyWith(updateCartridgeState: ModelState.loading()));

    await _repository
        .updatePrinter(
        id: id, mark: mark, model: model, inventoryNumber: inventoryNumber)
        .then(
          (result) => result.fold(
            (l) => emit(
          state.copyWith(
            updateCartridgeState: ModelState.failed(l.error),
          ),
        ),
            (r) => emit(
          state.copyWith(
            updateCartridgeState: ModelState.loaded(r),
          ),
        ),
      ),
    );
  }
}

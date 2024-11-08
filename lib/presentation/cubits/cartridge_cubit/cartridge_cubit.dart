import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:cartridge_keeper/presentation/di/app_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model_state.dart';

part 'cartridge_state.dart';

class CartridgeCubit extends Cubit<CartridgeState> {
  CartridgeCubit() : super(const CartridgeState());

  final _repository = AppModule.getCartridgeRepository();

  Future<void> changeDeletedCartridgesVisibility({bool? isDeleted}) async {
    emit(state.copyWith(viewIsDeleted: isDeleted ?? !state.viewIsDeleted));
  }

  Future<void> changeRepairedCartridgesVisibility({bool? isRepaired}) async {
    emit(state.copyWith(viewIsRepaired: isRepaired ?? !state.viewIsRepaired));
  }

  Future<void> changeReplacementCartridgesVisibility(
      {bool? isReplacement}) async {
    emit(state.copyWith(
        viewIsReplacement: isReplacement ?? !state.viewIsReplacement));
  }

  Future<void> loadAllCartridges(
      {bool? isDeleted, bool? isReplaced, bool? isRepaired}) async {
    emit(state.copyWith(getCartridgesState: ModelState.loading()));

    await _repository
        .getAllCartridges(
            isDeleted: isDeleted,
            isReplaced: isReplaced,
            isRepaired: isRepaired)
        .then(
          (result) => result.fold(
            (l) => emit(
                state.copyWith(getCartridgesState: ModelState.failed(l.error))),
            (r) => emit(
              state.copyWith(
                getCartridgesState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> loadOnlyAvailableCartridges(
      {bool isIncludingReplacement = false}) async {
    emit(state.copyWith(getCartridgesState: ModelState.loading()));

    final availableCartridges = await _repository.getAllCartridges().then(
          (result) => result.fold(
            (l) => null,
            (r) => r
                .where(
                  (cartridge) => isIncludingReplacement
                      ? cartridge.isInRepair == false &&
                          cartridge.isReplaced == false
                      : cartridge.isInRepair == false,
                )
                .toList(),
          ),
        );
    if (availableCartridges != null) {
      emit(state.copyWith(
          getCartridgesState: ModelState.loaded(availableCartridges)));
    } else {
      emit(state.copyWith(
          getCartridgesState: ModelState.failed('Картриджей нет!')));
    }
  }

  Future<void> addCartridge(
      {String? mark, required String model, String? inventoryNumber}) async {
    emit(state.copyWith(createCartridgeState: ModelState.loading()));

    if (mark == '') {
      mark = null;
    }
    if (inventoryNumber == '') {
      inventoryNumber = null;
    }
    await _repository
        .createCartridge(
            mark: mark, model: model, inventoryNumber: inventoryNumber)
        .then(
          (result) => result.fold(
            (l) {
              emit(state.copyWith(
                  createCartridgeState: ModelState.failed(l.error)));
              emit(
                state.copyWith(createCartridgeState: ModelState.idle()),
              );
            },
            (r) {
              emit(state.copyWith(createCartridgeState: ModelState.loaded(r)));
              emit(
                state.copyWith(createCartridgeState: ModelState.idle()),
              );
            },
          ),
        );
  }

  Future<void> searchCartridge(String searchString,
      {bool isDeleted = false}) async {
    emit(state.copyWith(getCartridgesState: ModelState.loading()));

    await _repository.searchCartridges(searchString, isDeleted: isDeleted).then(
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

  Future deleteCartridge(int id) async {
    emit(state.copyWith(deleteCartridgeState: ModelState.loading()));

    await _repository.deleteCartridge(id).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                deleteCartridgeState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                deleteCartridgeState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future restoreCartridge(int id) async {
    emit(state.copyWith(restoreCartridgeState: ModelState.loading()));

    await _repository.restoreCartridge(id).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                restoreCartridgeState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                restoreCartridgeState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> loadCartridgeById(int id) async {
    emit(state.copyWith(getCartridgesState: ModelState.loading()));

    await _repository.getCartridgeById(id).then(
          (result) => result.fold(
            (l) => emit(
              state.copyWith(
                getCartridgeByIdState: ModelState.failed(l.error),
              ),
            ),
            (r) => emit(
              state.copyWith(
                getCartridgeByIdState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  Future<void> editCartridge({
    required int id,
    String? mark,
    required String model,
    String? inventoryNumber,
    bool isInRepair = false,
    bool isDeleted = false,
    bool isReplaced = false,
  }) async {
    emit(state.copyWith(updateCartridgeState: ModelState.loading()));

    await _repository
        .updateCartridge(
          id: id,
          mark: mark,
          model: model,
          inventoryNumber: inventoryNumber,
          isInRepair: isInRepair,
          isDeleted: isDeleted,
          isReplaced: isReplaced,
        )
        .then(
          (result) => result.fold((l) {
            emit(state.copyWith(
                updateCartridgeState: ModelState.failed(l.error)));
            emit(state.copyWith(createCartridgeState: ModelState.idle()));
          }, (r) {
            emit(state.copyWith(updateCartridgeState: ModelState.loaded(r)));
            emit(state.copyWith(createCartridgeState: ModelState.idle()));
          }),
        );
  }

  Future<void> makeReplacement(int id) async {
    emit(state.copyWith(updateCartridgeState: ModelState.loading()));

    await _repository.replacement(id).then(
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

  Future<void> returnFromReplacement(int id) async {
    emit(state.copyWith(updateCartridgeState: ModelState.loading()));

    await _repository.returnFromReplacement(id).then(
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

  Future<void> sendToRepair(int id) async {
    emit(state.copyWith(updateCartridgeState: ModelState.loading()));

    await _repository.sendToRepair(id).then(
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

  Future<void> returnFromRepair(int id) async {
    emit(state.copyWith(updateCartridgeState: ModelState.loading()));

    await _repository.returnFromRepair(id).then(
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

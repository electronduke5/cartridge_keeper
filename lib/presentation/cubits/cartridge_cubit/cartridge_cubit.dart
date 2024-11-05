import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:cartridge_keeper/presentation/di/app_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                state.copyWith(getCartridgesState: ModelState.failed(l.error))),
            (r) => emit(
              state.copyWith(
                getCartridgesState: ModelState.loaded(r),
              ),
            ),
          ),
        );
  }

  // Future<void> loadOnlyAvailableCartridges() async {
  //   emit(state.copyWith(getCartridgesState: ModelState.loading()));
  //
  //   final allCartridges = await _repository.getAllCartridges().then(
  //         (result) => result.fold(
  //           (l) => null,
  //           (r) => r,
  //         ),
  //       );
  //
  //   if (allCartridges != null) {
  //     final allRepairs = await _repairRepository.getAllRepairs().then(
  //           (result) => result.fold(
  //             (l) => null,
  //             (r) => r,
  //           ),
  //         );
  //     if (allRepairs != null) {
  //       final repairCartridgeIds = allRepairs
  //           .where((repair) => repair.endDate == null)
  //           .map((repair) => repair.cartridge.id)
  //           .toSet();
  //
  //       final availableCartridges = allCartridges
  //           .where((cartridge) => !repairCartridgeIds.contains(cartridge.id))
  //           .where((cartridge) => cartridge.inventoryNumber != null)
  //           .toList();
  //       emit(state.copyWith(
  //           getCartridgesState: ModelState.loaded(availableCartridges)));
  //     } else {
  //       emit(state.copyWith(
  //           getCartridgesState: ModelState.loaded(allCartridges)));
  //     }
  //   } else {
  //     emit(state.copyWith(
  //         getCartridgesState: ModelState.failed('Картриджей нет!')));
  //   }
  // }

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
    print('availableCartridges: ${availableCartridges?.map((e) => e.toMap())}');
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

  Future<void> searchCartridge(String inventoryNumber) async {
    emit(state.copyWith(getCartridgesState: ModelState.loading()));

    await _repository.searchCartridges(inventoryNumber).then(
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

  // Future<void> loadCartridgeByColumn(String columnName, String columnValue) async {
  //   emit(state.copyWith(getCartridgeByColumnState: ModelState.loading()));
  //
  //   await _repository.getCartridgeByColumn(columnName, columnValue).then(
  //         (result) => result.fold(
  //           (l) => emit(
  //         state.copyWith(
  //           getCartridgeByColumnState: ModelState.failed(l.error),
  //         ),
  //       ),
  //           (r) => emit(
  //         state.copyWith(
  //           getCartridgeByColumnState: ModelState.loaded(r),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

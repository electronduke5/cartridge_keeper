part of 'cartridge_cubit.dart';

@immutable
class CartridgeState {
  final ModelState<List<Cartridge>> getCartridgesState;
  final ModelState<Cartridge> getCartridgeByIdState;
  final ModelState<Cartridge> getCartridgeByColumnState;
  final ModelState<Cartridge> createCartridgeState;
  final ModelState<Cartridge> updateCartridgeState;
  final ModelState<String>? deleteCartridgeState;
  final String? mark;
  final String model;
  final String? inventoryNumber;

  const CartridgeState({
    this.getCartridgesState = const IdleState(),
    this.getCartridgeByIdState = const IdleState(),
    this.getCartridgeByColumnState = const IdleState(),
    this.createCartridgeState = const IdleState(),
    this.updateCartridgeState = const IdleState(),
    this.deleteCartridgeState = const IdleState(),
    this.mark,
    this.model = '',
    this.inventoryNumber,
  });

  CartridgeState copyWith({
    ModelState<List<Cartridge>>? getCartridgesState,
    ModelState<Cartridge>? getCartridgeByIdState,
    ModelState<Cartridge>? getCartridgeByColumnState,
    ModelState<Cartridge>? createCartridgeState,
    ModelState<Cartridge>? updateCartridgeState,
    ModelState<String>? deleteCartridgeState,
    String? mark,
    String? model,
    String? inventoryNumber,
  }) =>
      CartridgeState(
        getCartridgesState: getCartridgesState ?? this.getCartridgesState,
        getCartridgeByIdState: getCartridgeByIdState ?? this.getCartridgeByIdState,
        getCartridgeByColumnState: getCartridgeByColumnState ?? this.getCartridgeByColumnState,
        createCartridgeState: createCartridgeState ?? this.createCartridgeState,
        updateCartridgeState: updateCartridgeState ?? this.updateCartridgeState,
        deleteCartridgeState: deleteCartridgeState ?? this.deleteCartridgeState,
        mark: mark ?? this.mark,
        model: model ?? this.model,
        inventoryNumber: inventoryNumber ?? this.inventoryNumber,
      );
}

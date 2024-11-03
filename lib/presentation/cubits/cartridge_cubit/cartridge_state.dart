part of 'cartridge_cubit.dart';

class CartridgeState {
  final ModelState<List<Cartridge>> getCartridgesState;
  final ModelState<Cartridge> getCartridgeByIdState;
  final ModelState<Cartridge> getCartridgeByColumnState;
  final ModelState<Cartridge> createCartridgeState;
  final ModelState<Cartridge> updateCartridgeState;
  final ModelState<String>? deleteCartridgeState;

  const CartridgeState({
    this.getCartridgesState = const IdleState(),
    this.getCartridgeByIdState = const IdleState(),
    this.getCartridgeByColumnState = const IdleState(),
    this.createCartridgeState = const IdleState(),
    this.updateCartridgeState = const IdleState(),
    this.deleteCartridgeState = const IdleState(),
  });

  CartridgeState copyWith({
    ModelState<List<Cartridge>>? getCartridgesState,
    ModelState<Cartridge>? getCartridgeByIdState,
    ModelState<Cartridge>? getCartridgeByColumnState,
    ModelState<Cartridge>? createCartridgeState,
    ModelState<Cartridge>? updateCartridgeState,
    ModelState<String>? deleteCartridgeState,
  }) =>
      CartridgeState(
        getCartridgesState: getCartridgesState ?? this.getCartridgesState,
        getCartridgeByIdState: getCartridgeByIdState ?? this.getCartridgeByIdState,
        getCartridgeByColumnState: getCartridgeByColumnState ?? this.getCartridgeByColumnState,
        createCartridgeState: createCartridgeState ?? this.createCartridgeState,
        updateCartridgeState: updateCartridgeState ?? this.updateCartridgeState,
        deleteCartridgeState: deleteCartridgeState ?? this.deleteCartridgeState,
      );
}

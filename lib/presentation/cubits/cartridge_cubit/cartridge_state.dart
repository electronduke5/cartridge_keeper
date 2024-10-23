part of 'cartridge_cubit.dart';

@immutable
class CartridgeState {
  final ModelState<List<Cartridge>> getCartridgesState;
  final ModelState<Cartridge> createCartridgeState;
  final ModelState<Cartridge> updateCartridgeState;

  const CartridgeState({
    this.getCartridgesState = const IdleState(),
    this.createCartridgeState = const IdleState(),
    this.updateCartridgeState = const IdleState(),
  });

  CartridgeState copyWith({
    ModelState<List<Cartridge>>? getCartridgesState,
    ModelState<Cartridge>? createCartridgeState,
    ModelState<Cartridge>? updateCartridgeState,
  }) =>
      CartridgeState(
        getCartridgesState: getCartridgesState ?? this.getCartridgesState,
        createCartridgeState: createCartridgeState ?? this.createCartridgeState,
        updateCartridgeState: updateCartridgeState ?? this.updateCartridgeState,
      );
}

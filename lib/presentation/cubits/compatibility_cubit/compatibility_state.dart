part of 'compatibility_cubit.dart';

class CompatibilityState {
  final ModelState<List<Compatibility>> getCompatibilitiesState;
  final ModelState<Compatibility> createCompatibilityState;
  final ModelState<void> deleteCompatibilityState;

  const CompatibilityState({
    this.getCompatibilitiesState = const IdleState(),
    this.createCompatibilityState = const IdleState(),
    this.deleteCompatibilityState = const IdleState(),
  });

  CompatibilityState copyWith({
    ModelState<List<Compatibility>>? getCompatibilitiesState,
    ModelState<Compatibility>? createCompatibilityState,
    ModelState<void>? deleteCompatibilityState,
  }) =>
      CompatibilityState(
        getCompatibilitiesState: getCompatibilitiesState ?? this.getCompatibilitiesState,
        createCompatibilityState: createCompatibilityState ?? this.createCompatibilityState,
        deleteCompatibilityState: deleteCompatibilityState ?? this.deleteCompatibilityState,
      );
}

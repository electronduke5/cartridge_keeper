part of 'compatibility_cubit.dart';

class CompatibilityState {
  final ModelState<List<Compatibility>> getCompatibilitiesState;
  final ModelState<Compatibility> createCompatibilityState;

  const CompatibilityState({
    this.getCompatibilitiesState = const IdleState(),
    this.createCompatibilityState = const IdleState(),
  });

  CompatibilityState copyWith({
    ModelState<List<Compatibility>>? getCompatibilitiesState,
    ModelState<Compatibility>? createCompatibilityState,
  }) =>
      CompatibilityState(
        getCompatibilitiesState: getCompatibilitiesState ?? this.getCompatibilitiesState,
        createCompatibilityState: createCompatibilityState ?? this.createCompatibilityState,
      );
}

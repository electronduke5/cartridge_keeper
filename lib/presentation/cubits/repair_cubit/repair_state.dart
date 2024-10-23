part of 'repair_cubit.dart';

@immutable
class RepairState {
  final ModelState<List<Repair>> getRepairsState;
  final ModelState<Repair> createRepairState;
  final ModelState<Repair> updateRepairState;

  const RepairState({
    this.getRepairsState = const IdleState(),
    this.createRepairState = const IdleState(),
    this.updateRepairState = const IdleState(),
  });

  RepairState copyWith({
    ModelState<List<Repair>>? getRepairsState,
    ModelState<Repair>? updateRepairState,
    ModelState<Repair>? createRepairState,
  }) =>
      RepairState(
        getRepairsState: getRepairsState ?? this.getRepairsState,
        createRepairState: createRepairState ?? this.createRepairState,
        updateRepairState: updateRepairState ?? this.updateRepairState,
      );
}

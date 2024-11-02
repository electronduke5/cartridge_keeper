part of 'repair_cubit.dart';

@immutable
class RepairState {
  final ModelState<List<Repair>> getRepairsState;
  final ModelState<Repair> createRepairState;
  final ModelState<Repair> updateRepairState;
  final ModelState<String>? deleteRepairState;
  final Cartridge? changedCartridge;

  const RepairState({
    this.getRepairsState = const IdleState(),
    this.createRepairState = const IdleState(),
    this.updateRepairState = const IdleState(),
    this.deleteRepairState = const IdleState(),
    this.changedCartridge,
  });

  RepairState copyWith({
    ModelState<List<Repair>>? getRepairsState,
    ModelState<Repair>? updateRepairState,
    ModelState<Repair>? createRepairState,
    ModelState<String>? deleteRepairState,
    Cartridge? changedCartridge,
  }) =>
      RepairState(
        getRepairsState: getRepairsState ?? this.getRepairsState,
        createRepairState: createRepairState ?? this.createRepairState,
        updateRepairState: updateRepairState ?? this.updateRepairState,
        deleteRepairState: deleteRepairState ?? this.deleteRepairState,
        changedCartridge: changedCartridge ?? this.changedCartridge,
      );
}

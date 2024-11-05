part of 'office_cubit.dart';

class OfficeState {
  final ModelState<List<Office>> getOfficesState;
  final ModelState<Office> createOfficeState;
  final ModelState<Office> updateOfficeState;
  final ModelState<String> deleteOfficeState;
  final Cartridge? changedCartridge;
  final Department? changedDepartment;


  const OfficeState({
    this.getOfficesState = const IdleState(),
    this.createOfficeState = const IdleState(),
    this.updateOfficeState = const IdleState(),
    this.deleteOfficeState = const IdleState(),
    this.changedCartridge,
    this.changedDepartment,
  });

  OfficeState copyWith({
    ModelState<List<Office>>? getOfficesState,
    ModelState<Office>? createOfficeState,
    ModelState<Office>? updateOfficeState,
    ModelState<String>? deleteOfficeState,
    Cartridge? changedCartridge,
    Department? changedDepartment,
  }) {
    return OfficeState(
      getOfficesState: getOfficesState ?? this.getOfficesState,
      createOfficeState: createOfficeState ?? this.createOfficeState,
      updateOfficeState: updateOfficeState ?? this.updateOfficeState,
      deleteOfficeState: deleteOfficeState ?? this.deleteOfficeState,
      changedCartridge: changedCartridge ?? this.changedCartridge,
      changedDepartment: changedDepartment ?? this.changedDepartment,
    );
  }
}

part of 'office_cubit.dart';

@immutable
class OfficeState {
  final ModelState<List<Office>> getOfficesState;
  final ModelState<Office> createOfficeState;
  final ModelState<Office> updateOfficeState;

  const OfficeState({
    this.getOfficesState = const IdleState(),
    this.createOfficeState = const IdleState(),
    this.updateOfficeState = const IdleState(),
  });

  OfficeState copyWith({
    ModelState<List<Office>>? getOfficesState,
    ModelState<Office>? createOfficeState,
    ModelState<Office>? updateOfficeState,
  }) {
    return OfficeState(
      getOfficesState: getOfficesState ?? this.getOfficesState,
      createOfficeState: createOfficeState ?? this.createOfficeState,
      updateOfficeState: updateOfficeState ?? this.updateOfficeState,
    );
  }
}

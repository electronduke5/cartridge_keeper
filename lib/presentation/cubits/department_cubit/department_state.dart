part of 'department_cubit.dart';

class DepartmentState {
  final ModelState<List<Department>> getDepartmentsState;

  const DepartmentState({this.getDepartmentsState = const IdleState()});

  DepartmentState copyWith({
    ModelState<List<Department>>? getDepartmentsState,
  }) =>
      DepartmentState(
        getDepartmentsState: getDepartmentsState ?? this.getDepartmentsState,
      );
}

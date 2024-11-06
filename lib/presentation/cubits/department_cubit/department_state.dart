part of 'department_cubit.dart';

class DepartmentState {
  final ModelState<List<Department>> getDepartmentsState;
  final ModelState<List<Department>> getFilteredDepartmentsState;

  const DepartmentState({
    this.getDepartmentsState = const IdleState(),
    this.getFilteredDepartmentsState = const IdleState(),
  });

  DepartmentState copyWith({
    ModelState<List<Department>>? getDepartmentsState,
    ModelState<List<Department>>? getFilteredDepartmentsState,
  }) =>
      DepartmentState(
        getDepartmentsState: getDepartmentsState ?? this.getDepartmentsState,
        getFilteredDepartmentsState:
            getFilteredDepartmentsState ?? this.getFilteredDepartmentsState,
      );
}

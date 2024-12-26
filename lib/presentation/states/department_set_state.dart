import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/department.dart';

final departmentSetProvider =
    StateNotifierProvider<DepartmentSetState, Set<Department>>(
        (ref) => DepartmentSetState());

class DepartmentSetState extends StateNotifier<Set<Department>> {
  DepartmentSetState() : super(<Department>{});

  void addItem(Department department) {
    state = {...state, department};
  }

  void removeItem(Department department) {
    state = state.where((element) => element.id != department.id).toSet();
  }

  void clear() {
    state = <Department>{};
  }

  void toggleItem(Department department) {
    if (state.map((e) => e.id).toList().contains(department.id)) {
      removeItem(department);
    } else {
      addItem(department);
    }
  }

  void toggleAll(List<Department> departments) {
    if (state.length == departments.length) {
      clear();
    } else {
      state = <Department>{...departments};
    }
  }
}

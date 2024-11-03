import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:cartridge_keeper/presentation/di/app_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/department.dart';

part 'department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  DepartmentCubit() : super(const DepartmentState());

  final _repository = AppModule.getDepartmentRepository();

  Future<void> loadAllDepartments() async {
    emit(state.copyWith(getDepartmentsState: ModelState.loading()));

    var result = await _repository.getAllDepartments();
    result.fold(
      (l) => emit(
        state.copyWith(
          getDepartmentsState: ModelState.failed(l.error),
        ),
      ),
      (r) => emit(
        state.copyWith(
          getDepartmentsState: ModelState.loaded(r),
        ),
      ),
    );
  }
}

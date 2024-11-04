import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/start_date_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cartridge.dart';
import '../../../data/models/department.dart';
import '../../cubits/department_cubit/department_cubit.dart';
import '../../cubits/office_cubit/office_cubit.dart';

class ReplacementCartridgeDialog {
  static final _formKey = GlobalKey<FormState>();

  static openDialog({
    required BuildContext context,
    required OfficeCubit officeCubit,
    required CartridgeCubit cartridgeCubit,
    required DepartmentCubit departmentCubit,
  }) {
    final TextEditingController officeNumberController =
        TextEditingController();
    final TextEditingController replacementDateController =
        TextEditingController(text: DateTime.now().toLocalFormat);

    final Future<void> loadData = Future.wait([
      cartridgeCubit.loadOnlyAvailableCartridges(),
      departmentCubit.loadAllDepartments(),
    ]);

    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to load data: ${snapshot.error}'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            } else {
              return BlocProvider.value(
                value: officeCubit,
                child: BlocProvider.value(
                  value: cartridgeCubit,
                  child: BlocProvider.value(
                    value: departmentCubit,
                    child: AlertDialog(
                      title: const Text('Добавить замену картриджа'),
                      content: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text('Номер кабинета'),
                            ),
                            TextFormField(
                              controller: officeNumberController,
                              decoration: const InputDecoration(
                                hintText: '2.10',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Введите номер кабинета';
                                }
                                return null;
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text('Дата замены'),
                            ),
                            StartDateFormField(
                                startDateController: replacementDateController),
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text('Подразделение'),
                            ),
                            BlocBuilder<DepartmentCubit, DepartmentState>(
                                builder: (context, state) {
                              return DropdownButtonFormField<Department?>(
                                items: state.getDepartmentsState.item!
                                    .map(
                                      (department) => DropdownMenuItem(
                                        value: department,
                                        child: Text(department.name),
                                      ),
                                    )
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Выберите подразделение';
                                  }
                                  return null;
                                },
                                onChanged: (Department? department) {
                                  officeCubit.changeDepartment(department!);
                                },
                              );
                            }),
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text('Картридж'),
                            ),
                            BlocBuilder<CartridgeCubit, CartridgeState>(
                              builder: (context, state) {
                                return DropdownButtonFormField<Cartridge?>(
                                  items: state.getCartridgesState.item!
                                      .map(
                                        (cartridge) => DropdownMenuItem(
                                          value: cartridge,
                                          child: Text(
                                              'Инв. №: ${cartridge.inventoryNumber}\n${cartridge.model}'),
                                        ),
                                      )
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Выберите картридж';
                                    }
                                    return null;
                                  },
                                  onChanged: (Cartridge? cartridge) {
                                    officeCubit.changeCartridge(cartridge!);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Отмена'),
                        ),
                        BlocBuilder<OfficeCubit, OfficeState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  officeCubit
                                    ..addOffice(
                                      officeNumber: officeNumberController.text,
                                      replacementDate:
                                          replacementDateController.text,
                                      department: state.changedDepartment!,
                                      cartridge: state.changedCartridge!,
                                    )
                                    ..loadAllOffices();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Добавить'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

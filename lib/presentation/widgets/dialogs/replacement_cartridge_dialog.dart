import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/start_date_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/department.dart';
import '../../cubits/office_cubit/office_cubit.dart';
import '../cartridges_dropdown.dart';

class ReplacementCartridgeDialog {
  static final _formKey = GlobalKey<FormState>();

  static openDialog({
    required BuildContext context,
    required OfficeCubit officeCubit,
    required CartridgeCubit cartridgeCubit,
    required List<Department> departments,
  }) {
    final TextEditingController officeNumberController =
        TextEditingController();
    final TextEditingController replacementDateController =
        TextEditingController(text: DateTime.now().toLocalFormat);

    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider.value(
            value: cartridgeCubit,
            child: BlocProvider.value(
              value: officeCubit,
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
                      DropdownButtonFormField<Department?>(
                        dropdownColor: Theme.of(context).cardTheme.color,
                        items: departments
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
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text('Картридж'),
                      ),
                      FutureBuilder(
                        future: Future.wait([
                          cartridgeCubit.loadOnlyAvailableCartridges(
                              isIncludingReplacement: true)
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Ошибка при получении картриджей'));
                          } else {
                            return BlocBuilder<CartridgeCubit, CartridgeState>(
                              builder: (context, state) {
                                return CartridgesDropdown(
                                    cartridges: state.getCartridgesState.item!,
                                    officeCubit: officeCubit);
                              },
                            );
                          }
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
                                replacementDate: replacementDateController.text,
                                department: state.changedDepartment!,
                                cartridge: state.changedCartridge!,
                              )
                              ..loadAllOffices();
                            context
                                .read<CartridgeCubit>()
                                .makeReplacement(state.changedCartridge!.id);
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
          );
        });
  }
}

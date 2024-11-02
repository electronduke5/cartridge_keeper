import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cartridge.dart';
import '../../../data/models/repair.dart';
import '../../cubits/cartridge_cubit/cartridge_cubit.dart';
import '../../cubits/repair_cubit/repair_cubit.dart';
import '../start_date_form_field.dart';

class RepairDialogs {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static openDialog({
    required BuildContext context,
    Repair? repair,
    required RepairCubit repairCubit,
    required CartridgeCubit cartridgeCubit,
  }) {
    TextEditingController startDateController = TextEditingController(
      text: repair?.startDate.toString() ?? DateTime.now().toLocalFormat,
    );
    TextEditingController endDateController =
        TextEditingController(text: repair?.endDate.toString());
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: repairCubit,
          child: BlocProvider.value(
            value: cartridgeCubit,
            child: BlocListener<RepairCubit, RepairState>(
              listener: (context, state) {
                if (state.createRepairState is LoadedState<Repair>) {
                  Navigator.of(context).pop();
                } else if (state.createRepairState is FailedState<Repair>) {
                  Navigator.of(context).pop();
                }
              },
              child: AlertDialog(
                title: Text(
                    repair == null ? 'Добавить ремонт' : 'Изменить ремонт'),
                content: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text('Картридж'),
                      ),
                      BlocBuilder<CartridgeCubit, CartridgeState>(
                        builder: (context, state) {
                          //TODO: Проверка, если availableCarteidge == null, то показать, что картриджей нет
                          if (state.getCartridgesState.item == null ||
                              state.getCartridgesState.item!.isEmpty || repairCubit.state.getRepairsState.item == null
                          ) {
                            return const Center(
                                child: Text('Сначала добавьте картридж'));
                          } else {
                            return DropdownButtonFormField<Cartridge?>(
                              validator: (value) {
                                if (value == null) {
                                  return 'Выберите картридж';
                                }
                                return null;
                              },
                              value: repair?.cartridge,
                              items: repairCubit.getAvailableCartridges(state.getCartridgesState.item!, repairCubit.state.getRepairsState.item!)
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                            'Инв. №: ${e.inventoryNumber}\n${e.model}'),
                                      ))
                                  .toList(),
                              onChanged: (Cartridge? cartridge) {
                                repairCubit.changedCartridge(cartridge);
                              },
                            );
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text('Дата начала ремонта'),
                      ),
                      StartDateFormField(
                        startDateController: startDateController,
                      ),
                      () {
                        if (repair != null) {
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: Text('Дата окончания ремонта'),
                              ),
                              TextFormField(
                                controller: endDateController,
                                readOnly: true,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  print('endDate: $date');
                                },
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }(),
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
                  BlocBuilder<RepairCubit, RepairState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (repair == null) {
                              print(
                                  'startDateController.text: ${startDateController.text}');
                              print(
                                  'state.changedCartridgeId: ${state.changedCartridge?.model}');
                              repairCubit..addRepair(startDateController.text, state.changedCartridge!)..loadAllRepairs();

                            } else {}
                            formKey.currentState!.reset();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(repair == null ? 'Добавить' : 'Изменить'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

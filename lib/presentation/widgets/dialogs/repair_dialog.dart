import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cartridge.dart';
import '../../../data/models/repair.dart';
import '../../cubits/cartridge_cubit/cartridge_cubit.dart';
import '../../cubits/repair_cubit/repair_cubit.dart';
import '../cartridges_dropdown.dart';
import '../end_date_form_field.dart';
import '../start_date_form_field.dart';

class RepairDialogs {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static openDialog({
    required BuildContext context,
    Repair? repair,
    Cartridge? cartridge,
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
                      () {
                        if (cartridge == null) {
                          return BlocBuilder<CartridgeCubit, CartridgeState>(
                            builder: (context, state) {
                              //TODO: Проверка, если availableCarteidge == null, то показать, что картриджей нет
                              if (state.getCartridgesState.item == null ||
                                  state.getCartridgesState.item!.isEmpty ||
                                  repairCubit.state.getRepairsState.item ==
                                      null) {
                                return const Center(
                                    child: Text('Сначала добавьте картридж'));
                              } else {
                                return CartridgesDropdown(
                                  cartridges: state.getCartridgesState.item!,
                                  repairCubit: repairCubit,
                                );
                              }
                            },
                          );
                        } else {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                style: BorderStyle.solid,
                                color: const Color(0xFF4880FF).withOpacity(0.6),
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Модель:'),
                                      Text(
                                        cartridge.model.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    children: [
                                      const Text('Инв. номер:'),
                                      Text(
                                        cartridge.inventoryNumber.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }(),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text('Дата начала ремонта'),
                      ),
                      StartDateFormField(
                        startDateController: startDateController,
                        endDate: repair?.endDate?.parseLocalDate,
                      ),
                      () {
                        if (repair != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: Text('Дата окончания ремонта'),
                              ),
                              EndDateFormField(
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.parseLocalDate.isBefore(
                                          startDateController
                                              .text.parseLocalDate)) {
                                    return 'Дата окончания ремонта не может быть раньше даты начала';
                                  }
                                  return null;
                                },
                                endDateController: endDateController,
                                startDate:
                                    startDateController.text.parseLocalDate,
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
                            if (repair == null || cartridge == null) {
                              repairCubit
                                ..addRepair(startDateController.text,
                                    state.changedCartridge!)
                                ..loadAllRepairs();
                              cartridgeCubit
                                  .sendToRepair(state.changedCartridge!.id);
                            } else {
                              repairCubit
                                ..editRepair(
                                    repair.id,
                                    startDateController.text,
                                    endDateController.text.isEmpty
                                        ? null
                                        : endDateController.text,
                                    cartridge)
                                ..loadAllRepairs();

                              endDateController.text.isEmpty
                                  ? cartridgeCubit.sendToRepair(cartridge.id)
                                  : cartridgeCubit
                                      .returnFromRepair(cartridge.id);
                            }
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

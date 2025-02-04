import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:cartridge_keeper/presentation/cubits/repair_cubit/repair_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cartridge_cubit/cartridge_cubit.dart';
import 'dialogs/repair_dialog.dart';

class RepairCardWidget extends StatelessWidget {
  const RepairCardWidget(
      {super.key, required this.repair, this.isShowActionButtons = true});

  final Repair repair;
  final bool isShowActionButtons;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.maxFinite,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text('Инв. номер:'),
                      Text(
                        repair.cartridge.inventoryNumber.toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Text('Модель:'),
                      Text(
                        repair.cartridge.model.toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  if (repair.startDate == '')
                    const Text('Ещё не отправлен на ремонт.',
                        style: TextStyle(color: Colors.blue)),
                  if (repair.startDate != '')
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Дата отправки: ${repair.startDate}'),
                        Wrap(
                          children: [
                          const Text('Дата возврата: '),
                          Text(
                            repair.endDate ?? 'Ещё в ремонте',
                            style: TextStyle(
                                color: repair.endDate == null
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (isShowActionButtons)
                BlocBuilder<RepairCubit, RepairState>(
                  builder: (context, state) {
                    return Wrap(
                      children: [
                        () {
                          if (repair.endDate == null &&
                              repair.startDate != '') {
                            return IconButton(
                              tooltip: 'Вернуть из ремонта',
                              onPressed: () async {
                                context.read<RepairCubit>()
                                  ..returnFromRepair(
                                    repair.id,
                                    DateTime.now().toLocalFormat,
                                  )
                                  ..loadAllRepairs();
                                context
                                    .read<CartridgeCubit>()
                                    .returnFromRepair(repair.cartridge.id);
                              },
                              icon: const Icon(
                                Icons.task_alt,
                                color: Colors.green,
                              ),
                            );
                          } else if (repair.endDate == null &&
                              repair.startDate == '') {
                            return IconButton(
                              tooltip: 'Отправить на ремонт',
                              onPressed: () async {
                                context.read<RepairCubit>()
                                  ..sendToRepair(repair.id)
                                  ..loadAllRepairs();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.blue,
                              ),
                            );
                          }
                          return IconButton(
                            tooltip: 'Редактировать',
                            onPressed: () async {
                              RepairDialogs.openDialog(
                                repair: repair,
                                context: context,
                                repairCubit: context.read<RepairCubit>(),
                                cartridgeCubit: context.read<CartridgeCubit>()
                                  ..loadAllCartridges(),
                                cartridge: repair.cartridge,
                              );
                            },
                            icon: const Icon(
                              Icons.edit_note,
                              color: Colors.orangeAccent,
                            ),
                          );
                        }(),
                        IconButton(
                          tooltip: 'Удалить',
                          onPressed: () async {
                            context.read<RepairCubit>()
                              ..deleteRepair(repair.id)
                              ..loadAllRepairs();
                            context
                                .read<CartridgeCubit>()
                                .returnFromRepair(repair.cartridge.id);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

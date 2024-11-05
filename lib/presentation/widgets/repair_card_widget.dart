import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:cartridge_keeper/presentation/cubits/repair_cubit/repair_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cartridge_cubit/cartridge_cubit.dart';
import 'dialogs/repair_dialog.dart';


class RepairCardWidget extends StatelessWidget {
  const RepairCardWidget({super.key, required this.repair});

  final Repair repair;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Дата отправки: ${repair.startDate}'),
                Row(
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
            const Expanded(child: SizedBox()),
            BlocBuilder<RepairCubit, RepairState>(
              builder: (context, state) {
                return Row(
                  children: [
                    () {
                      if (repair.endDate == null) {
                        return IconButton(
                          onPressed: () async {
                            context.read<RepairCubit>()
                              ..returnFromRepair(
                                  repair.id, DateTime.now().toLocalFormat)
                              ..loadAllRepairs();
                            context.read<CartridgeCubit>().returnFromRepair(repair.cartridge.id);
                          },
                          icon: const Icon(
                            Icons.task_alt,
                            color: Colors.green,
                          ),
                        );
                      }
                      return IconButton(
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
                      onPressed: () async {
                        context.read<RepairCubit>()
                          ..deleteRepair(repair.id)
                          ..loadAllRepairs();
                        context.read<CartridgeCubit>().returnFromRepair(repair.cartridge.id);
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
    );
  }
}

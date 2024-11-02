import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:cartridge_keeper/presentation/cubits/repair_cubit/repair_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/db/database_helper.dart';

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
                    IconButton(
                      onPressed: () async {
                        final response = await DatabaseHelper.instance.queryAllRowsWithReference(
                          DatabaseRequest.tableRepairs,
                          DatabaseRequest.tableCartridges,
                          'cartridge_id',
                        );
                        print(response);
                      },
                      icon: const Icon(
                        Icons.task_alt,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        context.read<RepairCubit>()..deleteRepair(repair.id)..loadAllRepairs();
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

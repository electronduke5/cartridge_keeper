import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/data/models/repair.dart';
import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:cartridge_keeper/presentation/cubits/repair_cubit/repair_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/repair_dialog.dart';
import 'package:cartridge_keeper/presentation/widgets/repair_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cartridge_cubit/cartridge_cubit.dart';

class RepairsPage extends StatelessWidget {
  const RepairsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ремонты',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<RepairCubit, RepairState>(
                builder: (context, state) {
                  switch (state.getRepairsState) {
                    case IdleState<List<Repair>> _:
                      return const Center(child: Text('IdleState'));
                    case LoadingState<List<Repair>> _:
                      return const Center(child: CircularProgressIndicator());
                    case LoadedState<List<Repair>> _:
                      return SizedBox.expand(
                        child: () {
                          if (state.getRepairsState.item == null ||
                              state.getRepairsState.item!.isEmpty) {
                            return const Center(
                              child: Text(
                                'Ещё ни один картридж не был отремонтирован',
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: state.getRepairsState.item!.length,
                              itemBuilder: (context, index) {
                                final List<Repair> listRepairs =
                                    state.getRepairsState.item!;
                                listRepairs.sort(
                                  (a, b) => a.startDate.parseLocalDate
                                      .compareTo(b.startDate.parseLocalDate),
                                );

                                final repair = listRepairs[index];
                                final previousRepair =
                                    index > 0 ? listRepairs[index - 1] : null;
                                final isNewDate = previousRepair == null ||
                                    repair.startDate.parseLocalDate !=
                                        previousRepair.startDate.parseLocalDate;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isNewDate)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 1,
                                                color: listRepairs
                                                        .where((r) =>
                                                            r.startDate ==
                                                            repair.startDate)
                                                        .every((r) =>
                                                            r.endDate != null)
                                                    ? Colors.lightGreenAccent
                                                    : Colors.grey,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                '${repair.startDate} (${listRepairs.where((r) => r.startDate == repair.startDate).length} шт.)',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 1,
                                                color: listRepairs
                                                        .where((r) =>
                                                            r.startDate ==
                                                            repair.startDate)
                                                        .every((r) =>
                                                            r.endDate != null)
                                                    ? Colors.lightGreenAccent
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    RepairCardWidget(repair: repair),
                                  ],
                                );
                              },
                            );
                          }
                        }(),
                      );
                    case FailedState<List<Repair>> _:
                      return Center(
                        child: Text(state.getRepairsState.message ?? 'Error1'),
                      );
                    default:
                      return const Center(child: Text('Error'));
                  }
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    RepairDialogs.openDialog(
                      context: context,
                      repairCubit: context.read<RepairCubit>(),
                      cartridgeCubit: context.read<CartridgeCubit>()
                        ..loadOnlyAvailableCartridges(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить'),
                ),
                const SizedBox(width: 10),
                BlocBuilder<RepairCubit, RepairState>(
                  builder: (context, state) {
                    return ElevatedButton.icon(
                      onPressed: () async {
                        await context
                            .read<RepairCubit>()
                            .creatingPDF(state.getRepairsState.item!);
                      },
                      icon: const Icon(Icons.print_outlined),
                      label: const Text('PDF'),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

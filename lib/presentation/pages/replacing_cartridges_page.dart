import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/cubits/office_cubit/office_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/replacement_cartridge_dialog.dart';
import 'package:cartridge_keeper/presentation/widgets/replacement_cartridge_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/office.dart';
import '../cubits/department_cubit/department_cubit.dart';
import '../cubits/model_state.dart';

class ReplacingCartridgesPage extends StatelessWidget {
  const ReplacingCartridgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Замена картриджей',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<OfficeCubit, OfficeState>(
                builder: (context, state) {
                  switch (state.getOfficesState) {
                    case IdleState<List<Office>> _:
                      return const Center(child: Text('IdleState'));
                    case LoadingState<List<Office>> _:
                      return const Center(child: CircularProgressIndicator());
                    case LoadedState<List<Office>> _:
                      return SizedBox.expand(
                        child: () {
                          if (state.getOfficesState.item == null ||
                              state.getOfficesState.item!.isEmpty) {
                            return const Center(
                              child: Text(
                                'Ещё ни один картридж не был заменен',
                              ),
                            );
                          } else {
                            final List<Office> listOffices =
                                state.getOfficesState.item!;
                            listOffices.sort(
                              (a, b) => a.replacementDate.parseLocalDate
                                  .compareTo(b.replacementDate.parseLocalDate),
                            );
                            return ReplacementCartridgeLayoutGrid(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 1265
                                      ? 3
                                      : MediaQuery.of(context).size.width > 900
                                          ? 2
                                          : 1,
                              items: listOffices,
                            );
                          }
                        }(),
                      );
                    case FailedState<List<Office>> _:
                      return Center(
                        child: Text(state.getOfficesState.message ?? 'Ошибка'),
                      );
                    default:
                      return const Center(child: Text('Default'));
                  }
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await ReplacementCartridgeDialog.openDialog(
                      context: context,
                      officeCubit: context.read<OfficeCubit>(),
                      departmentCubit: context.read<DepartmentCubit>(),
                      cartridgeCubit: context.read<CartridgeCubit>(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить замену картриджа'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

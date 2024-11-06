import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/cubits/office_cubit/office_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/department_filter_dropdown.dart';
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
      body: FutureBuilder(
        future: Future.wait([
          context.read<OfficeCubit>().loadAllOffices(),
          context.read<DepartmentCubit>().loadAllDepartments(),
        ]),
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
            return _buildBody(context);
          }
        },
      ),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Замена картриджей',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              BlocBuilder<DepartmentCubit, DepartmentState>(
                builder: (context, state) {
                  return DepartmentFilterDropdown(
                      departments: state.getDepartmentsState.item!);
                },
              )
            ],
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
              BlocBuilder<DepartmentCubit, DepartmentState>(
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      await ReplacementCartridgeDialog.openDialog(
                        context: context,
                        officeCubit: context.read<OfficeCubit>(),
                        departments: state.getDepartmentsState.item!,
                        cartridgeCubit: context.read<CartridgeCubit>()..loadOnlyAvailableCartridges(isIncludingReplacement: true),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить замену картриджа'),
                  );
                },
              ),
              const SizedBox(width: 10),
              BlocBuilder<OfficeCubit, OfficeState>(
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      await context
                          .read<OfficeCubit>()
                          .createPDF(state.getOfficesState.item!);
                    },
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('PDF'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

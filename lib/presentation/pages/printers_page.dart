import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:cartridge_keeper/presentation/cubits/printer_cubit/printer_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/add_printer_dialog.dart';
import 'package:cartridge_keeper/presentation/widgets/printers_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/printer.dart';

class PrintersPage extends StatelessWidget {
  const PrintersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<PrinterCubit, PrinterState>(
              builder: (context, state) {
                switch (state.getPrintersState) {
                  case IdleState _:
                    return const Center(child: CircularProgressIndicator());
                  case LoadingState<List<Printer>> _:
                    return const Center(child: CircularProgressIndicator());
                  case LoadedState<List<Printer>> _:
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Принтеры',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 5),
                          Expanded(
                            child: PrintersLayoutGrid(
                              printers: state.getPrintersState.item!,
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 1305
                                      ? 4
                                      : MediaQuery.of(context).size.width > 900
                                          ? 2
                                          : 1,
                            ),
                          ),
                          const Divider(),
                          ElevatedButton.icon(
                            onPressed: () {
                              PrinterDialogs.openDialog(
                                context: context,
                                printerCubit: context.read<PrinterCubit>(),
                              );
                            },
                            label: const Text('Добавить'),
                            icon: const Icon(Icons.add),
                          )
                        ],
                      ),
                    );
                  case FailedState<List<Printer>> _:
                    return Center(
                        child: Text(state.getPrintersState.message ?? 'Error'));
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

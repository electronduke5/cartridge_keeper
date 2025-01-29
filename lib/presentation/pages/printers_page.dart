import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:cartridge_keeper/presentation/cubits/printer_cubit/printer_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/add_printer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/printer.dart';
import '../widgets/printers_layout_grid.dart';

class PrintersPage extends StatelessWidget {
  const PrintersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Row(
                    children: [
                      const Text(
                        'Принтеры',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IntrinsicWidth(
                        child: BlocBuilder<PrinterCubit, PrinterState>(
                          builder: (context, state) => TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(25)
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Поиск...',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              context.read<PrinterCubit>().searchPrinter(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 5),
                  BlocBuilder<PrinterCubit, PrinterState>(
                    builder: (context, state) {
                      switch (state.getPrintersState) {
                        case IdleState _:
                          return const Center(
                              child: CircularProgressIndicator());
                        case LoadingState<List<Printer>> _:
                          return const Center(
                              child: CircularProgressIndicator());
                        case LoadedState<List<Printer>> _:
                          return Expanded(
                            child: state.getPrintersState.item!.isNotEmpty
                                ? PrintersLayoutGrid(
                                    printers: state.getPrintersState.item!,
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 1305
                                      ? 4
                                      : MediaQuery.of(context).size.width > 900
                                          ? 2
                                          : 1,
                                  )
                                : const Center(
                                    child: Text('Принтеров не найдено...')),
                          );

                        case FailedState<List<Printer>> _:
                          return Center(
                              child: Text(
                                  state.getPrintersState.message ?? 'Error'));
                        default:
                          return const Center(
                              child: CircularProgressIndicator());
                      }
                    },
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
            ),
          ),
        ],
      ),
    );
  }
}

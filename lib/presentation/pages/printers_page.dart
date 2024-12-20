import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:cartridge_keeper/presentation/cubits/printer_cubit/printer_cubit.dart';
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
                          const SizedBox(height: 10),
                          Expanded(
                            child: SizedBox.expand(
                              child: SingleChildScrollView(
                                child: DataTable(
                                  clipBehavior: Clip.antiAlias,
                                  border: TableBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  headingRowColor: WidgetStatePropertyAll(
                                      Theme.of(context)
                                          .cardTheme
                                          .color
                                          ?.withOpacity(0.5)),
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Марка')),
                                    DataColumn(label: Text('Модель')),
                                  ],
                                  rows: state.getPrintersState.item!
                                      .map(
                                        (printer) => DataRow(
                                          color: WidgetStatePropertyAll(
                                              Theme.of(context)
                                                  .cardTheme
                                                  .color),
                                          cells: [
                                            DataCell(
                                                Text(printer.id.toString())),
                                            DataCell(Text(printer.mark)),
                                            DataCell(Text(printer.model)),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
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

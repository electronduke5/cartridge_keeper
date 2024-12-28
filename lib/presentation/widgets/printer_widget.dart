import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/printer_compatibility_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/printer.dart';

class PrinterWidget extends StatelessWidget {
  const PrinterWidget({super.key, required this.printer});

  final Printer printer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${printer.mark} ${printer.model}'),
              ],
            ),
            const Row(
              children: [
                Text('Совместим с: '),
                Text(
                  '259X, 259A, 59A, 59X',
                  style: TextStyle(
                    color: Color(0xFF4880FF),
                  ),
                ),
              ],
            ),
            Consumer(builder: (context, ref, _) {
              return IconButton(
                tooltip: 'Добавить картридж для данного принтера',
                onPressed: () {
                  CompatibilityDialog.show(
                    context: context,
                    cartridgeCubit: context.read<CartridgeCubit>()
                      ..loadAllCartridges(),
                    printer: printer,
                  );
                },
                icon: const Icon(Icons.edit_note),
              );
            }),
          ],
        ),
      ),
    );
  }
}

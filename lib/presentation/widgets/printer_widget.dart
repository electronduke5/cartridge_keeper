import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/printer_compatibility_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/printer.dart';
import '../cubits/compatibility_cubit/compatibility_cubit.dart';
import '../cubits/printer_cubit/printer_cubit.dart';
import '../states/compatibility_cartridges_provider.dart';
import 'dialogs/add_printer_dialog.dart';

class PrinterWidget extends ConsumerWidget {
  const PrinterWidget({super.key, required this.printer});

  final Printer printer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocProvider(
      create: (context) => CompatibilityCubit()..loadAllCompatibilities(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<CompatibilityCubit, CompatibilityState>(
            builder: (context, state) {
              final compatibilities = state.getCompatibilitiesState.item;
              final thisPrinterCompatibilities = compatibilities
                ?.where((compatibility) => compatibility.printerId == printer.id)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                      Wrap(
                        children: [
                          Text('${printer.mark} ${printer.model}'),
                        ],
                      ),
                      const Spacer(),
                      MenuAnchor(
                        builder: (BuildContext context,
                            MenuController controller, Widget? child) {
                          return IconButton(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            icon: const Icon(Icons.more_vert),
                            tooltip: 'Меню',
                          );
                        },
                        menuChildren: [
                          IconButton(
                            onPressed: () {
                              PrinterDialogs.openDialog(
                                context: context,
                                printer: printer,
                                printerCubit: context.read<PrinterCubit>(),
                              );
                            },
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.orangeAccent),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<PrinterCubit>()
                                ..deletePrinter(printer.id!)
                                ..loadAllPrinters();
                            },
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            tooltip: 'Удалить принтер',
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (compatibilities == null)
                    Text(state.getCompatibilitiesState.runtimeType.toString()),
                  if (compatibilities != null &&
                    thisPrinterCompatibilities!.isNotEmpty)
                    Wrap(
                      children: [
                        const Text('Совместим с: '),
                        BlocBuilder<CompatibilityCubit, CompatibilityState>(
                          builder: (context, state) {
                            return Text(
                              thisPrinterCompatibilities.length > 3
                                ? '${thisPrinterCompatibilities[0].cartridgeModel}, ${thisPrinterCompatibilities[1].cartridgeModel}, ${thisPrinterCompatibilities[2].cartridgeModel} и ещё ${thisPrinterCompatibilities.length - 3}.'
                                : '${thisPrinterCompatibilities.map((compatibility) => compatibility.cartridgeModel).join(', ')}.',
                            style: const TextStyle(
                              color: Color(0xFF4880FF),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Добавить картридж для данного принтера',
                        onPressed: () async {
                          final compatibilities = state
                              .getCompatibilitiesState.item!
                              .where((compatibility) =>
                                  compatibility.printerId == printer.id)
                              .toList();
                          ref
                              .read(compatibilityCartridgesProvider.notifier)
                              .addAll(compatibilities
                                  .map((compatibility) =>
                                      compatibility.cartridgeModel)
                                  .toSet());
                          bool? resultDialog = await CompatibilityDialog.show(
                            context: context,
                            cartridgeCubit: context.read<CartridgeCubit>()
                              ..loadAllCartridges(),
                            compatibilityCubit:
                                context.read<CompatibilityCubit>(),
                            printer: printer,
                          );
                          if (resultDialog == null) {
                            ref
                                .read(compatibilityCartridgesProvider.notifier)
                                .clear();
                          }
                        },
                        icon: const Icon(Icons.edit_note),
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<CompatibilityCubit>()
                              .cleanCompatibilities(printer.id!);

                          context
                              .read<CompatibilityCubit>()
                              .loadAllCompatibilities();
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        tooltip: 'Удалить все совместимости',
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

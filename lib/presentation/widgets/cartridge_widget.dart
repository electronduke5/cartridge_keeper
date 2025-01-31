import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/navigation_service.dart';
import '../../data/models/printer.dart';
import '../cubits/cartridge_cubit/cartridge_cubit.dart';
import 'dialogs/add_cartridge_dialog.dart';

class CartridgeWidget extends StatelessWidget {
  const CartridgeWidget(
      {super.key,
      required this.cartridge,
      required this.compatibilityPrinters});

  final Cartridge cartridge;

  final List<Printer>? compatibilityPrinters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: cartridge.isDeleted ? Colors.red : Colors.transparent),
        ),
        child: GestureDetector(
          onTap: () {
            NavigationService.navigateTo(
              '/cartridge-info',
              arguments: {cartridge, compatibilityPrinters},
            );
          },
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FittedBox(
                      child: Column(
                        children: [
                          const Text('Модель:'),
                          Wrap(
                            children: [
                              Text(
                                cartridge.model,
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const Text('Инв. номер:'),
                        Text(
                          cartridge.inventoryNumber ?? '-',
                          style: const TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  () {
                    if (compatibilityPrinters != null &&
                        compatibilityPrinters!.isNotEmpty) {
                      return Row(
                        children: [
                          const Text('Совместим с: '),
                          Wrap(
                            children: [
                              Text(
                                compatibilityPrinters!.length > 1
                                    ? '${compatibilityPrinters![0].mark} ${compatibilityPrinters![0].model} и ещё ${compatibilityPrinters!.length - 1}'
                                    : '${compatibilityPrinters![0].mark} ${compatibilityPrinters![0].model}',
                                style: const TextStyle(
                                  color: Color(0xFF4880FF),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  }(),
                  const SizedBox(width: 20),
                  if (cartridge.isInRepair)
                    const Text(
                      'В ремонте',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  if (cartridge.isReplaced)
                    const Text(
                      'В принтере',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  const Expanded(child: SizedBox()),
                  BlocBuilder<CartridgeCubit, CartridgeState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (cartridge.isDeleted) {
                                context
                                    .read<CartridgeCubit>()
                                    .restoreCartridge(cartridge.id)
                                    .then((value) => context
                                        .read<CartridgeCubit>()
                                        .loadAllCartridges(
                                            isDeleted: state.viewIsDeleted));
                              } else {
                                CartridgeDialogs.openDialog(
                                  context: context,
                                  cartridgeCubit:
                                      context.read<CartridgeCubit>(),
                                  cartridge: cartridge,
                                );
                              }
                            },
                            tooltip: cartridge.isDeleted
                                ? 'Восстановить'
                                : 'Редактировать',
                            icon: Icon(
                              cartridge.isDeleted
                                  ? Icons.restore
                                  : Icons.edit_note,
                            ),
                            color: cartridge.isDeleted
                                ? Colors.blue
                                : Colors.orangeAccent,
                          ),
                          const SizedBox(width: 10),
                          if (!cartridge.isReplaced && !cartridge.isInRepair ||
                              !cartridge.isDeleted)
                            IconButton(
                              tooltip: 'Удалить',
                              onPressed: () async {
                                await context
                                    .read<CartridgeCubit>()
                                    .deleteCartridge(cartridge.id)
                                    .then((value) => context
                                        .read<CartridgeCubit>()
                                        .loadAllCartridges(
                                            isDeleted: state.viewIsDeleted));
                              },
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cartridge_cubit/cartridge_cubit.dart';
import 'dialogs/add_cartridge_dialog.dart';

class CartridgeWidget extends StatelessWidget {
  const CartridgeWidget({super.key, required this.cartridge});

  final Cartridge cartridge;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text('Модель:'),
                  Text(
                    cartridge.model,
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Text('Инв. номер:'),
                Text(
                  cartridge.inventoryNumber ?? '-',
                  style: const TextStyle(fontSize: 25),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            BlocBuilder<CartridgeCubit, CartridgeState>(
              builder: (context, state) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        CartridgeDialogs.openDialog(
                          context: context,
                          cartridgeCubit: context.read<CartridgeCubit>(),
                          cartridge: cartridge,
                        );
                      },
                      icon: const Icon(Icons.edit_note),
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        context.read<CartridgeCubit>()
                          ..deleteCartridge(cartridge.id)
                          ..loadAllCartridges();
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
    );
  }
}

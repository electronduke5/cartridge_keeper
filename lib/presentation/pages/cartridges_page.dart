import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/cartridge_widget.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/add_cartridge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cartridge.dart';
import '../cubits/model_state.dart';

class CartridgesPage extends StatelessWidget {
  const CartridgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Картриджи',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: BlocBuilder<CartridgeCubit, CartridgeState>(
                        builder: (context, state) => TextField(
                          decoration: const InputDecoration(
                            hintText: 'Инв. №',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            context
                                .read<CartridgeCubit>()
                                .searchCartridge(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text('Фильтрация\nпо модели'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CartridgeCubit, CartridgeState>(
              builder: (context, state) {
                switch (state.getCartridgesState) {
                  case IdleState<List<Cartridge>> _:
                    return const Center(child: CircularProgressIndicator());
                  case LoadingState<List<Cartridge>> _:
                    return const Center(child: CircularProgressIndicator());
                  case LoadedState<List<Cartridge>> _:
                    return SizedBox.expand(child: () {
                      if (state.getCartridgesState.item == null ||
                          state.getCartridgesState.item!.isEmpty) {
                        return const Center(child: Text('Картриджей нет'));
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final cartridge =
                                state.getCartridgesState.item![index];
                            return CartridgeWidget(cartridge: cartridge);
                          },
                          itemCount: state.getCartridgesState.item!.length,
                        );
                      }
                    }());

                  case FailedState<List<Cartridge>> _:
                    return Center(
                        child:
                            Text(state.getCartridgesState.message ?? 'Error'));
                  default:
                    return const Center(child: CircularProgressIndicator());
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
                  CartridgeDialogs.openDialog(
                      context: context,
                      cartridgeCubit: context.read<CartridgeCubit>());
                },
                icon: const Icon(Icons.add),
                label: const Text('Добавить'),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:cartridge_keeper/presentation/widgets/cartridge_widget.dart';
import 'package:cartridge_keeper/presentation/widgets/dialogs/add_cartridge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cartridge.dart';
import '../cubits/model_state.dart';
import '../widgets/cartridge_filter_dropdown.dart';

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Картриджи',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              BlocBuilder<CartridgeCubit, CartridgeState>(
                builder: (context, state) {
                  return Text(
                    '(${state.getCartridgesState.item?.length.toString() ?? '?'} шт.)',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              const Spacer(),
              const CartridgeFilterDropdown(),
              const SizedBox(width: 20),
              IntrinsicWidth(
                child: BlocBuilder<CartridgeCubit, CartridgeState>(
                  builder: (context, state) => TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(5)],
                    decoration: const InputDecoration(
                      hintText: 'Поиск...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      context.read<CartridgeCubit>().searchCartridge(value,
                          isDeleted: state.viewIsDeleted);
                    },
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
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
                            state.getCartridgesState.item!
                                .sort((a, b) => a.model.compareTo(b.model));
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

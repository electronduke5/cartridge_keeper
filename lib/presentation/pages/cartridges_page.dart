import 'package:cartridge_keeper/presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cartridge.dart';
import '../cubits/model_state.dart';

class CartridgesPage extends StatelessWidget {
  const CartridgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: BlocBuilder<CartridgeCubit, CartridgeState>(
            builder: (context, state) {
              debugPrint('cartridges state: ${state.getCartridgesState}');

              switch (state.getCartridgesState) {
                case IdleState<List<Cartridge>> _:
                  return const Center(child: CircularProgressIndicator());
                case LoadingState<List<Cartridge>> _:
                  return const Center(child: CircularProgressIndicator());
                case LoadedState<List<Cartridge>> _:
                  return Padding(
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
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ID'),
                                  Text('Марка'),
                                  Text('Модель'),
                                  Text('Инв №'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox.expand(child: () {
                            if (state.getCartridgesState.item == null ||
                                state.getCartridgesState.item!.isEmpty) {
                              return const Center(
                                  child: Text('Картриджей нет'));
                            } else {
                              return SingleChildScrollView(
                                child: DataTable(
                                  clipBehavior: Clip.antiAlias,
                                  border: TableBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  headingRowColor: const WidgetStatePropertyAll(
                                      Color(0xFF323D4E)),
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Марка')),
                                    DataColumn(label: Text('Модель')),
                                    DataColumn(label: Text('Инв №')),
                                  ],
                                  rows: state.getCartridgesState.item!
                                      .map(
                                        (cartridge) => DataRow(
                                          color: const WidgetStatePropertyAll(
                                              Color(0xFF273142)),
                                          cells: [
                                            DataCell(
                                                Text(cartridge.id.toString())),
                                            DataCell(Text(
                                                cartridge.mark ?? 'No mark')),
                                            DataCell(Text(cartridge.model)),
                                            DataCell(Text(
                                                cartridge.inventoryNumber ??
                                                    'No inventory number')),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }
                          }()),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {

                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Добавить'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                case FailedState<List<Cartridge>> _:
                  return Center(
                      child: Text(state.getCartridgesState.message ?? 'Error'));
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    ));
  }
}

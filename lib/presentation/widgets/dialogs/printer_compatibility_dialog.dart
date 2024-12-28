import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/printer.dart';
import '../../cubits/cartridge_cubit/cartridge_cubit.dart';
import '../../states/compatibility_cartridges_provider.dart';
import '../cartidge_compatibiility_selectable_widget.dart';

class CompatibilityDialog {
  static final isAllSelectedProvider = StateProvider<bool>((ref) => false);

  static Future<void> show({
    required BuildContext context,
    required CartridgeCubit cartridgeCubit,
    required Printer printer,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: cartridgeCubit,
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Совместимость с картриджами'),
                Text(
                  '${printer.mark} ${printer.model}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            content: BlocBuilder<CartridgeCubit, CartridgeState>(
              builder: (context, state) {
                if (state.getCartridgesState.item == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.getCartridgesState.item!.isEmpty) {
                  return const Center(child: Text('Картриджей нет'));
                }
                final cartridgesList = state.getCartridgesState.item!
                    .map((cartridgeModel) => cartridgeModel.model)
                    .toList();
                cartridgesList.sort();
                Set<String> compatibleCartridges = cartridgesList.toSet();

                return Consumer(
                  builder: (context, ref, child) {
                    final uniqueCartridgeNames =
                        ref.watch(compatibilityCartridgesProvider);

                    bool isAllSelected = ref.watch(isAllSelectedProvider);

                    if (isAllSelected &&
                        uniqueCartridgeNames.length !=
                            compatibleCartridges.length) {
                      uniqueCartridgeNames.clear();
                      uniqueCartridgeNames.addAll(compatibleCartridges);
                    }
                    if (uniqueCartridgeNames.length ==
                        compatibleCartridges.length) {
                      isAllSelected = true;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref.read(isAllSelectedProvider.notifier).state =
                                    !isAllSelected;
                                ref
                                    .read(compatibilityCartridgesProvider
                                        .notifier)
                                    .toggleAll(uniqueCartridgeNames);
                              },
                              child: Card(
                                margin: const EdgeInsets.only(left: 0, top: 4),
                                color: isAllSelected
                                    ? const Color(0xFF4880FF)
                                    : const Color(0xFF273142),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Все картриджи',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //if (!isSelected)
                            for (final cartridgeName in compatibleCartridges)
                              CartridgeCompatibilitySelectableWidget(
                                cartridgeName: cartridgeName,
                                isAllSelectedProvider,
                              ),
                          ],
                        ),
                        if (uniqueCartridgeNames.isEmpty)
                          const Text(
                            'Выберите хотя бы один картридж.',
                            style: TextStyle(color: Colors.red),
                          ),
                        if (uniqueCartridgeNames.isNotEmpty)
                          Text(
                              'Выбрано ${uniqueCartridgeNames.length} картриджей.'),
                      ],
                    );
                  },
                );
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

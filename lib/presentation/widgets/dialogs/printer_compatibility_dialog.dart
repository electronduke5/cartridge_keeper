import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/printer.dart';
import '../../cubits/cartridge_cubit/cartridge_cubit.dart';
import '../../cubits/compatibility_cubit/compatibility_cubit.dart';
import '../../states/compatibility_cartridges_provider.dart';
import '../cartidge_compatibiility_selectable_widget.dart';
import '../snack_bar_info.dart';

class CompatibilityDialog {
  static Future<bool?> show({
    required BuildContext context,
    required CartridgeCubit cartridgeCubit,
    required CompatibilityCubit compatibilityCubit,
    required Printer printer,
  }) async {
    return showDialog<bool?>(
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

                    bool isAllSelected = uniqueCartridgeNames.length ==
                        compatibleCartridges.length;

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
                                ref
                                    .read(compatibilityCartridgesProvider
                                        .notifier)
                                    .toggleAll(compatibleCartridges);
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
                            for (final cartridgeName in compatibleCartridges)
                              CartridgeCompatibilitySelectableWidget(
                                cartridgeName: cartridgeName,
                              ),
                          ],
                        ),
                        Text('Выбрано: ${uniqueCartridgeNames.length} шт.'),
                      ],
                    );
                  },
                );
              },
            ),
            actions: <Widget>[
              Consumer(builder: (context, ref, _) {
                return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Отмена'));
              }),
              BlocProvider.value(
                value: compatibilityCubit,
                child: BlocBuilder<CompatibilityCubit, CompatibilityState>(
                  builder: (context, state) {
                    return Consumer(
                      builder: (context, ref, _) {
                        final uniqueCartridgeNames =
                            ref.watch(compatibilityCartridgesProvider);
                        return ElevatedButton(
                          onPressed: () {
                            if (uniqueCartridgeNames.isEmpty) {
                              SnackBarInfo.show(
                                context: context,
                                message:
                                    'Выберите хотя бы одну модель картриджа',
                                isSuccess: false,
                              );
                              return;
                            }

                            context
                                .read<CompatibilityCubit>()
                                .addCompatibilityList(
                                  printerId: printer.id!,
                                  cartridgeModels:
                                      uniqueCartridgeNames.toList(),
                                )
                                .then((_) {
                              SnackBarInfo.show(
                                context: context,
                                message:
                                    'Добавлена совместимость картриджа \'${uniqueCartridgeNames.toList().map((model) => model).join(', ')}\' с принтером \'${printer.mark} ${printer.model}\'',
                                isSuccess: true,
                              );
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              width: uniqueCartridgeNames.isEmpty ? 3 : 0,
                              color: uniqueCartridgeNames.isEmpty
                                  ? Colors.redAccent
                                  : const Color(0xFF4880FF),
                            ),
                          ),
                          child: const Text('OK'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
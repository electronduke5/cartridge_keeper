import 'package:cartridge_keeper/common/custom_input_formatter.dart';
import 'package:cartridge_keeper/data/models/cartridge.dart';
import 'package:cartridge_keeper/presentation/cubits/model_state.dart';
import 'package:cartridge_keeper/presentation/widgets/snack_bar_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cartridge_cubit/cartridge_cubit.dart';

class CartridgeDialogs {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static Future openDialog({
    required BuildContext context,
    Cartridge? cartridge,
    required CartridgeCubit cartridgeCubit,
  }) {
    TextEditingController modelController =
        TextEditingController(text: cartridge?.model);
    TextEditingController inventoryNumberController =
        TextEditingController(text: cartridge?.inventoryNumber);

    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: cartridgeCubit,
          child: BlocListener<CartridgeCubit, CartridgeState>(
            listener: (context, state) {
              if (state.createCartridgeState is LoadedState<Cartridge>) {
                SnackBarInfo.show(
                    context: context,
                    message:
                        'Картридж ${state.createCartridgeState.item?.mark ?? ''} добавлен!',
                    isSuccess: true);
              } else if (state.createCartridgeState is FailedState<Cartridge>) {
                SnackBarInfo.show(
                    context: context,
                    message: '${state.createCartridgeState.message}',
                    isSuccess: false);
              }
            },
            child: AlertDialog(
              title: Text(cartridge == null
                  ? 'Добавить картридж'
                  : 'Изменить картридж'),
              content: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 10, bottom: 5),
                    //   child: Text('Марка'),
                    // ),
                    // TextFormField(
                    //   initialValue: cartridge?.mark,
                    //   decoration: const InputDecoration(
                    //     hintText: 'HP',
                    //   ),
                    //   onChanged: (value) {
                    //     cartridgeCubit.changeMark(value);
                    //   },
                    // ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text('Модель'),
                    ),
                    TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(
                        hintText: '226X',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Модель не может быть пустой';
                        }
                        return null;
                      },
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text('Инвентарный номер'),
                    ),
                    TextFormField(
                      controller: inventoryNumberController,
                      decoration: const InputDecoration(
                        hintText: '17B',
                      ),
                      validator: (value) {
                        final searchingInv = cartridgeCubit
                            .state.getCartridgesState.item
                            ?.where(
                                (element) => element.inventoryNumber == value)
                            .firstOrNull;
                        if (searchingInv != null &&
                            searchingInv.inventoryNumber == value &&
                            value != cartridge?.inventoryNumber) {
                          return 'Такой картридж уже есть!';
                        }
                        return null;
                      },
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                BlocBuilder<CartridgeCubit, CartridgeState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        formKey.currentState!.save();
                        if (formKey.currentState!.validate()) {
                          if (cartridge == null) {
                            cartridgeCubit
                              ..addCartridge(
                                  model: modelController.text,
                                  inventoryNumber:
                                      inventoryNumberController.text)
                              ..loadAllCartridges();
                          } else {
                            cartridgeCubit
                              ..editCartridge(
                                id: cartridge.id,
                                model: modelController.text,
                                inventoryNumber:
                                    inventoryNumberController.text == ''
                                        ? null
                                        : inventoryNumberController.text,
                              )
                              ..loadAllCartridges();
                          }

                          formKey.currentState!.reset();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(cartridge == null ? 'Добавить' : 'Изменить'),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

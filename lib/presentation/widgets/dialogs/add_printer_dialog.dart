import 'package:cartridge_keeper/presentation/cubits/printer_cubit/printer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/printer.dart';

class PrinterDialogs {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static Future openDialog({
    required BuildContext context,
    Printer? printer,
    required PrinterCubit printerCubit,
  }) {
    TextEditingController markController =
        TextEditingController(text: printer?.mark);
    TextEditingController modelController =
        TextEditingController(text: printer?.model);

    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: printerCubit,
          child: BlocListener<PrinterCubit, PrinterState>(
            listener: (context, state) {
              // if (state.createPrinterState is LoadedState<Printer>) {
              //   SnackBarInfo.show(
              //       context: context,
              //       message:
              //           'Принтер ${state.createPrinterState.item?.mark ?? ''} ${state.createPrinterState.item?.model ?? ''} добавлен!',
              //       isSuccess: true);
              // } else if (state.createPrinterState is FailedState<Printer>) {
              //   SnackBarInfo.show(
              //       context: context,
              //       message: '${state.createPrinterState.message}',
              //       isSuccess: false);
              // }
            },
            child: AlertDialog(
              title: Text(
                  printer == null ? 'Добавить принтер' : 'Изменить принтер'),
              content: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text('Бренд'),
                    ),
                    TextFormField(
                      controller: markController,
                      decoration: const InputDecoration(
                        hintText: 'HP',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Обязательное поле';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text('Модель'),
                    ),
                    TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(
                        hintText: 'M404dn',
                      ),
                      validator: (value) {
                        final searchingModel = printerCubit
                            .state.getPrintersState.item
                            ?.where((element) => element.model == value)
                            .firstOrNull;
                        if (searchingModel != null &&
                            searchingModel.model == value &&
                            value != printer?.model) {
                          return 'Такой принтер уже есть!';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
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
                BlocBuilder<PrinterCubit, PrinterState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        formKey.currentState!.save();
                        if (formKey.currentState!.validate()) {
                          if (printer == null) {
                            printerCubit
                              ..addPrinter(
                                  markController.text, modelController.text)
                              ..loadAllPrinters();
                          } else {
                            printerCubit
                              ..editPrinter(
                                printer.id!,
                                markController.text,
                                modelController.text,
                              )
                              ..loadAllPrinters();
                          }

                          formKey.currentState!.reset();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(printer == null ? 'Добавить' : 'Изменить'),
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

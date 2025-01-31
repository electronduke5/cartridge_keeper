import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/presentation/cubits/office_cubit/office_cubit.dart';
import 'package:cartridge_keeper/presentation/cubits/repair_cubit/repair_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cartridge.dart';
import '../../data/models/office.dart';
import '../../data/models/printer.dart';
import '../../data/models/repair.dart';
import '../cubits/model_state.dart';
import '../widgets/repair_card_widget.dart';
import '../widgets/replacement_cartridge_widget.dart';

class CartridgeInfoPage extends StatelessWidget {
  const CartridgeInfoPage(
      {super.key,
      required this.cartridge,
      required this.compatibilityPrinters});

  final Cartridge cartridge;
  final List<Printer>? compatibilityPrinters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Подробная информация о картридже № ${cartridge.id} (${cartridge.model})',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                children: [
                  buildCartridgeInfoCard(),
                  buildCompatibilityPrintersInfoCard(),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  buildRepairHistory(),
                  const VerticalDivider(thickness: 2),
                  buildReplacementHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildReplacementHistory() {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'История замен',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BlocBuilder<OfficeCubit, OfficeState>(
                builder: (context, state) {
              switch (state.getOfficesState) {
                case IdleState<List<Office>> _:
                  return const Center(child: Text('IdleState'));
                case LoadingState<List<Office>> _:
                  return const Center(child: CircularProgressIndicator());
                case FailedState<List<Office>> _:
                  return Center(
                    child: Text(state.getOfficesState.message ?? 'Ошибка'),
                  );
                case LoadedState<List<Office>> _:
                  return SizedBox.expand(
                    child: () {
                      if (state.getOfficesState.item == null ||
                          state.getOfficesState.item!.isEmpty) {
                        return const Center(
                          child: Text(
                            'Картридж ещё не был заменен',
                          ),
                        );
                      } else {
                        final List<Office> listOffices =
                            state.getOfficesState.item!;
                        listOffices.sort(
                          (a, b) => b.replacementDate.parseLocalDate
                              .compareTo(a.replacementDate.parseLocalDate),
                        );

                        return ListView.builder(
                          itemCount: listOffices.length,
                          itemBuilder: (context, index) {
                            final office = listOffices[index];
                            return ReplacementCartridgeWidget(
                              office: office,
                              isShowActionButtons: false,
                            );
                          },
                        );
                      }
                    }(),
                  );
                default:
                  return const Center(child: Text('Default'));
              }
            }),
          ),
        ],
      ),
    );
  }

  Expanded buildRepairHistory() {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'История ремонтов',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BlocBuilder<RepairCubit, RepairState>(
                builder: (context, state) {
              switch (state.getRepairsState) {
                case IdleState<List<Repair>> _:
                  return const Center(child: Text('IdleState'));
                case LoadingState<List<Repair>> _:
                  return const Center(child: CircularProgressIndicator());
                case LoadedState<List<Repair>> _:
                  return SizedBox.expand(
                    child: () {
                      if (state.getRepairsState.item == null ||
                          state.getRepairsState.item!.isEmpty) {
                        return const Center(
                          child: Text(
                            'Ещё ни один картридж не был отремонтирован',
                          ),
                        );
                      } else {
                        final List<Repair> listRepairs =
                            state.getRepairsState.item!;

                        listRepairs.sort(
                          (a, b) => b.startDate.parseLocalDate
                              .compareTo(a.startDate.parseLocalDate),
                        );
                        return ListView.builder(
                          itemCount: listRepairs.length,
                          itemBuilder: (context, index) {
                            final repair = listRepairs[index];
                            return RepairCardWidget(
                              repair: repair,
                              isShowActionButtons: false,
                            );
                          },
                        );
                      }
                    }(),
                  );
                case FailedState<List<Repair>> _:
                  return Center(
                    child: Text(state.getRepairsState.message ?? 'Error1'),
                  );
                default:
                  return const Center(child: Text('Error'));
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget buildCompatibilityPrintersInfoCard() {
    return () {
      if (compatibilityPrinters != null && compatibilityPrinters!.isNotEmpty) {
        return Card(
          margin: EdgeInsets.zero,
          child: SizedBox(
            height: 165,
            width: 430,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Совместим с ${compatibilityPrinters!.length} принтерами:',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildPrinterColumns(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    }();
  }

  List<Widget> _buildPrinterColumns() {
    final int compatibilityPrintersLength = compatibilityPrinters!.length;
    final int maxColumnLength = (compatibilityPrintersLength / 2).ceil();
    const int countOfColumns = 2;

    List<Widget> columns = [];
    for (int i = 0; i < countOfColumns; i++) {
      columns.add(
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: compatibilityPrinters!
                .skip(i * maxColumnLength)
                .take(maxColumnLength)
                .map((printer) => Text(
                      '${printer.mark} ${printer.model}',
                      style: const TextStyle(
                        color: Color(0xFF4880FF),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    }
    return columns;
  }

  Card buildCartridgeInfoCard() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IntrinsicWidth(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Text('Инв. номер:'),
                      Text(
                        cartridge.inventoryNumber ?? '-',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      const Text('Модель:'),
                      Text(
                        cartridge.model,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'В ремонте: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    cartridge.isInRepair ? 'Да' : 'Нет',
                    style: TextStyle(
                      fontSize: 20,
                      color: cartridge.isInRepair ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'В принтере: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    cartridge.isReplaced ? 'Да' : 'Нет',
                    style: TextStyle(
                      fontSize: 20,
                      color: cartridge.isReplaced
                          ? Colors.orangeAccent
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Удалён: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    cartridge.isDeleted ? 'Да' : 'Нет',
                    style: TextStyle(
                      fontSize: 20,
                      color: cartridge.isDeleted ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/office.dart';
import '../cubits/cartridge_cubit/cartridge_cubit.dart';
import '../cubits/office_cubit/office_cubit.dart';

class ReplacementCartridgeWidget extends StatelessWidget {
  const ReplacementCartridgeWidget({super.key, required this.office});

  final Office office;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 5, left: 0, top: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  office.department.name,
                  style: const TextStyle(fontSize: 15),
                ),
                BlocBuilder<OfficeCubit, OfficeState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        context.read<OfficeCubit>()
                          ..deleteOffice(office.id)
                          ..loadAllOffices();
                        context
                            .read<CartridgeCubit>()
                            .returnFromReplacement(office.cartridge.id);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 1,
                width: double.maxFinite,
                color: Colors.grey,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 5.0,
              spacing: MediaQuery.of(context).size.width * 0.02,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Инв. номер:'),
                    Text(
                      office.cartridge.inventoryNumber.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Модель:'),
                    Text(
                      office.cartridge.model.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Номер кабинета:'),
                    Text(
                      office.officeNumber ?? 'Не указан',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.grey,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  office.replacementDate.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

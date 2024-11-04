import 'package:flutter/material.dart';

import '../../data/models/office.dart';

class ReplacementCartridgeWidget extends StatelessWidget {
  const ReplacementCartridgeWidget({super.key, required this.office});

  final Office office;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Кабинет №${office.officeNumber}'),
      subtitle: Text('Дата замены: ${office.replacementDate}'),
      trailing: Text('Картридж: ${office.cartridge.inventoryNumber}'),
    );
  }
}

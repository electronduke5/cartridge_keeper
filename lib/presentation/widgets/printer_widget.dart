import 'package:flutter/material.dart';

import '../../data/models/printer.dart';

class PrinterWidget extends StatelessWidget {
  const PrinterWidget({super.key, required this.printer});

  final Printer printer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(printer.mark),
          Text(printer.model),
          Text('id: ${printer.id}'),
        ],
      ),
    );
  }
}

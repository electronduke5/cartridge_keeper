import 'package:cartridge_keeper/presentation/widgets/printer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../data/models/printer.dart';

class PrintersLayoutGrid extends StatelessWidget {
  const PrintersLayoutGrid({
    super.key,
    required this.printers,
    required this.crossAxisCount,
  }) : assert(crossAxisCount >= 1 || crossAxisCount <= 5);

  final int crossAxisCount;
  final List<Printer> printers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LayoutGrid(
            columnSizes: crossAxisCount == 4
                ? [
                    1.fr,
                    1.fr,
                    1.fr,
                    1.fr,
                  ]
                : crossAxisCount == 2
                    ? [1.fr, 1.fr]
                    : [1.fr],
            rowSizes: [
              for (int i = 0; i < printers.length; i++) auto,
            ],
            rowGap: 10,
            columnGap: 5,
            children: [
              for (final printer in printers)
                PrinterWidget(
                  printer: printer,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:cartridge_keeper/data/models/office.dart';
import 'package:cartridge_keeper/presentation/widgets/replacement_cartridge_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class ReplacementCartridgeLayoutGrid extends StatelessWidget {
  const ReplacementCartridgeLayoutGrid(
      {super.key, required this.crossAxisCount, required this.items})
      : assert(crossAxisCount >= 1 || crossAxisCount <= 3);

  final int crossAxisCount;
  final List<Office> items;

  @override
  Widget build(BuildContext context) {
    return () {
      for (int i = 0; i < items.length;) {
        final groupedItems = <String, List<Office>>{};
        for (final item in items) {
          final date = item.replacementDate;
          if (groupedItems.containsKey(date)) {
            groupedItems[date]!.add(item);
          } else {
            groupedItems[date] = [item];
          }
        }
        return SingleChildScrollView(
          child: Column(
            children: groupedItems.entries.map((entry) {
              final date = entry.key;
              final offices = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  LayoutGrid(
                    columnSizes: crossAxisCount == 3
                        ? [1.fr, 1.fr, 1.fr]
                        : crossAxisCount == 2
                            ? [1.fr, 1.fr]
                            : [1.fr],
                    rowSizes: [
                      for (int i = 0; i < offices.length; i++) auto,
                    ],
                    rowGap: 10,
                    columnGap: 5,
                    children: [
                      for (final office in offices)
                        ReplacementCartridgeWidget(office: office),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        );
      }
      return const SizedBox();
    }();
  }
}

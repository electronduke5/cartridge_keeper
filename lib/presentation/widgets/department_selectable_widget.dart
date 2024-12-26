import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/department.dart';
import '../states/department_set_state.dart';

class DepartmentSelectableWidget extends ConsumerStatefulWidget {
  const DepartmentSelectableWidget(
    this.isAllSelectedProvider, {
    super.key,
    required this.department,
  });

  final Department department;

  final StateProvider isAllSelectedProvider;

  @override
  ConsumerState<DepartmentSelectableWidget> createState() =>
      _DepartmentSelectableWidgetState();
}

class _DepartmentSelectableWidgetState
    extends ConsumerState<DepartmentSelectableWidget> {
  @override
  Widget build(BuildContext context) {
    final listDepartments = ref.watch(departmentSetProvider);
    final isAllSelected = ref.watch(widget.isAllSelectedProvider);

    bool isSelected = false;
    setState(() {
      isSelected = listDepartments
          .map((e) => e.id)
          .toList()
          .contains(widget.department.id);
    });

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isAllSelected) {
            ref.read(widget.isAllSelectedProvider.notifier).state = false;
          }
          ref
              .read(departmentSetProvider.notifier)
              .toggleItem(widget.department);

          isSelected = listDepartments
              .map((e) => e.id)
              .toList()
              .contains(widget.department.id);
        });
      },
      child: Card(
        color: isSelected ? const Color(0xFF4880FF) : const Color(0xFF273142),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Icon(
                isSelected ? Icons.check : Icons.add,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                widget.department.name,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/department.dart';
import '../cubits/office_cubit/office_cubit.dart';

class DepartmentFilterDropdown extends StatefulWidget {
  const DepartmentFilterDropdown({super.key, required this.departments});

  final List<Department> departments;

  @override
  State<DepartmentFilterDropdown> createState() =>
      _DepartmentFilterDropdownState();
}

class _DepartmentFilterDropdownState extends State<DepartmentFilterDropdown> {
  Department? _selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          DropdownButton<Department>(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            items: widget.departments.map((department) {
              return DropdownMenuItem<Department>(
                value: department,
                child: Text(department.name),
              );
            }).toList(),
            hint: const Text('Выберите филиал...'),
            value: _selectedDepartment,
            onChanged: (Department? department) {
              setState(() {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectedDepartment = department ?? _selectedDepartment;
                context.read<OfficeCubit>().filterByDepartment(department!.id);
              });
            },
          ),
          IconButton(
            color: Colors.redAccent,
            onPressed: () {
              setState(() {
                _selectedDepartment = null;
                context.read<OfficeCubit>().loadAllOffices();
              });
            },
            icon: const Icon(
              Icons.clear,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cartridge_cubit/cartridge_cubit.dart';

class CartridgeFilterDropdown extends StatefulWidget {
  const CartridgeFilterDropdown({
    super.key,
  });

  @override
  State<CartridgeFilterDropdown> createState() =>
      _CartridgeFilterDropdownState();
}

class _CartridgeFilterDropdownState extends State<CartridgeFilterDropdown> {
  final List<(String, int)> _itemsList = [
    ('Удаленные картриджи', 1),
    ('В принтере', 2),
    ('В ремонте', 3),
    ('Свободные', 4),
    ('Все', 5)
  ];
  (String, int)? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartridgeCubit, CartridgeState>(
      builder: (context, state) {
        return DropdownButton<(String, int)>(
          items: _itemsList
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.$1),
                  ))
              .toList(),
          value: _selectedItem,
          hint: const Text('Фильтр'),
          onChanged: (value) {
            setState(() {
              _selectedItem = value;

              switch (value!.$2) {
                case 1:
                  context.read<CartridgeCubit>()
                    ..changeDeletedCartridgesVisibility(isDeleted: true)
                    ..loadAllCartridges(
                      isDeleted: true,
                    );
                  break;
                case 2:
                  context.read<CartridgeCubit>()
                    ..changeReplacementCartridgesVisibility(isReplacement: true)
                    ..loadAllCartridges(
                      isDeleted: false,
                      isRepaired: false,
                      isReplaced: true,
                    );
                  break;
                case 3:
                  context.read<CartridgeCubit>()
                    ..changeRepairedCartridgesVisibility(isRepaired: true)
                    ..loadAllCartridges(
                      isDeleted: false,
                      isReplaced: false,
                      isRepaired: true,
                    );
                  break;
                case 4:
                  context.read<CartridgeCubit>().loadAllCartridges(
                      isDeleted: false, isReplaced: false, isRepaired: false);
                  break;
                case 5:
                  context.read<CartridgeCubit>().loadAllCartridges();
                  break;
              }
            });
          },
        );
      },
    );
  }
}

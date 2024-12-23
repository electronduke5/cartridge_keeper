import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/custom_input_formatter.dart';
import '../../data/models/cartridge.dart';
import '../cubits/office_cubit/office_cubit.dart';
import '../cubits/repair_cubit/repair_cubit.dart';

class CartridgesDropdown extends StatelessWidget {
  CartridgesDropdown({
    super.key,
    required this.cartridges,
    this.officeCubit,
    this.repairCubit,
  });

  final List<Cartridge> cartridges;
  final OfficeCubit? officeCubit;
  final RepairCubit? repairCubit;

  final TextEditingController _searchController = TextEditingController();

  getData(String filter) {
    return cartridges
        .where(
          (cartridge) =>
              cartridge.inventoryNumber!.contains(filter) ||
              cartridge.model.contains(filter),
        )
        .map((e) => (e.inventoryNumber.toString(), e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<(String, Cartridge)>(
      validator: (value) {
        if (value == null) {
          return 'Выберите картридж';
        }
        return null;
      },
      items: (filter, s) => [...getData(filter)],
      popupProps: PopupProps.menu(
        showSearchBox: true,
        menuProps: MenuProps(
          barrierColor: Colors.black.withValues(alpha: 0.5),
          backgroundColor: Theme.of(context).cardTheme.color,
        ),
        searchFieldProps: TextFieldProps(
          inputFormatters: [
            LengthLimitingTextInputFormatter(5),
            UpperCaseTextFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'Поиск...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () => _searchController.clear(),
              icon: const Icon(Icons.clear),
            ),
          ),
          controller: _searchController,
        ),
        itemBuilder: (context, item, isDisabled, isSelected) {
          return ListTile(
            title: Text(
              'Инв. №: ${item.$2.inventoryNumber}\n${item.$2.model} ${item.$2.isReplaced ? '(в принтере)' : ''}',
              style: TextStyle(
                  color: item.$2.isReplaced
                      ? Colors.orangeAccent.withValues(alpha: 0.5)
                      : Colors.white),
            ),
          );
        },
      ),
      compareFn: (i, s) => i == s,
      onChanged: (cartridge) {
        if (officeCubit != null) {
          officeCubit!.changeCartridge(cartridge?.$2);
        } else if (repairCubit != null) {
          repairCubit!.changedCartridge(cartridge?.$2);
        }
      },
      dropdownBuilder: (context, selectedItem) {
        return Text(' Инв. № ${selectedItem?.$2.inventoryNumber ?? '-'}');
      },
    );
  }
}

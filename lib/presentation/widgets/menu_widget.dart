import 'package:cartridge_keeper/core/navigation_service.dart';
import 'package:cartridge_keeper/presentation/cubits/menu_cubit/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/menu_items.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      color: const Color(0xFF273142),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Cartridge Keeper',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Expanded(
            child: BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: MenuItem.menuItems.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          width: 5,
                          height: 45,
                          decoration: BoxDecoration(
                            color: state.selectedIndex == index
                                ? const Color(0xFF4880FF)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(MenuItem.menuItems[index].title),
                              leading: Icon(MenuItem.menuItems[index].icon),
                              selected: state.selectedIndex == index,
                              onTap: () {
                                context.read<MenuCubit>().changeIndex(index);
                                NavigationService.navigateTo(
                                  MenuItem.menuItems[index].route,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

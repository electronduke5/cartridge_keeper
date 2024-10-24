import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/menu_items.dart';
import '../../core/navigation_service.dart';
import '../cubits/menu_cubit/menu_cubit.dart';

class MenuIconWidget extends StatefulWidget {
  const MenuIconWidget({super.key});

  @override
  State<MenuIconWidget> createState() => _MenuIconWidgetState();
}

class _MenuIconWidgetState extends State<MenuIconWidget> {

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
          Expanded(
            child: BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: MenuItem.menuItems.length,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Container(
                          width: 5,
                          height: 55,
                          decoration: BoxDecoration(
                            color: state.selectedIndex == index
                                ? const Color(0xFF4880FF)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(MenuItem.menuItems[index].icon),
                          onPressed: () {
                            context.read<MenuCubit>().changeIndex(index);
                            NavigationService.navigateTo(MenuItem.menuItems[index].route);
                          },
                          iconSize: 25,
                          color: state.selectedIndex == index
                              ? const Color(0xFF4880FF)
                              : Colors.white,
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

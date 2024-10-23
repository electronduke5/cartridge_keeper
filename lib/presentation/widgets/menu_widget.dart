import 'package:cartridge_keeper/presentation/cubits/menu_cubit/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class ListItem {
  String title;
  IconData icon;
  Function onTap;

  ListItem({required this.title, required this.icon, required this.onTap});
}

class _MenuWidgetState extends State<MenuWidget> {
  List<ListItem> items = [
    ListItem(title: 'Принтеры', icon: Icons.print, onTap: () {}),
    ListItem(title: 'Картриджи', icon: Icons.receipt, onTap: () {}),
    ListItem(title: 'Кабинеты', icon: Icons.door_back_door, onTap: () {}),
    ListItem(title: 'Филиалы', icon: Icons.location_city, onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(00),
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
                  itemCount: items.length,
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
                              title: Text(items[index].title),
                              leading: Icon(items[index].icon),
                              selected: state.selectedIndex == index,
                              onTap: () {
                                context.read<MenuCubit>().changeIndex(index);
                                items[index].onTap();
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

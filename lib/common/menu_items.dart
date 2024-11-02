import 'package:flutter/material.dart';

class MenuItem {
  String title;
  IconData icon;
  String route;

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  static final List<MenuItem> menuItems = [
    MenuItem(title: 'Принтеры', icon: Icons.print, route: '/printers'),
    MenuItem(title: 'Картриджи', icon: Icons.receipt, route: '/cartridges'),
    MenuItem(title: 'Ремонты', icon: Icons.gpp_maybe_outlined, route: '/repairs'),
    MenuItem(title: 'Кабинеты', icon: Icons.door_back_door, route: '/cabinets'),
    MenuItem(title: 'Филиалы', icon: Icons.location_city, route: '/branches'),
  ];
}

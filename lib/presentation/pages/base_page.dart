import 'package:cartridge_keeper/presentation/widgets/menu_icon_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/menu_widget.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
              width: MediaQuery.sizeOf(context).width > 710 ? 180 : 60,
              child: MediaQuery.sizeOf(context).width > 710
                  ? MenuWidget()
                  : const MenuIconWidget()),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

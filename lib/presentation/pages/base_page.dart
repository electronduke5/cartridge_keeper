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
          const Flexible(
            flex: 1,
            child: MenuWidget(),
          ),
          Flexible(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}

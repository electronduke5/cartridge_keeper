import 'package:cartridge_keeper/presentation/cubits/printer_cubit/printer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubits/cartridge_cubit/cartridge_cubit.dart';
import '../presentation/pages/cartridges_page.dart';
import '../presentation/pages/printers_page.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/printers':
        return _getPageRoute(
            routeName: settings.name!,
            viewToShow: MultiBlocProvider(providers: [
              BlocProvider<PrinterCubit>(
                create: (_) => PrinterCubit()..loadAllPrinters(),
              ),
            ], child: const PrintersPage()));
      case '/cartridges':
        return _getPageRoute(
          routeName: settings.name!,
          viewToShow: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => CartridgeCubit()..loadAllCartridges()),
            ],
            child: const CartridgesPage(),
          ),
        );
      default:
        return _getPageRoute(
            routeName: settings.name!, viewToShow: const PrintersPage());
    }
  }

  static PageRoute _getPageRoute(
      {required String routeName, required Widget viewToShow}) {
    return PageRouteBuilder(pageBuilder: (_, __, ___) => viewToShow);
  }
}

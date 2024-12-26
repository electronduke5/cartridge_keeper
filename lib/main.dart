import 'dart:io';

import 'package:cartridge_keeper/core/navigation_service.dart';
import 'package:cartridge_keeper/presentation/cubits/menu_cubit/menu_cubit.dart';
import 'package:cartridge_keeper/presentation/cubits/printer_cubit/printer_cubit.dart';
import 'package:cartridge_keeper/presentation/di/app_module.dart';
import 'package:cartridge_keeper/presentation/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppModule().provideDependencies();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //set min size window
    WindowManager.instance.setMinimumSize(const Size(750, 500));
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartridge Keeper',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF4880FF).withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF4880FF).withValues(alpha: 0.2),
            ),
          ),
        ),
        fontFamily: GoogleFonts.rubik().fontFamily,
        primaryColorDark: const Color(0xFF4880FF),
        dialogTheme: DialogTheme(
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: const Color(0xFF273142),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF1B2431),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4880FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          selectedTileColor: Color(0xFF4880FF),
          selectedColor: Colors.white,
          tileColor: Color(0xFF273142),
        ),
        cardTheme: CardTheme(
          margin: const EdgeInsets.all(5),
          color: const Color(0xFF273142),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      theme: ThemeData(
        fontFamily: GoogleFonts.rubik().fontFamily,
        cardTheme: CardTheme(
          margin: const EdgeInsets.all(5),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        listTileTheme: ListTileThemeData(
          selectedTileColor: const Color(0xFF4880FF),
          selectedColor: Colors.white,
          tileColor: Theme.of(context).cardTheme.color,
        ),
        primaryColor: const Color(0xFF4880FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4880FF),
          primary: const Color(0xFF4880FF),
        ),
        dialogTheme: DialogTheme(
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        useMaterial3: true,
      ),
      initialRoute: '/cartridges',
      onGenerateRoute: (settings) => NavigationService.generateRoute(settings),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<MenuCubit>(
            create: (context) => MenuCubit(),
          ),
          BlocProvider<PrinterCubit>(
            create: (context) => PrinterCubit()..loadAllPrinters(),
          ),
        ],
        child: BasePage(child: child!),
      ),
    );
  }
}

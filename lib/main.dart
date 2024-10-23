import 'package:cartridge_keeper/presentation/cubits/menu_cubit/menu_cubit.dart';
import 'package:cartridge_keeper/presentation/cubits/printer_cubit/printer_cubit.dart';
import 'package:cartridge_keeper/presentation/di/app_module.dart';
import 'package:cartridge_keeper/presentation/pages/base_page.dart';
import 'package:cartridge_keeper/presentation/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppModule().provideDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartridge Keeper',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF4880FF),
        scaffoldBackgroundColor: const Color(0xFF1B2431),
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
        primaryColor: const Color(0xFF4880FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4880FF),
          primary: const Color(0xFF4880FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        useMaterial3: true,
      ),
      initialRoute: '/main-page',
      routes: {
        '/main-page': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<PrinterCubit>(
                    create: (context) => PrinterCubit()..loadAllPrinters()),
                BlocProvider<MenuCubit>(create: (context) => MenuCubit()),
              ],
              child: const StartPage(),
            ),
      },
      builder: (context, child) => BlocProvider<MenuCubit>(
        create: (context) => MenuCubit(),
        child: BasePage(child: child!),
      ),
    );
  }
}

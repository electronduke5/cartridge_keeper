import 'package:cartridge_keeper/data/repositories/department_repository_impl.dart';
import 'package:cartridge_keeper/domain/repositories/department_repository.dart';
import 'package:get_it/get_it.dart';

import '../../data/repositories/cartridge_repository_impl.dart';
import '../../data/repositories/compatibility_repository_impl.dart';
import '../../data/repositories/office_repository_impl.dart';
import '../../data/repositories/printer_inventory_repository_impl.dart';
import '../../data/repositories/printer_repository_impl.dart';
import '../../data/repositories/repair_repository_impl.dart';
import '../../domain/repositories/cartridge_repository.dart';
import '../../domain/repositories/compatibility_repository.dart';
import '../../domain/repositories/office_repository.dart';
import '../../domain/repositories/printer_inventory_repository.dart';
import '../../domain/repositories/printer_repository.dart';
import '../../domain/repositories/repair_repository.dart';

class AppModule{
  static bool _provided = false;

  void provideDependencies(){
    if(_provided) return;
    _provideDepartmentRepository();
    _providePrinterRepository();
    _provideCartridgeRepository();
    _providePrinterInventoryRepository();
    _provideCompatibilityRepository();
    _provideRepairRepository();
    _provideOfficeRepository();
    _provided = true;
  }

  void _provideDepartmentRepository(){
    GetIt.instance.registerSingleton(DepartmentRepositoryImpl());
  }

  static DepartmentRepository getDepartmentRepository() {
    return GetIt.instance.get<DepartmentRepositoryImpl>();
  }

  void _providePrinterRepository(){
    GetIt.instance.registerSingleton(PrinterRepositoryImpl());
  }

  static PrinterRepository getPrinterRepository() {
    return GetIt.instance.get<PrinterRepositoryImpl>();
  }

  void _provideCartridgeRepository(){
    GetIt.instance.registerSingleton(CartridgeRepositoryImpl());
  }

  static CartridgeRepository getCartridgeRepository() {
    return GetIt.instance.get<CartridgeRepositoryImpl>();
  }

  void _providePrinterInventoryRepository(){
    GetIt.instance.registerSingleton(PrinterInventoryRepositoryImpl());
  }

  static PrinterInventoryRepository getPrinterInventoryRepository() {
    return GetIt.instance.get<PrinterInventoryRepositoryImpl>();
  }

  void _provideCompatibilityRepository(){
    GetIt.instance.registerSingleton(CompatibilityRepositoryImpl());
  }

  static CompatibilityRepository getCompatibilityRepository() {
    return GetIt.instance.get<CompatibilityRepositoryImpl>();
  }

  void _provideRepairRepository(){
    GetIt.instance.registerSingleton(RepairRepositoryImpl());
  }

  static RepairRepository getRepairRepository() {
    return GetIt.instance.get<RepairRepositoryImpl>();
  }

  void _provideOfficeRepository(){
    GetIt.instance.registerSingleton(OfficeRepositoryImpl());
  }

  static  OfficeRepository getOfficeRepository() {
    return GetIt.instance.get<OfficeRepositoryImpl>();
  }
}
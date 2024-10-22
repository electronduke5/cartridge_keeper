import 'package:cartridge_keeper/data/models/compatibility.dart';

abstract class CompatibilityRepository{
  Future<List<Compatibility>> getAllCompatibility();

  Future<Compatibility> createCompatibility({required printerId, required cartridgeId});
}
import 'package:cartridge_keeper/common/database_create_request.dart';
import 'package:cartridge_keeper/core/db/database_service.dart';
import 'package:cartridge_keeper/data/models/compatibility.dart';

import '../../domain/repositories/compatibility_repository.dart';

class CompatibilityRepositoryImpl
    with DatabaseService<Compatibility>
    implements CompatibilityRepository {
  @override
  Future<Compatibility> createCompatibility(
      {required printerId, required cartridgeId}) {
    return createObject(
      fromMap: (Map<String, dynamic> json) => Compatibility.fromMap(json),
      table: DatabaseRequest.tableCompatibility,
      data:
          Compatibility(printerId: printerId, cartridgeId: cartridgeId).toMap(),
    );
  }

  @override
  Future<List<Compatibility>> getAllCompatibility() {
    return getAll(
      fromMap: (Map<String, dynamic> json) => Compatibility.fromMap(json),
      table: DatabaseRequest.tableCompatibility,
    );
  }
}

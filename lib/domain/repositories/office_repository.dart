import 'package:cartridge_keeper/data/models/office.dart';

abstract class OfficeRepository {
  Future<List<Office>> getAllOffices();

  Future<Office> createOffice({
    String officeNumber,
    required int departmentId,
    required int printerId,
  });

  Future<Office?> updateOffice({
    required int id,
    String officeNumber,
    required int departmentId,
    required int printerId,
  });
}

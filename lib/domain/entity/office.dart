class OfficeEntity {
  late int id;
  final String? officeNumber;
  final int departmentId;
  final int printerId;

  OfficeEntity({
    this.id = 0,
    this.officeNumber,
    required this.departmentId,
    required this.printerId,
  });
}

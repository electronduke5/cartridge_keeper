class PrinterEntity {
  late int id;
  final String mark;
  final String model;

  PrinterEntity({
    required this.mark,
    required this.model,
  });
}

enum PrinterEnum {
  hpM401dne(id: 1, mark: 'HP', model: 'LaserJet Pro M401dne'),
  hpM402dn(id: 2, mark: 'HP', model: 'LaserJet Pro M402dn'),
  hpM404dn(id: 3, mark: 'HP', model: 'LaserJet Pro M404dn'),
  hpM426dw(id: 4, mark: 'HP', model: 'LaserJet Pro M426dw'),
  hpM428dw(id: 5, mark: 'HP', model: 'LaserJet Pro M428dw'),
  hpM28a(id: 6, mark: 'HP', model: 'LaserJet Pro M28a'),
  hpM1132(id: 7, mark: 'HP', model: 'LaserJet Pro M1132'),
  hpM605(id: 8, mark: 'HP', model: 'LaserJet Enterprice M605'),
  hpP1102(id: 9, mark: 'HP', model: 'LaserJet P1102'),
  hpP1005(id: 10, mark: 'HP', model: 'LaserJet P1005'),
  hpP1006(id: 11, mark: 'HP', model: 'LaserJet P1006'),
  canon2900(id: 12, mark: 'Canon', model: 'LBP 2900'),
  canon3000(id: 13, mark: 'Canon', model: 'LBP 3000'),
  canon6000(id: 14, mark: 'Canon', model: 'LBP 6000'),
  canon663(id: 15, mark: 'Canon', model: 'LBP 663cdw'),
  canon6300(id: 16, mark: 'Canon', model: 'LBP 6300dn'),
  canonMF3010(id: 17, mark: 'Canon', model: 'MF3010'),
  canonMF4018(id: 18, mark: 'Canon', model: 'MF4018'),
  canonMF4450(id: 19, mark: 'Canon', model: 'MF4450'),
  canonMF641cw(id: 20, mark: 'Canon', model: 'MF641cw'),
  canon1133(id: 21, mark: 'Canon', model: 'ImageRunner 1133'),
  canonFC128(id: 22, mark: 'Canon', model: 'FC128'),
  panasonic1500(id: 23, mark: 'Panasonic', model: 'KX-MB1500'),
  epsonL120(id: 24, mark: 'Epson', model: 'L120'),
  epsonL800(id: 25, mark: 'Epson', model: 'L800'),
  epsonL805(id: 26, mark: 'Epson', model: 'L805'),
  epsonL3150(id: 27, mark: 'Epson', model: 'L3150'),
  kyoceraM2035dn(id: 28, mark: 'Kyocera', model: 'ECOSYS M2035dn'),
  kyoceraM2040dn(id: 29, mark: 'Kyocera', model: 'ECOSYS M2040dn'),
  kyoceraP3045dn(id: 30, mark: 'Kyocera', model: 'ECOSYS P3045dn'),
  kyoceraM22540dn(id: 31, mark: 'Kyocera', model: 'ECOSYS M22540dn');

  final int id;
  final String mark;
  final String model;

  const PrinterEnum({
    required this.id,
    required this.mark,
    required this.model,
  });
}

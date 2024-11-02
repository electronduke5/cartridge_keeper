import 'package:intl/intl.dart';

extension RusFormat on DateTime {
  String get toLocalFormat => DateFormat('dd.MM.yyyy').format(this);
}
extension RusParse on String {
  DateTime get parseLocalDate => DateFormat('dd.MM.yyyy').parse(this);
}
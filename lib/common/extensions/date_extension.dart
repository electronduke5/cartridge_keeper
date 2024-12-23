import 'package:intl/intl.dart';

import '../constants.dart';

extension RusFormat on DateTime {
  String get toLocalFormat => DateFormat('dd.MM.yyyy').format(this);
}

extension RusParse on String {
  DateTime get parseLocalDate => DateFormat('dd.MM.yyyy').parse(this);
}

extension FirstDayInCurrentMonth on DateTime {
  DateTime get firstDayInCurrentMonth => DateTime(year, month, 1);
}

extension LastDayInCurrentMonth on DateTime {
  DateTime get lastDayInCurrentMonth => DateTime(year, month + 1, 0);
}

extension GetPreviousMonth on DateTime {
  DateTime get previousMonth => DateTime(year, month - 1);
}

extension GetLastDayInPreviousMonth on DateTime {
  DateTime get lastDayInPreviousMonth => DateTime(year, month, 0);
}

extension LocaleMonthNames on DateTime {
  String get localeMonthName => monthNames[month - 1];
}

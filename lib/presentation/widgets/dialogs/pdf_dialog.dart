import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:cartridge_keeper/data/models/department.dart';
import 'package:cartridge_keeper/data/models/office.dart';
import 'package:cartridge_keeper/presentation/states/department_set_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/repair.dart';
import '../../cubits/office_cubit/office_cubit.dart';
import '../../cubits/repair_cubit/repair_cubit.dart';
import '../department_selectable_widget.dart';
import '../snack_bar_info.dart';

class PdfDialog {
  static GlobalKey<FormState> formRepairKey = GlobalKey<FormState>();
  static GlobalKey<FormState> formOfficeKey = GlobalKey<FormState>();
  static final TextEditingController _dateRepairController =
      TextEditingController();
  static final TextEditingController _dateOfficeController =
      TextEditingController();

  static openRepairPdfDialog({
    required BuildContext context,
    required DateTime initialDate,
    List<Repair>? items,
    required RepairCubit repairCubit,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: repairCubit,
          child: AlertDialog(
            title: const Text('Выберите период для отчета'),
            content: Form(
              key: formRepairKey,
              child: DateRangePickerColumn(
                  initialDate: initialDate,
                  dateController: _dateRepairController,
                  formKey: formRepairKey),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена')),
              BlocBuilder<RepairCubit, RepairState>(
                builder: (context, state) {
                  return ElevatedButton(
                      onPressed: () async {
                        if (!formRepairKey.currentState!.validate()) {
                          return;
                        }
                        if (items == null) {
                          SnackBarInfo.show(
                            context: context,
                            message: 'Нет данных для экспорта',
                            isSuccess: false,
                          );
                          return;
                        }
                        final DateTime firstDate = _dateRepairController.text
                            .split(' - ')[0]
                            .parseLocalDate;
                        final DateTime lastDate = _dateRepairController.text
                            .split(' - ')[1]
                            .parseLocalDate;
                        final itemsInPeriod = items.where((item) {
                          final DateTime startDate =
                              item.startDate.parseLocalDate;

                          return startDate.isAfter(firstDate) ||
                              startDate.isAtSameMomentAs(firstDate) &&
                                  startDate.isBefore(lastDate);
                        }).toList();

                        await context
                            .read<RepairCubit>()
                            .creatingPDF(
                              list: itemsInPeriod,
                              startDate: firstDate,
                              endDate: lastDate,
                            )
                            .then((_) {
                          _dateRepairController.clear();
                          Navigator.of(context).pop();
                        });
                      },
                      child: const Text('Экспорт'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static final isAllSelectedProvider = StateProvider<bool>((ref) => true);

  static openOfficePdfDialog({
    required BuildContext context,
    required DateTime initialDate,
    List<Office>? items,
    required OfficeCubit officeCubit,
    required List<Department> departments,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: officeCubit,
          child: AlertDialog(
            title: const Text('Выберите период для отчета'),
            content: Form(
              key: formOfficeKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateRangePickerColumn(
                      initialDate: initialDate,
                      dateController: _dateOfficeController,
                      formKey: formOfficeKey),
                  const SizedBox(height: 10),
                  const Text('Отдел'),
                  Consumer(
                    builder: (context, ref, _) {
                      final set = ref.watch(departmentSetProvider);
                      bool isAllSelected = ref.watch(isAllSelectedProvider);

                      if (isAllSelected && set.length != departments.length) {
                        set.clear();
                        set.addAll(departments);
                      }
                      if (set.length == departments.length) {
                        isAllSelected = true;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(isAllSelectedProvider.notifier)
                                      .state = !isAllSelected;
                                  ref
                                      .read(departmentSetProvider.notifier)
                                      .toggleAll(departments);
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.only(left: 0, top: 4),
                                  color: isAllSelected
                                      ? const Color(0xFF4880FF)
                                      : const Color(0xFF273142),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Все подразделения',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //if (!isSelected)
                              for (final department in departments)
                                DepartmentSelectableWidget(
                                  department: department,
                                  isAllSelectedProvider,
                                ),
                            ],
                          ),
                          if (set.isEmpty)
                            const Text(
                              'Выберите хотя бы одно подразделение',
                              style: TextStyle(color: Colors.red),
                            ),
                          if (set.isNotEmpty)
                            Text('Выбрано ${set.length} подразделений.'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена')),
              BlocBuilder<OfficeCubit, OfficeState>(
                builder: (context, state) {
                  return Consumer(builder: (context, ref, _) {
                    final set = ref.watch(departmentSetProvider);
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            width: set.isEmpty ? 3 : 0,
                            color: set.isEmpty
                                ? Colors.redAccent
                                : const Color(0xFF4880FF),
                          ),
                        ),
                        onPressed: () async {
                          if (!formOfficeKey.currentState!.validate()) {
                            return;
                          }
                          if (set.isEmpty) {
                            SnackBarInfo.show(
                              context: context,
                              message: 'Выберите хотя бы одно подразделение',
                              isSuccess: false,
                            );
                            return;
                          }
                          if (items == null) {
                            SnackBarInfo.show(
                              context: context,
                              message: 'Нет данных для экспорта',
                              isSuccess: false,
                            );
                            return;
                          }
                          final DateTime firstDate = _dateOfficeController.text
                              .split(' - ')[0]
                              .parseLocalDate;
                          final DateTime lastDate = _dateOfficeController.text
                              .split(' - ')[1]
                              .parseLocalDate;
                          var itemsInPeriod = items.where((item) {
                            final DateTime startDate =
                                item.replacementDate.parseLocalDate;

                            return startDate.isAfter(firstDate) ||
                                startDate.isAtSameMomentAs(firstDate) &&
                                    startDate.isBefore(lastDate);
                          }).toList();

                          itemsInPeriod = itemsInPeriod.where((item) {
                            return set
                                .map((e) => e.id)
                                .contains(item.department.id);
                          }).toList();

                          if (itemsInPeriod.isEmpty) {
                            SnackBarInfo.show(
                              context: context,
                              message: 'Нет данных для экспорта',
                              isSuccess: false,
                            );
                            return;
                          }
                          await context
                              .read<OfficeCubit>()
                              .createPDF(
                                list: itemsInPeriod,
                                startDate: firstDate,
                                endDate: lastDate,
                              )
                              .then((_) {
                            _dateOfficeController.clear();
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text('Экспорт'));
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class DateRangePickerColumn extends StatelessWidget {
  const DateRangePickerColumn({
    super.key,
    required TextEditingController dateController,
    required this.formKey,
    required this.initialDate,
  }) : _dateController = dateController;

  final TextEditingController _dateController;
  final GlobalKey<FormState> formKey;
  final DateTime initialDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5),
          child: Text('Период'),
        ),
        TextFormField(
          readOnly: true,
          controller: _dateController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Выберите период';
            }
            return null;
          },
          onTap: () async {
            final date = await showDateRangePicker(
              confirmText: 'Выбрать',
              cancelText: 'Отмена',
              fieldEndHintText: 'Конец периода',
              fieldStartHintText: 'Начало периода',
              saveText: 'Сохранить',
              helpText: 'Выберите период',
              barrierLabel: 'Выберите период',
              initialDateRange: DateTimeRange(
                start:
                    initialDate.isAfter(DateTime.now().firstDayInCurrentMonth)
                        ? initialDate
                        : DateTime.now().firstDayInCurrentMonth,
                end: DateTime.now(),
              ),
              context: context,
              firstDate: initialDate,
              lastDate: DateTime.now(),
            );

            if (date != null) {
              _dateController.text =
                  '${date.start.toLocalFormat} - ${date.end.toLocalFormat}';
            }
          },
          decoration: InputDecoration(
            hintText: 'дд.мм.гггг - дд.мм.гггг',
            suffixIcon: IconButton(
              onPressed: () {
                _dateController.clear();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                _dateController.text =
                    '${DateTime.now().previousMonth.toLocalFormat} - ${DateTime.now().lastDayInPreviousMonth.toLocalFormat}';
                formKey.currentState!.validate();
              },
              child: Text(DateTime.now().previousMonth.localeMonthName),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {
                _dateController.text =
                    '${DateTime.now().firstDayInCurrentMonth.toLocalFormat} - ${DateTime.now().lastDayInCurrentMonth.toLocalFormat}';

                formKey.currentState!.validate();
              },
              child: Text(DateTime.now().localeMonthName),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {
                _dateController.text =
                    '${initialDate.toLocalFormat} - ${DateTime.now().toLocalFormat}';

                formKey.currentState!.validate();
              },
              child: const Text('Всё время'),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:flutter/material.dart';

class EndDateFormField extends StatefulWidget {
  const EndDateFormField({
    super.key,
    required this.endDateController,
    required this.startDate,
    required this.validator,
  });

  final TextEditingController endDateController;
  final DateTime startDate;
  final FormFieldValidator<String>? validator;

  @override
  State<EndDateFormField> createState() => _EndDateFormFieldState();
}

class _EndDateFormFieldState extends State<EndDateFormField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        () {
          if (widget.endDateController.text.isEmpty) {
            return const SizedBox();
          }
          final endDate = widget.endDateController.text.parseLocalDate;
          if (endDate.isAfter(widget.startDate)) {
            return IconButton(
              onPressed: () {
                setState(() {
                  widget.endDateController.text = widget
                      .endDateController.text.parseLocalDate
                      .subtract(const Duration(days: 1))
                      .toLocalFormat;
                });
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            );
          } else {
            return const SizedBox();
          }
        }(),
        Expanded(
          child: TextFormField(
            validator: widget.validator,
            controller: widget.endDateController,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: widget.endDateController.text.parseLocalDate,
                firstDate: widget.startDate,
                lastDate: DateTime.now(),
              );
              widget.endDateController.text = date!.toLocalFormat;
            },
          ),
        ),
        () {
          if (widget.endDateController.text.isEmpty) {
            return const SizedBox();
          }
          final endDate = widget.endDateController.text.parseLocalDate;
          if (endDate
              .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
            return IconButton(
              onPressed: () {
                setState(() {
                  widget.endDateController.text = widget
                      .endDateController.text.parseLocalDate
                      .add(const Duration(days: 1))
                      .toLocalFormat;
                });
              },
              icon: const Icon(Icons.arrow_forward_ios),
            );
          } else {
            return const SizedBox();
          }
        }(),
        IconButton(
          tooltip: 'Очистить',
          onPressed: () {
            setState(() {
              widget.endDateController.clear();
            });
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

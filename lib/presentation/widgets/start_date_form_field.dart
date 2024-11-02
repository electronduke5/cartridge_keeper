import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:flutter/material.dart';

class StartDateFormField extends StatefulWidget {
  const StartDateFormField({
    super.key,
    required this.startDateController,
  });

  final TextEditingController startDateController;

  @override
  State<StartDateFormField> createState() => _StartDateFormFieldState();
}

class _StartDateFormFieldState extends State<StartDateFormField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              widget.startDateController.text = widget
                  .startDateController.text.parseLocalDate
                  .subtract(const Duration(days: 1))
                  .toLocalFormat;
            });
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        Expanded(
          child: TextFormField(
            controller: widget.startDateController,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              widget.startDateController.text = date!.toLocalFormat;
            },
          ),
        ),
        () {
          final startDate = widget.startDateController.text.parseLocalDate;
          if (startDate
              .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
            return IconButton(
              onPressed: () {
                setState(() {
                  widget.startDateController.text = widget
                      .startDateController.text.parseLocalDate
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
      ],
    );
  }
}
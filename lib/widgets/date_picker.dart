import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

final formatter = DateFormat.yMd();

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePicker({super.key, required this.onDateSelected});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  void _presentDayPicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
    widget.onDateSelected(pickedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _selectedDate == null
              ? ' No date selected'
              : formatter.format(_selectedDate!),
        ),
        IconButton(
          onPressed: _presentDayPicker,
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    );
  }
}

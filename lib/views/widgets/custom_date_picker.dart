import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_pallete.dart';

class CustomDatePicker extends StatefulWidget {
  final double width;
  final double height;
  final String labelText;
  final TextEditingController dateController;

  const CustomDatePicker({
    super.key,
    required this.width,
    required this.height,
    this.labelText = "",
    required this.dateController,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.02),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 10,
                  spreadRadius: 0.2)
            ],
            borderRadius: BorderRadius.circular(15),
            color: AppPalette.offWhite),
        child: Center(
          child: TextField(
            style: const TextStyle(color: AppPalette.primaryTextColor),
            controller: widget.dateController,
            readOnly: true,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey),
              labelText: widget.labelText.isNotEmpty ? widget.labelText : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.grey),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                    widget.dateController.text = formattedDate;
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:college_management/utils/string_utils.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_pallete.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final Function(String) onChanged;
  final double width;
  final double height;
  final String labelText;
  final String? selectedValue; // Selected value from the parent

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.width,
    required this.height,
    required this.labelText,
    this.selectedValue, // Selected value from the parent
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Set the initial value when the widget is created
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppPalette.offWhite,
              offset: Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 0.2,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          color: AppPalette.offWhite,
        ),
        child: Center(
          child: DropdownButton<String>(
            value: StringUtils.isEmptyString(selectedValue)?null:selectedValue,
            hint: Text(
              widget.labelText,
              style: const TextStyle(color: AppPalette.primaryTextColor),
            ),
            isExpanded: true,
            dropdownColor: Colors.white,
            underline: const SizedBox(), // Remove underline
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            items: widget.items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedValue = newValue;
                });
                widget.onChanged(newValue); // Notify parent widget
              }
            },
          ),
        ),
      ),
    );
  }
}
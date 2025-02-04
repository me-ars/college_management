import 'package:flutter/material.dart';

import '../../core/constants/app_pallete.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: AppPalette.violetLt,
                  offset: Offset(0, 2),
                  blurRadius: 10,
                  spreadRadius: 0.2)
            ],
            borderRadius: BorderRadius.circular(height * 0.4),
            color: AppPalette.violetLt),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            onPressed();
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/utils/string_utils.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final double width;
  final double height;
  final bool isPassword;
  final String labelText;
final TextEditingController textEditingController;
  const CustomTextField({
    super.key,
    required this.width,
    required this.height,
    required this.isPassword,
    this.labelText = "", required this.textEditingController,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.all(size.width*0.02),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: AppPalette.offWhite,
                  offset: Offset(0, 2),
                  blurRadius: 10,
                  spreadRadius: 0.2)
            ],
            borderRadius: BorderRadius.circular(15),
            color: AppPalette.offWhite),
        child: Center(
          child: TextField(
            style: const TextStyle(color: AppPalette.primaryTextColor),
            controller: widget.textEditingController,
            obscureText: widget.isPassword ? isObscured : false,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: AppPalette.secondaryTextColor),
              labelText: StringUtils.isEmptyString(widget.labelText)
                  ? null
                  : widget.labelText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off : Icons.visibility,
                        color: AppPalette.secondaryTextColor,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

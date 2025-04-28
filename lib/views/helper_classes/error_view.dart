import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class ErrorView {
  static showErrorView(
      {required BuildContext context, required Function retryMethod}) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppPalette.offWhite,
            borderRadius: BorderRadius.circular(15)),
        height: size.height / 2,
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset("assets/lottie_animations/error_animation.json"),
            const Text(
              "Something went wrong.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppPalette.primaryTextColor),
            ),
            CustomButton(
                label: "Retry",
                onPressed: () {
                  retryMethod();
                },
                width: size.width * 0.7,
                height: size.height * 0.08),
            CustomButton(
                label: "Return home",
                onPressed: () {
                 Navigator.pop(context);
                 if(Navigator.canPop(context)){
                   Navigator.pop(context);
                 }
                },
                width: size.width * 0.7,
                height: size.height * 0.08),

          ],
        ),
      ),
    );
  }
}

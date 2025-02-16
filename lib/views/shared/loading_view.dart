import 'package:college_management/core/constants/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  final double height;
  final double width;

  const LoadingView({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie_animations/book_loading.json",
              height: height, width: width),
          const Text(
            "Please wait while we load the data",
            style: TextStyle(color: AppPalette.primaryTextColor, fontSize: 15),
          )
        ],
      ),
    );
  }
}

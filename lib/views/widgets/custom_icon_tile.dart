import 'package:college_management/core/constants/app_pallete.dart';
import 'package:flutter/material.dart';
class CustomIconTile extends StatelessWidget {
  final double height;
  final double width;
  final Function onTap;
  final String iconImage;
  final String optionName;

  const CustomIconTile({
    super.key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.iconImage,
    required this.optionName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.all(width * 0.1),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppPalette.violetLt,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height / 2,
                width: width * 0.7,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(iconImage), fit: BoxFit.fill)),
              ),
              SizedBox(height: height / 6),
              SizedBox(
                width: width * 0.8, // Ensures the text fits within tile width
                child: Text(
                  optionName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  // Prevents wrapping to the next line
                  overflow: TextOverflow.ellipsis,
                  // Adds "..." if text is too long
                  style: const TextStyle(
                    color: AppPalette.secondaryTextColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

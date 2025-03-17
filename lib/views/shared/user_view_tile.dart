import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
class UserViewTile extends StatelessWidget {
  final String uid;
  final double width;
  final double height;
  final bool isStudent;
  final String name;
  final String course;
  final Function onTap;
  final Function onEdit;

  final bool canEdit;

  const UserViewTile({
    super.key,
    required this.width,
    required this.height,
    required this.isStudent,
    required this.name,
    required this.course,
    required this.uid,
    required this.onTap,
    required this.canEdit, required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(height * 0.1),
      child: Container(
        padding: EdgeInsets.all(width * 0.05),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppPalette.violetLt,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              uid,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes icons to the right
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: AppPalette.offWhite,
                              content: Container(
                                height: size.height / 4.7,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          color: AppPalette.primaryTextColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      uid,
                                      style: const TextStyle(
                                          color: AppPalette.primaryTextColor,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      course,
                                      style: const TextStyle(
                                          color: AppPalette.primaryTextColor,
                                          fontSize: 20),
                                    ),
                                    CustomButton(
                                      label: "Delete",
                                      onPressed: () {
                                        onTap();
                                      },
                                      width: width * 0.9,
                                      height: height * 0.4,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppPalette.offWhite,
                      ),
                    ),
                    if (canEdit) // ✅ Properly handling conditional visibility
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: AppPalette.offWhite,
                                content: Container(
                                  height: size.height / 4.7,
                                  width: size.width * 0.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                            color: AppPalette.primaryTextColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        uid,
                                        style: const TextStyle(
                                            color: AppPalette.primaryTextColor,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        course,
                                        style: const TextStyle(
                                            color: AppPalette.primaryTextColor,
                                            fontSize: 20),
                                      ),
                                      CustomButton(
                                        label: "Make HOD",
                                        onPressed: () {
                                          onEdit();
                                        },
                                        width: width * 0.9,
                                        height: height * 0.4,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppPalette.offWhite,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Text(
              course,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}



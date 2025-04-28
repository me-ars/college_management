import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/view_models/admin/faculty_view_model.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/shared/user_view_tile.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../app/base_view.dart';
import '../core/constants/app_pallete.dart';

class FacultyView extends StatefulWidget {
  const FacultyView({super.key});

  @override
  State<FacultyView> createState() => _FacultyViewState();
}

class _FacultyViewState extends State<FacultyView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<FacultyViewModel>(
        onModelReady: (FacultyViewModel model) {
          model.onModelReady();
        },
        refresh: (FacultyViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Faculty",
                style: TextStyle(color: AppPalette.offWhite),
              ),
              backgroundColor: AppPalette.violetDark,
            ),
            body: model.viewState == ViewState.ideal
                ? ListView.builder(
                    itemCount: model.faculty.length,
                    itemBuilder: (context, index) {
                      return UserViewTile(
                          onEdit: () {
                            showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Update sem",
                                    style: TextStyle(
                                        color: AppPalette
                                            .primaryTextColor),
                                  ),
                                  content:
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Employee ID: ${model.faculty[index].employeeId}',
                                          style: const TextStyle(
                                              color: AppPalette
                                                  .primaryTextColor),
                                        ),
                                        Text(
                                          'Name: ${model.faculty[index].firstName + model.faculty[index].lastName}',
                                          style: const TextStyle(
                                              color: AppPalette
                                                  .primaryTextColor),
                                        ),
                                        Text(
                                          'Subject: ${model.faculty[index].subject}',
                                          style: const TextStyle(
                                              color: AppPalette
                                                  .primaryTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    CustomButton(
                                      width: size.width * 0.8,
                                      height:
                                      size.height * 0.08,
                                      onPressed: () {
                                        model.assignAsHod(faculty: model.faculty[index]);
                                        Navigator.pop(
                                            context);
                                      },
                                      label: "Assign as HOD",
                                    ),
                                    CustomButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      label: "Cancel",
                                      width: size.width * 0.8,
                                      height:
                                      size.height * 0.08,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          canEdit: true,
                          onTap: () {
                            model.deleteUser(
                                uid: model.faculty[index].employeeId,
                                index: index);
                            Navigator.pop(context);
                          },
                          width: size.width * 0.65,
                          height: size.height * 0.15,
                          isStudent: false,
                          name: model.faculty[index].firstName +
                              model.faculty[index].lastName,
                          course: model.faculty[index].course,
                          uid: model.faculty[index].employeeId);
                    },
                  )
                : LoadingView(height: size.height / 4, width: size.width * 0.8),
          ));
        });
  }
}

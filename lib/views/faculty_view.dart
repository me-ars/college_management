import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/view_models/admin/faculty_view_model.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/shared/user_view_tile.dart';
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                model.add();
              },
            ),
            appBar: AppBar(
              title: const Text(
                "Faculty",
                style: TextStyle(color: AppPalette.offWhite),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: AppPalette.offWhite,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.sort,
                      color: AppPalette.offWhite,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.filter_alt,
                      color: AppPalette.offWhite,
                    ))
              ],
              backgroundColor: AppPalette.violetDark,
            ),
            body: model.viewState == ViewState.ideal
                ? ListView.builder(
                    itemCount: model.faculty.length,
                    itemBuilder: (context, index) {
                      return UserViewTile(
                          onEdit: () {
                            model.assignAsHod(faculty: model.faculty[index]);
                            Navigator.pop(context);
                          },
                          canEdit: true,
                          onTap: () {
                            model.deleteUser(
                                uid: model.faculty[index].employeeId,
                                index: index);
                            Navigator.of(context).pop();
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

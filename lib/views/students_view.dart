import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/shared/user_view_tile.dart';
import 'package:college_management/views/shared_view_models/students_view_model.dart';
import 'package:flutter/material.dart';
import '../app/base_view.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<StudentsViewModel>(
        onModelReady: (StudentsViewModel model) {
          model.onModelReady();
        },
        refresh: (StudentsViewModel model) {},
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
                "Students",
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
                    itemCount: model.students.length,
                    itemBuilder: (context, index) {
                      return UserViewTile(
                          onEdit: () {},
                          canEdit: false,
                          onTap: () {
                            model.deleteUser(
                                uid: model.students[index].studentId,
                                index: index);
                          },
                          width: size.width * 0.65,
                          height: size.height * 0.15,
                          isStudent: false,
                          name: model.students[index].firstName +
                              model.students[index].lastName,
                          course: model.students[index].course,
                          uid: model.students[index].studentId);
                    },
                  )
                : model.viewState == ViewState.empty
                    ? Center(child: const Text("nodata"))
                    : LoadingView(
                        height: size.height / 4.5, width: size.width * 0.8),
          ));
        });
  }
}

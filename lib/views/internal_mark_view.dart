import 'package:college_management/core/models/internal_mark_model.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../app/base_view.dart';
import '../core/constants/app_pallete.dart';
import '../core/enums/view_state.dart';
import '../core/models/student_internal_mark.dart';
import '../view_models/internal_marks_view_model.dart';

class InternalMarksView extends StatefulWidget {
  const InternalMarksView({super.key});

  @override
  State<InternalMarksView> createState() => _InternalMarksViewState();
}

TextEditingController _markController = TextEditingController();
TextEditingController _subjectController = TextEditingController();
TextEditingController _semFilterController = TextEditingController();
TextEditingController _courseController = TextEditingController();

class _InternalMarksViewState extends State<InternalMarksView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<InternalMarksViewModel>(
        onModelReady: (InternalMarksViewModel model) {
          _semFilterController.text = '2';
          _courseController.text = 'MCA';
          model.onModelReady(
              sem: _semFilterController.text, course: _courseController.text);
        },
        onDispose: (InternalMarksViewModel model){
          _markController.clear();
          _subjectController.clear();
          _semFilterController.clear();
          _courseController.clear();
        },
        refresh: (InternalMarksViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Internal Marks",
                style: TextStyle(color: AppPalette.offWhite),
              ),
              backgroundColor: AppPalette.violetDark,
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    CustomDropdown(
                        selectedValue: "MCA",
                        items: const ["MCA", "MBA"],
                        onChanged: (val) {
                          _semFilterController.text = val;
                        },
                        width: size.width / 4,
                        height: size.height * 0.08,
                        labelText: "Course"),
                    CustomDropdown(
                        selectedValue: "1",
                        items: const ["1", "2", "3", "4"],
                        onChanged: (val) {
                          _semFilterController.text = val;
                        },
                        width: size.width / 4,
                        height: size.height * 0.08,
                        labelText: "Sem"),
                    CustomButton(
                      label: "Apply",
                      onPressed: () {
                        model.onModelReady(
                            sem: _semFilterController.text,
                            course: _courseController.text);
                      },
                      width: size.width / 4,
                      height: size.height * 0.08,
                    )
                  ],
                ),
                model.viewState == ViewState.ideal
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: model.filteredStudents.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppPalette.violetLt,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    // Soft shadow
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset:
                                        const Offset(0, 3), // Shadow position
                                  ),
                                ],
                              ),
                              child: ListTile(
                                subtitle: Text(
                                  model.filteredStudents[index].studentId,
                                  style: const TextStyle(
                                      color: AppPalette.primaryTextColor),
                                ),
                                title: Text(
                                  "${model.filteredStudents[index].firstName} ${model.filteredStudents[index].lastName}",
                                  style: const TextStyle(
                                      color: AppPalette.primaryTextColor),
                                ),
                                trailing: SizedBox(
                                  width: size.width * 0.07,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Add internalMark",
                                                    style: TextStyle(
                                                        color: AppPalette
                                                            .primaryTextColor),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CustomTextField(
                                                            width: size.width *
                                                                0.8,
                                                            height:
                                                                size.height *
                                                                    0.08,
                                                            labelText:
                                                                "Subject",
                                                            isPassword: false,
                                                            textEditingController:
                                                                _subjectController),
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.03),
                                                        CustomTextField(
                                                          isPassword: false,
                                                          textEditingController:
                                                              _markController,
                                                          labelText: "Mark",
                                                          width:
                                                              size.width * 0.8,
                                                          height: size.height *
                                                              0.08,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
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
                                                    CustomButton(
                                                      width: size.width * 0.8,
                                                      height:
                                                          size.height * 0.08,
                                                      onPressed: () {
                                                        // Handle save action here (e.g., print or store values)
                                                        String subject =
                                                            _subjectController
                                                                .text;
                                                        String mark =
                                                            _markController
                                                                .text;
                                                        String sem =
                                                            _semFilterController
                                                                .text;

                                                        model.addInternalMark(
                                                            internalMark: InternalMark(
                                                                uid: sem +
                                                                    model
                                                                        .filteredStudents[
                                                                            index]
                                                                        .course +
                                                                    model
                                                                        .filteredStudents[
                                                                            index]
                                                                        .studentId,
                                                                studentId: model
                                                                    .filteredStudents[
                                                                        index]
                                                                    .studentId,
                                                                sem: sem,
                                                                subject:
                                                                    subject,
                                                                mark: mark,
                                                                course: model
                                                                    .filteredStudents[
                                                                        index]
                                                                    .course));
                                                        Navigator.pop(context);
                                                      },
                                                      label: "Save",
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.edit,
                                              color: AppPalette.whiteColor)),
                                      // Add icon color
                                      // Add icon color
                                    ],
                                  ),
                                ),
                                leading: GestureDetector(
                                    onTap: () {
                                      // Find the internal marks of the selected student
                                      StudentInternalMark? studentMarks = model.studentInternalMarks.firstWhere(
                                            (mark) => mark.studentId == model.filteredStudents[index].studentId,
                                        orElse: () => StudentInternalMark(studentId: "", internalMarks: []),
                                      );

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Internal Marks",
                                              style: TextStyle(color: AppPalette.primaryTextColor),
                                            ),
                                            content: studentMarks.internalMarks.isEmpty
                                                ? const Text(
                                              "No internal marks available.",
                                              style: TextStyle(color: AppPalette.primaryTextColor),
                                            )
                                                : SizedBox(
                                              width: size.width * 0.8,
                                              height: size.height * 0.4,
                                              child:ListView.builder(
                                                itemCount: studentMarks.internalMarks.length,
                                                itemBuilder: (context, markIndex) {
                                                  InternalMark mark = studentMarks.internalMarks[markIndex];
                                                  return Container(
                                                    width: size.width * 0.7,
                                                    height: size.height * 0.1, // Increased height to accommodate semester
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: AppPalette.offWhite,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Subject: ${mark.subject}",
                                                          style: const TextStyle(
                                                            color: AppPalette.primaryTextColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Mark: ${mark.mark}",
                                                          style: const TextStyle(
                                                            color: AppPalette.primaryTextColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Semester: ${mark.sem}",
                                                          style: const TextStyle(
                                                            color: AppPalette.primaryTextColor,
                                                            fontStyle: FontStyle.italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),

                                            ),
                                            actions: [
                                              CustomButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                label: "Close",
                                                width: size.width * 0.8,
                                                height: size.height * 0.08,
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },

                                  child: const Icon(Icons.menu,
                                      color: AppPalette.offWhite),
                                ), // Add icon color
                              ),
                            );
                          },
                        ),
                      )
                    : model.viewState == ViewState.empty
                        ? Padding(
                            padding: EdgeInsets.only(top: size.height / 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                    height: size.height * 0.1,
                                    width: size.width * 0.5,
                                    image: const AssetImage(
                                        "assets/icons/empty.png")),
                                const Text(
                                  "No students with applied filter",
                                  style: TextStyle(
                                      color: AppPalette.primaryTextColor),
                                )
                              ],
                            ),
                          )
                        : LoadingView(
                            height: size.height / 4.5, width: size.width * 0.8),
              ],
            ),
          ));
        });
  }
}

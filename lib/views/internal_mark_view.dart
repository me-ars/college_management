import 'package:college_management/core/models/internal_mark_model.dart';
import 'package:college_management/core/models/student_internal_mark.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../app/base_view.dart';
import '../core/constants/app_pallete.dart';
import '../core/enums/view_state.dart';
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
      refresh:(InternalMarksViewModel model) {} ,
        onModelReady: (InternalMarksViewModel model) {
          _semFilterController.text = '1';
          _courseController.text = 'MCA';
          model.onModelReady(
              sem: _semFilterController.text, course: _courseController.text);
        },
        onDispose: (InternalMarksViewModel model) {
          _markController.clear();
          _subjectController.clear();
          _semFilterController.clear();
          _courseController.clear();
        },
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Internal Marks",
                    style: TextStyle(color: AppPalette.offWhite)),
                backgroundColor: AppPalette.violetDark,
              ),
              body: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Course',
                            style: TextStyle(color: Colors.black),
                          ),
                          CustomDropdown(
                            selectedValue: "MCA",
                            items: const ["MCA", "MBA"],
                            onChanged: (val) {
                              _courseController.text = val;
                            },
                            width: size.width / 4,
                            height: size.height * 0.08,
                            labelText: "Course",
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Sem',
                            style: TextStyle(color: Colors.black),
                          ),
                          CustomDropdown(
                            selectedValue: "1",
                            items: const ["1", "2", "3", "4"],
                            onChanged: (val) {
                              _semFilterController.text = val;
                            },
                            width: size.width / 4,
                            height: size.height * 0.08,
                            labelText: "Sem",
                          ),
                        ],
                      ),
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
                        final student = model.filteredStudents[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppPalette.violetLt,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              "${student.firstName} ${student.lastName}",
                              style: const TextStyle(
                                  color: AppPalette.primaryTextColor),
                            ),
                            subtitle: Text(
                              student.studentId,
                              style: const TextStyle(
                                  color: AppPalette.primaryTextColor),
                            ),
                            leading: GestureDetector(
                              onTap: () {
                                final allmarks = model.studentInternalMarks.firstWhere(
                                      (element) => element.studentId == student.studentId,
                                  orElse: () => StudentInternalMark(studentId: student.studentId, internalMarks: []),
                                );

                                final internals = allmarks.internalMarks;

                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Internal Marks",
                                        style: TextStyle(color: AppPalette.primaryTextColor)),
                                    content: internals.isEmpty
                                        ? const Text(
                                      "No internal marks available.",
                                      style: TextStyle(color: AppPalette.primaryTextColor),
                                    )
                                        : SizedBox(
                                      height: size.height * 0.4,
                                      width: size.width * 0.8,
                                      child: ListView.builder(
                                        itemCount: internals.length,
                                        itemBuilder: (context, i) {
                                          final mark = internals[i];
                                          return Container(
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.only(bottom: 8),
                                            decoration: BoxDecoration(
                                              color: AppPalette.offWhite,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Subject: ${mark.subject}",
                                                    style: const TextStyle(color: AppPalette.primaryTextColor,
                                                        fontWeight: FontWeight.bold)),
                                                Text("Mark: ${mark.mark}",style: const TextStyle(color: AppPalette.primaryTextColor,)),
                                                Text("Semester: ${mark.sem}",style: const TextStyle(color: AppPalette.primaryTextColor,)),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      CustomButton(
                                        onPressed: () => Navigator.pop(context),
                                        label: "Close",
                                        width: size.width * 0.8,
                                        height: size.height * 0.08,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(Icons.menu, color: AppPalette.primaryTextColor),
                            ),


                            trailing: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Add Internal Mark",
                                        style: TextStyle(
                                            color: AppPalette
                                                .primaryTextColor)),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                              width: size.width * 0.8,
                                              height: size.height * 0.08,
                                              labelText: "Subject",
                                              isPassword: false,
                                              textEditingController:
                                              _subjectController),
                                          SizedBox(
                                              height: size.height * 0.03),
                                          CustomTextField(
                                              width: size.width * 0.8,
                                              height: size.height * 0.08,
                                              labelText: "Mark",
                                              isPassword: false,
                                              textEditingController:
                                              _markController),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      CustomButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        label: "Cancel",
                                        width: size.width * 0.8,
                                        height: size.height * 0.08,
                                      ),
                                      CustomButton(
                                        onPressed: () {
                                          model.addInternalMark(sem: _semFilterController.text,course: _courseController.text,
                                            internalMark: InternalMark(
                                              uid: "${_semFilterController.text}_${student.course}_${student.studentId}_${_subjectController.text}",
                                              studentId:
                                              student.studentId,
                                              sem: _semFilterController
                                                  .text,
                                              course: student.course,
                                              subject:
                                              _subjectController.text,
                                              mark: _markController.text,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                        label: "Save",
                                        width: size.width * 0.8,
                                        height: size.height * 0.08,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(Icons.edit,
                                  color: AppPalette.whiteColor),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : model.viewState == ViewState.empty
                      ? Padding(
                    padding:
                    EdgeInsets.only(top: size.height / 4.5),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/empty.png",
                          height: size.height * 0.1,
                          width: size.width * 0.5,
                        ),
                        const Text(
                          "No students with applied filter",
                          style: TextStyle(
                              color: AppPalette.primaryTextColor),
                        )
                      ],
                    ),
                  )
                      : LoadingView(
                    height: size.height / 4.5,
                    width: size.width * 0.8,
                  ),
                ],
              ),
            ),
          );
        });
  }}


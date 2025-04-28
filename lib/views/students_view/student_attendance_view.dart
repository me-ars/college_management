import 'package:college_management/app/base_view.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:flutter/material.dart';

import '../../core/enums/view_state.dart';
import '../../view_models/students_attendance_view_model.dart';

class StudentAttendanceView extends StatelessWidget {
  const StudentAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<StudentsAttendanceViewModel>(
      refresh: (StudentsAttendanceViewModel model) {},
      onModelReady: (StudentsAttendanceViewModel model) {
        model.onModelReady(studentId: '987');
      },
      builder: (context, model, child) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: const Text('Attendance'),
            backgroundColor: AppPalette.violetLt,
          ),
          body: model.viewState == ViewState.ideal
            ? ListView.builder(
              itemCount: model.attendance.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:  EdgeInsets.all(size.width*0.04),
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.1,
                    decoration: const BoxDecoration(color: AppPalette.offWhite),
                    child: ListTile(
                      title: Text(
                        model.attendance[index],
                        style: const TextStyle(color: AppPalette.primaryTextColor),
                      ),
                    ),
                  ),
                );
              },
            )
              : model.viewState == ViewState.empty
        ? const Center(
          child: Text(
          'No attendance records',
          style: TextStyle(color: AppPalette.primaryTextColor),
        ),
        )
            : LoadingView(
        height: size.height * 0.3, width: size.width / 2.5),

        ));
      },
    );
  }
}

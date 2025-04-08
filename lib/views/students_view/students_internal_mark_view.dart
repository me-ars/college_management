import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:flutter/material.dart';

import '../../app/base_view.dart';
import '../../core/enums/view_state.dart';
import '../../view_models/studnets_internal_mark_view_model.dart';

class StudentsInternalMarkView extends StatefulWidget {
  const StudentsInternalMarkView({super.key});

  @override
  State<StudentsInternalMarkView> createState() =>
      _StudentsInternalMarkViewState();
}

class _StudentsInternalMarkViewState extends State<StudentsInternalMarkView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<StudentsInternalMarkViewModel>(
      onModelReady: (model) {
        // Replace with actual student ID and course
        model.onModelReady(studentId: "1234", course: "mca");
      },
      refresh: (StudentsInternalMarkViewModel model) {},
      builder: (context, model, child) {
        Size size = MediaQuery.of(context).size;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppPalette.violetLt,
              title: const Text('Internal Marks'),
            ),
            body: Builder(
              builder: (_) {
                switch (model.viewState) {
                  case ViewState.busy:
                    return LoadingView(
                        height: size.height * 0.3, width: size.width / 2.5);

                  case ViewState.empty:
                    return const Center(
                        child: Text('No internal marks available.'));

                  case ViewState.ideal:
                    return ListView.builder(
                      itemCount: model.internalMarks.length,
                      itemBuilder: (context, index) {
                        final mark = model.internalMarks[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text("Subject: ${mark.subject}"),
                            subtitle: Text("Semester: ${mark.sem}"),
                            trailing: Text("Mark: ${mark.mark}"),
                          ),
                        );
                      },
                    );

                  default:
                    return const SizedBox(); // For unhandled viewStates
                }
              },
            ),
          ),
        );
      },
    );
  }
}

import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import '../app/base_view.dart';
import '../core/models/student.dart';
import '../view_models/shared_view_models/students_view_model.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  TextEditingController _semFilterController = TextEditingController();
  TextEditingController _courseFilterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<StudentsViewModel>(
        onModelReady: (StudentsViewModel model) {
          _semFilterController.text = '1';
          _courseFilterController.text = "MCA";
          model.onModelReady(sem: _semFilterController.text, course: "MCA");
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
              backgroundColor: AppPalette.violetDark,
            ),
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropdown(
                          selectedValue: "MCA",
                          items: const [
                            "MCA",
                            "MBA",
                          ],
                          onChanged: (val) {
                            _courseFilterController.text = val;
                          },
                          width: size.width / 4,
                          height: size.height * 0.08,
                          labelText: "Course"),
                      CustomDropdown(
                          items: const ["1", '2', '3', '4'],
                          selectedValue: '1',
                          onChanged: (val) {
                            _semFilterController.text = val;
                          },
                          width: size.width / 4,
                          height: size.height * 0.08,
                          labelText: "Select sem"),
                      CustomButton(
                        label: "Apply",
                        onPressed: () {
                          model.onModelReady(
                              sem: _semFilterController.text,
                              course: _courseFilterController.text);
                        },
                        width: size.width / 4,
                        height: size.height * 0.08,
                      )
                    ],
                  ),
                  const Divider(
                    color: AppPalette.primaryTextColor,
                  ),
                  model.viewState == ViewState.ideal
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: model.filteredStudents.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                // Adjust margin for spacing
                                decoration: BoxDecoration(
                                  color: AppPalette.violetLt,
                                  // Background color
                                  borderRadius: BorderRadius.circular(10),
                                  // Rounded corners
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
                                    width: size.width * 0.15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
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
                                                            'UID: ${model.filteredStudents[index].studentId}',
                                                            style: const TextStyle(
                                                                color: AppPalette
                                                                    .primaryTextColor),
                                                          ),
                                                          Text(
                                                            'Name: ${model.filteredStudents[index].firstName + model.filteredStudents[index].lastName}',
                                                            style: const TextStyle(
                                                                color: AppPalette
                                                                    .primaryTextColor),
                                                          ),
                                                          Text(
                                                            'Sem: ${model.filteredStudents[index].sem!}',
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
                                                          model.updateSem(
                                                              student: model
                                                                      .filteredStudents[
                                                                  index]);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        label: "Update sem",
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
                                            child: const Icon(Icons.edit,
                                                color: AppPalette.whiteColor)),
                                        // Add icon color
                                        GestureDetector(
                                          onTap: (){
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
                                                          'UID: ${model.filteredStudents[index].studentId}',
                                                          style: const TextStyle(
                                                              color: AppPalette
                                                                  .primaryTextColor),
                                                        ),
                                                        Text(
                                                          'Name: ${model.filteredStudents[index].firstName + model.filteredStudents[index].lastName}',
                                                          style: const TextStyle(
                                                              color: AppPalette
                                                                  .primaryTextColor),
                                                        ),
                                                        Text(
                                                          'Sem: ${model.filteredStudents[index].sem!}',
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
                                                       model.deleteUser(uid: model.filteredStudents[index].studentId, index: index);
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      label: "Delete",
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
                                            child: const Icon(Icons.delete,
                                                color: AppPalette.whiteColor)),
                                        // Add icon color
                                      ],
                                    ),
                                  ),
                                  leading: GestureDetector(
                                    onTap: () {
                                      showStudentDetailsDialog(
                                          context: context,
                                          student:
                                              model.filteredStudents[index]);
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
                              height: size.height / 4.5,
                              width: size.width * 0.8),
                ],
              ),
            ),
          ));
        });
  }
}

void showStudentDetailsDialog(
    {required BuildContext context, required Student student}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Student Details",
          style: TextStyle(color: AppPalette.primaryTextColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Semester", student.sem),
              _buildDetailRow("First Name", student.firstName),
              _buildDetailRow("Last Name", student.lastName),
              _buildDetailRow("Student ID", student.studentId),
              _buildDetailRow("Course", student.course),
              _buildDetailRow("Joining Date", student.joiningDate),
              _buildDetailRow("Batch", student.batch),
              _buildDetailRow("Gender", student.gender),
              _buildDetailRow("DOB", student.dob),
              _buildDetailRow("Phone", student.phone),
              _buildDetailRow("Email", student.email),
              _buildDetailRow("Guardian Name", student.guardianName),
              _buildDetailRow("Guardian Phone", student.guardianPhone),
              _buildDetailRow("Address", student.address),
              _buildDetailRow("SSLC", student.sslc),
              _buildDetailRow("Plus Two", student.plusTwo),
              _buildDetailRow("Bachelors", student.bachelors),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

Widget _buildDetailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: RichText(
      text: TextSpan(
        style:
            const TextStyle(color: AppPalette.primaryTextColor, fontSize: 16),
        children: [
          TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value ?? "N/A"),
        ],
      ),
    ),
  );
}

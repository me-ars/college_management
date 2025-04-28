
import 'package:college_management/app/app_state.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/base_view.dart';
import '../core/constants/app_pallete.dart';
import '../core/enums/view_state.dart';
import '../core/models/admin_model.dart';
import '../core/models/faculty.dart';
import '../core/models/student.dart';
import '../view_models/shared_view_models/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    Faculty? faculty=context.read<AppState>().faculty;
    Student? student=context.read<AppState>().student;
    AdminModel? admin = context.read<AppState>().admin;

    Size size = MediaQuery.of(context).size;
    return BaseView<ProfileViewModel>(
        onModelReady: (ProfileViewModel model) {

        },
        refresh: (ProfileViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: AppPalette.offWhite),
                  ),
                  backgroundColor: AppPalette.violetDark,
                    actions: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text(
                                    "Do you want to logout?",
                                    style: TextStyle(
                                        color: AppPalette.primaryTextColor),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: AppPalette.primaryTextColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        model.logoutUser(
                                            appState: context.read<AppState>());

                                        Navigator.of(context).pop();
                                        // context.pushReplacementNamed(RouteConstants.login);
                                      },
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(
                                            color: AppPalette.primaryTextColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: AppPalette.offWhite,
                          ))
                    ],
                  ),
                  body: model.viewState == ViewState.ideal
                      ? faculty != null
                          ? facultyView(faculty)
                          : student != null
                              ? studentView(student)
                              :
                  adminView(admin!)
                      : LoadingView(
                          height: size.height / 4, width: size.width * 0.8)));
        });
  }

}

Widget adminView(AdminModel admin) {
  return _buildProfileCard(
    name: "Admin",
    details: {
      "Admin ID": admin.adminId,
      "Email": admin.email,
    },
  );
}

Widget facultyView(Faculty faculty) {
  return _buildProfileCard(
    name: "${faculty.firstName} ${faculty.lastName}",
    details: {
      "Employee ID": faculty.employeeId,
      "Email": faculty.email,
      "Phone": faculty.phone,
      "Course": faculty.course,
      "Subject": faculty.subject,
      "Gender": faculty.gender,
      "Date of Birth": faculty.dob,
      "Joining Date": faculty.joiningDate,
      "Address": faculty.address,
      "HOD": faculty.isHOD == true ? "Yes" : "No",
    },
  );
}

Widget _buildProfileCard({required String name, required Map<String, String> details}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppPalette.violetLt,
                child: Text(
                  name.split(" ").map((e) => e[0]).join(),
                  style: const TextStyle(fontSize: 24, color: AppPalette.offWhite),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...details.entries.map((entry) => _buildInfoRow(entry.key, entry.value)).toList(),
          ],
        ),
      ),
    ),
  );
}
Widget studentView(Student student) {
  return _buildProfileCard(
    name: "${student.firstName} ${student.lastName}",
    details: {
      "Student ID": student.studentId,
      "Email": student.email,
      "Phone": student.phone,
      "Course": student.course,
      "Semester": student.sem ?? "N/A",
      "Batch": student.batch,
      "Gender": student.gender,
      "Date of Birth": student.dob,
      "Joining Date": student.joiningDate,
      "Guardian Name": student.guardianName,
      "Guardian Phone": student.guardianPhone,
      "Address": student.address,
      "SSLC": student.sslc,
      "Plus Two": student.plusTwo,
      "Bachelors": student.bachelors,
    },
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold,color: AppPalette.secondaryTextColor)),
        Text(value, style: const TextStyle(color: AppPalette.primaryTextColor)),
      ],
    ),
  );
}

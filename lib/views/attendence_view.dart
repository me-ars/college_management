import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_date_picker.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app/base_view.dart';
import '../core/constants/app_pallete.dart';
import '../core/enums/view_state.dart';
import '../view_models/attendance_view_model.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

TextEditingController _semFilterController = TextEditingController();
TextEditingController _dateController = TextEditingController();
DateTime? selectedDate;
List<String> selectedUserIds = [];
List<String> allUserIds = ["U001", "U002", "U003", "U004", "U005", "U006"];

void _openAttendanceDialog(BuildContext context,AttendanceViewModel model) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Add Attendance",
              style: TextStyle(color: AppPalette.primaryTextColor),
            ),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Date Picker
                    ListTile(
                      title: Text(
                        selectedDate == null
                            ? "Select Date"
                            : DateFormat("yyyy-MM-dd").format(selectedDate!),
                        style: const TextStyle(color: AppPalette.primaryTextColor),
                      ),
                      trailing: const Icon(Icons.calendar_today,
                          color: AppPalette.primaryTextColor),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    // User ID Selector using Autocomplete
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                      ),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return model.allStudents
                              .map((s) => s.studentId) // Get student IDs from allStudents
                              .where((id) =>
                          id.contains(textEditingValue.text) &&
                              !selectedUserIds.contains(id))
                              .toList();
                        },
                        onSelected: (String selectedId) {
                          setState(() {
                            selectedUserIds.add(selectedId);
                          });
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 200),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return InkWell(
                                      onTap: () => onSelected(option),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                              color: AppPalette.primaryTextColor),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onEditingComplete) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              labelText: "Search User ID",
                              labelStyle:
                              TextStyle(color: AppPalette.primaryTextColor),
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(
                                color: AppPalette.primaryTextColor),
                            onEditingComplete: onEditingComplete,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Selected User IDs List
                    Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          children: selectedUserIds.map((id) {
                            return Chip(
                              label: Text(id,
                                  style: const TextStyle(
                                      color: AppPalette.primaryTextColor)),
                              onDeleted: () {
                                setState(() {
                                  selectedUserIds.remove(id);
                                });
                              },
                              backgroundColor: AppPalette.violetLt,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",
                    style: TextStyle(color: AppPalette.primaryTextColor)),
              ),
              TextButton(
                onPressed: () {
                  model.addAttendance(absentStudentIds: selectedUserIds);
                  print("Date: $selectedDate, User IDs: $selectedUserIds");
                  Navigator.pop(context);
                },

                child: const Text("Save",
                    style: TextStyle(color: AppPalette.primaryTextColor)),
              ),
            ],
            backgroundColor: AppPalette.violetLt,
          );
        },
      );
    },
  );
}

class _AttendanceViewState extends State<AttendanceView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<AttendanceViewModel>(
        onModelReady: (AttendanceViewModel model) {
          _semFilterController.text = '1';
          model.onModelReady(date: "2-4-2025", sem: "2");
        },
        refresh: (AttendanceViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _openAttendanceDialog(context,model);
              },
            ),
            appBar: AppBar(
              title: const Text(
                "Attendance",
                style: TextStyle(color: AppPalette.offWhite),
              ),
              backgroundColor: AppPalette.violetDark,
            ),
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  const Text(
                    "Filter",
                    style: TextStyle(color: AppPalette.primaryTextColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomDatePicker(
                          width: size.width / 4,
                          height: size.height * 0.08,
                          dateController: _dateController),
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
                            date: _dateController.text,
                            sem: _semFilterController.text,
                          );
                        },
                        width: size.width / 4,
                        height: size.height * 0.08,
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppPalette.primaryTextColor,
                  ),
                  model.viewState == ViewState.ideal
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: model.allStudents.length,
                            itemBuilder: (context, index) {
                              final student = model.allStudents[index];
                              final isAbsent = model.absentStudentIds
                                  .contains(student.studentId);

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: isAbsent
                                      ? Colors.redAccent.withOpacity(0.2)
                                      : AppPalette.violetLt,
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
                                  trailing: model.absentStudentIds.contains(student.studentId)
                                      ? const Icon(Icons.close, color: Colors.red) // Mark absent students with a red close icon
                                      : const Icon(Icons.check, color: Colors.green), // Mark present students with a green check icon

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

import 'package:college_management/app/app_state.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/leave_request.dart';
import 'package:college_management/core/models/student.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app/base_view.dart';
import '../../view_models/leave_application_view_model.dart';
import '../shared/loading_view.dart';

class LeaveApplicationView extends StatefulWidget {
  const LeaveApplicationView({
    super.key,
  });

  @override
  State<LeaveApplicationView> createState() => _LeaveApplicationViewState();
}

class _LeaveApplicationViewState extends State<LeaveApplicationView> {
  @override
  Widget build(BuildContext context) {
    Student? student;

    return BaseView<LeaveApplicationViewModel>(
      refresh: (LeaveApplicationViewModel model) {},
      onModelReady: (LeaveApplicationViewModel model) {
        student = context.read<AppState>().student;
        model.onModelReady(student: student!); // Load previous requests
      },
      builder: (context, model, child) {
        Size size = MediaQuery.of(context).size;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Leave Application"),
              backgroundColor: AppPalette.violetLt,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showLeaveRequestDialog(context, model);
              },
              child: const Icon(Icons.add), // Plus icon
            ),
            body: model.viewState == ViewState.busy
                ? LoadingView(
                    height: size.height / 4.5, width: size.width * 0.8)
                : model.leaveRequest.isEmpty
                    ? const Center(
                        child: Text(
                        "No previous leave requests.",
                        style: TextStyle(color: AppPalette.primaryTextColor,fontSize: 24),
                      ))
                    : ListView.builder(
                        itemCount: model.leaveRequest.length,
                        itemBuilder: (context, index) {
                          LeaveRequest request = model.leaveRequest[index];

                          // Ensure only current student's requests are displayed
                          if (request.studentId != student?.studentId) {
                            return const SizedBox
                                .shrink(); // Skip non-matching requests
                          }

                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                "${DateFormat('dd/MM/yy').format(DateTime.parse(request.fromDate))} to ${DateFormat('dd/MM/yy').format(DateTime.parse(request.toDate))}",
                              ),
                              subtitle: Text("Reason: ${request.reason}"),
                              trailing: Icon(
                                request.verified
                                    ? Icons.check_circle
                                    : Icons.pending,
                                color: request.verified
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }

  void _showLeaveRequestDialog(BuildContext context, LeaveApplicationViewModel model) {
    DateTime? fromDate;
    DateTime? toDate;
    TextEditingController reasonController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    final DateFormat formatter = DateFormat('EEE, MMM d, yyyy');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Request Leave",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // From Date Picker
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        fromDate == null
                            ? "Select From Date"
                            : "From: ${formatter.format(fromDate!)}",
                        style: const TextStyle(color: AppPalette.primaryTextColor),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await _selectDate(context);
                        if (picked != null) {
                          setState(() {
                            fromDate = picked;
                          });
                        }
                      },
                    ),

                    // To Date Picker
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        toDate == null
                            ? "Select To Date"
                            : "To: ${formatter.format(toDate!)}",
                        style: const TextStyle(color: AppPalette.primaryTextColor),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await _selectDate(context);
                        if (picked != null) {
                          setState(() {
                            toDate = picked;
                          });
                        }
                      },
                    ),

                    // Reason Text Field
                    CustomTextField(
                      height: size.height * 0.1,
                      width: size.width * 0.75,
                      isPassword: false,
                      labelText: "Reason",
                      textEditingController: reasonController,
                    ),

                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          label: "Cancel",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: size.width * 0.3,
                          height: size.height * 0.06,
                        ),
                        CustomButton(
                          label: "Submit Request",
                          onPressed: () {
                            if (fromDate == null || toDate == null || reasonController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("⚠️ Please fill all fields.")),
                              );
                              return;
                            }

                            if (fromDate!.isBefore(DateTime.now()) || toDate!.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("⚠️ Dates must be in the future.")),
                              );
                              return;
                            }
Student student=context.read<AppState>().student!
                            ;LeaveRequest newRequest = LeaveRequest(
                              studentFirstName: student.firstName,
                              studentLastName: student.lastName,
                              uid: student.studentId+fromDate!.toString(),
                              studentId:student.studentId,
                              course: student.course,
                              sem: student.sem!,
                              fromDate: fromDate!.toString(),
                              toDate: toDate!.toString(),
                              appliedDate: DateTime.now().toString(),
                              reason: reasonController.text,
                              verified: false,
                            );

                            model.addRequest(request: newRequest);
                            Navigator.pop(context);
                          },
                          width: size.width * 0.35,
                          height: size.height * 0.06,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  Future<DateTime?> _selectDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      // Default: Tomorrow
      firstDate: DateTime.now().add(const Duration(days: 1)),
      // No past dates
      lastDate: DateTime.now().add(const Duration(days: 365)), // 1 year max
    );
  }
}

import 'package:college_management/view_models/request_view_model.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_state.dart';
import '../app/base_view.dart';
import '../core/constants/app_pallete.dart';
import '../core/enums/view_state.dart';
import '../core/models/leave_request.dart';
class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  final TextEditingController _semFilterController = TextEditingController(text: '1');

  @override
  void dispose() {
    _semFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BaseView<RequestViewModel>(
      refresh: (model){},
      onModelReady: (model) {
        model.onModelReady(
          facultyCourse: context.read<AppState>().faculty!.course,
          sem: _semFilterController.text,
        );
      },
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Leave Requests",
                style: TextStyle(color: AppPalette.offWhite),
              ),
              backgroundColor: AppPalette.violetDark,
            ),
            body: Column(
              children: [
                const SizedBox(height: 10),
                const Text("Filter", style: TextStyle(color: AppPalette.primaryTextColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomDropdown(
                        items: const ["1", "2", "3", "4"],
                        selectedValue: _semFilterController.text,
                        onChanged: (value) {
                          _semFilterController.text = value;
                        },
                        width: size.width / 4,
                        height: size.height * 0.08,
                        labelText: "Semester",
                      ),
                      Column(
                        children: [
                          const Text("Verified", style: TextStyle(color: AppPalette.primaryTextColor)),
                          Switch(
                            value: model.showVerified,
                            onChanged: (value) => model.setVerifyFilter(showVerified: value),
                          ),
                        ],
                      ),
                      CustomButton(
                        label: "Apply",
                        onPressed: () {
                          model.onModelReady(
                            facultyCourse: context.read<AppState>().faculty!.course,
                            sem: _semFilterController.text,
                          );
                        },
                        width: size.width / 4,
                        height: size.height * 0.08,
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppPalette.primaryTextColor),
                Expanded(
                  child: _buildBody(model, size),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(RequestViewModel model, Size size) {
    if (model.viewState == ViewState.busy) {
      return LoadingView(height: size.height / 4.5, width: size.width * 0.8);
    }

    if (model.viewState == ViewState.empty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/empty.png",
              height: size.height * 0.1,
              width: size.width * 0.5,
            ),
            const SizedBox(height: 10),
            const Text(
              "No students with applied filter",
              style: TextStyle(color: AppPalette.primaryTextColor),
            ),
          ],
        ),
      );
    }

    final requests = model.showVerified ? model.verifiedRequests : model.unverifiedRequests;

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestTile(request, model, size);
      },
    );
  }

  Widget _buildRequestTile(LeaveRequest request, RequestViewModel model, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          "${request.studentFirstName} ${request.studentLastName}",
          style: const TextStyle(color: AppPalette.primaryTextColor),
        ),
        subtitle: Text(
          "UID: ${request.studentId}",
          style: const TextStyle(color: AppPalette.primaryTextColor),
        ),
        trailing: IconButton(
          icon: Icon(
            model.showVerified ? Icons.verified : Icons.menu,
            color: model.showVerified ? Colors.green : AppPalette.primaryTextColor,
          ),
          onPressed: () {
            _showRequestDialog(request, model, context);
          },
        ),
      ),
    );
  }

  void _showRequestDialog(LeaveRequest request, RequestViewModel model, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isVerified = model.showVerified;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Leave Request Details",
            style: TextStyle(color: AppPalette.primaryTextColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailText('UID', request.studentId),
                _detailText('Name', '${request.studentFirstName} ${request.studentLastName}'),
                _detailText('From', request.fromDate),
                _detailText('To', request.toDate),
                _detailText('Reason', request.reason),
              ],
            ),
          ),
          actions: [
            if (!isVerified)
              CustomButton(
                label: "Verify",
                onPressed: () {
                  model.verifyRequest(request: request);
                  Navigator.pop(context);
                },
                width: size.width * 0.35,
                height: size.height * 0.06,
              ),
            CustomButton(
              label: "Close",
              onPressed: () => Navigator.pop(context),
              width: size.width * 0.35,
              height: size.height * 0.06,
            ),
          ],
        );
      },
    );
  }

  Widget _detailText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        '$title: $value',
        style: const TextStyle(color: AppPalette.primaryTextColor),
      ),
    );
  }
}

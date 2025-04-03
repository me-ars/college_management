import 'package:college_management/view_models/request_view_model.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import '../app/base_view.dart';
import '../core/constants/app_pallete.dart';
import '../core/enums/view_state.dart';

class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

TextEditingController _semFilterController = TextEditingController();

class _RequestViewState extends State<RequestView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<RequestViewModel>(
        onModelReady: (RequestViewModel model) {
          _semFilterController.text = '1';
          model.onModelReady(
              facultyCourse: "mca"
// context.read<AppState>().faculty!.course
              ,
              sem: "2");
        },
        refresh: (RequestViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                model.addRequest();
              },
            ),
            appBar: AppBar(
              title: const Text(
                "Leave request's",
                style: TextStyle(color: AppPalette.offWhite),
              ),
              backgroundColor: AppPalette.violetDark,
            ),
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(

                children: [  const  Text("Filter",style: TextStyle(color: AppPalette.primaryTextColor),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomDropdown(
                          items: const ["1", '2', '3', '4'],
                          selectedValue: '1',
                          onChanged: (val) {
                            _semFilterController.text = val;
                          },
                          width: size.width / 4,
                          height: size.height * 0.08,
                          labelText: "Select sem"),
                      Column(
                        children: [
                         const  Text("Verified",style: TextStyle(color: AppPalette.primaryTextColor),),
                          Switch(
                            value: model.fetchVerifiedList,
                            // Toggle state from ViewModel
                            onChanged: (value) {
                              print(value);
                              model.setVerifyFilter(
                                  fetchVerified: value); // Update ViewModel
                            },
                          ),
                        ],
                      ),
                      CustomButton(
                        label: "Apply",
                        onPressed: () {
                          model.onModelReady(
                            facultyCourse: "mca",
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
                            itemCount: model.fetchVerifiedList
                                ? model.verifiedRequest.length
                                : model.unVerifiedRequest.length,
                            itemBuilder: (context, index) {
                              final request = model.fetchVerifiedList
                                  ? model.verifiedRequest[index]
                                  : model.unVerifiedRequest[index];

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
                                  subtitle: Text(
                                    request.studentId,
                                    style: const TextStyle(
                                        color: AppPalette.primaryTextColor),
                                  ),
                                  title: Text(
                                    "${request.studentFirstName} ${request.studentLastName}",
                                    style: const TextStyle(
                                        color: AppPalette.primaryTextColor),
                                  ),
                                  trailing: model.fetchVerifiedList
                                      ? const Icon(Icons.verified,
                                          color: Colors
                                              .green) // Show check for verified
                                      : IconButton(
                                          icon: const Icon(Icons.menu),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Verify Request",
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
                                                          'UID: ${request.studentId}',
                                                          style: const TextStyle(
                                                              color: AppPalette
                                                                  .primaryTextColor),
                                                        ),
                                                        Text(
                                                          'Name: ${request.studentFirstName} ${request.studentLastName}',
                                                          style: const TextStyle(
                                                              color: AppPalette
                                                                  .primaryTextColor),
                                                        ),
                                                        Text(
                                                          'From: ${request.fromDate}',
                                                          style: const TextStyle(
                                                              color: AppPalette
                                                                  .primaryTextColor),
                                                        ),
                                                        Text(
                                                          'To: ${request.toDate}',
                                                          style: const TextStyle(
                                                              color: AppPalette
                                                                  .primaryTextColor),
                                                        ),
                                                        Text(
                                                          'Reason: ${request.reason}',
                                                          style: const TextStyle(
                                                              color: AppPalette
                                                                  .primaryTextColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    CustomButton(
                                                      width: size.width * 0.35,
                                                      height:
                                                          size.height * 0.06,
                                                      onPressed: () {
                                                        model.verifyRequest(
                                                            request:
                                                                request); // Verify the request
                                                        Navigator.pop(
                                                            context); // Close dialog
                                                      },
                                                      label: "Verify",
                                                    ),
                                                    CustomButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      label: "Cancel",
                                                      width: size.width * 0.35,
                                                      height:
                                                          size.height * 0.06,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
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

import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/fee_model.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_date_picker.dart';
import 'package:college_management/views/widgets/custom_drop_down.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../app/base_view.dart';
import '../view_models/admin/fee_view_model.dart';

class FeeView extends StatefulWidget {
  const FeeView({super.key});

  @override
  State<FeeView> createState() => _FeeViewState();
}

TextEditingController _studentIdController = TextEditingController();
TextEditingController _dateController = TextEditingController();
String feeFor = '';
String sem = '';

class _FeeViewState extends State<FeeView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<FeeViewModel>(
        refresh: (FeeViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      "Add fee",
                      style: TextStyle(color: AppPalette.offWhite),
                    ),
                    backgroundColor: AppPalette.violetDark,
                  ),
                  body: Center(
                    child: model.viewState==ViewState.ideal?SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Enter fee details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppPalette.primaryTextColor,
                                fontSize: 25),
                          ),
                          CustomTextField(
                              width: size.width * 0.85,
                              height: size.height * 0.08,
                              isPassword: false,
                              labelText: "Enter Student ID",
                              textEditingController: _studentIdController),
                          CustomDropdown(
                              items: const [
                                "Sem fee",
                                "Exam fee",
                                "Programs",
                                "Others"
                              ],
                              onChanged: (val) {
                                feeFor = val;
                              },
                              width: size.width * 0.85,
                              height: size.height * 0.08,
                              labelText: "Fee for"),
                          CustomDropdown(
                              items: const ["1", "2", "3", "4"],
                              onChanged: (val) {
                                sem = val;
                              },
                              width: size.width * 0.85,
                              height: size.height * 0.08,
                              labelText: "Sem"),
                          CustomDatePicker(
                              width: size.width * 0.85,
                              height: size.height * 0.08,
                              dateController: _dateController),
                          CustomButton(
                            label: "Add fee",
                            onPressed: () async {
                              model.addFee(
                                  studentUid: _studentIdController.text,
                                  fee: Fee(
                                      uid: _studentIdController.text +
                                          DateTime.now().toString().trim(),
                                      studentId: _studentIdController.text,
                                      sem: sem,
                                      feeFor: feeFor,
                                      paidDate: _dateController.text));
                            },
                            width: size.width * 0.85,
                            height: size.height * 0.08,
                          )
                        ],
                      ),
                    ):LoadingView(height: size.height, width: size.width),
                  )));
        });
  }
}

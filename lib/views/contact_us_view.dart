import 'package:college_management/core/models/contact_us_model.dart';
import 'package:college_management/utils/validators.dart';
import 'package:college_management/views/helper_classes/custom_snackbar.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../app/base_view.dart';
import '../core/enums/view_state.dart';
import '../view_models/admin/contact_view_model.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _phoneController = TextEditingController();

class _ContactUsViewState extends State<ContactUsView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<ContactUsViewModel>(
        onModelReady: (ContactUsViewModel model) async{
        await   model.onModelReady();
          print(model.contactUsModel);
          _emailController.text = model.contactUsModel!.email;
          _phoneController.text = model.contactUsModel!.phone;
        },
        refresh: (ContactUsViewModel model) {},
        onDispose: (ContactUsViewModel model) {
          _emailController.clear();
          _phoneController.clear();
        },
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              floatingActionButton:FloatingActionButton(onPressed: (){
                model.add();
              },),
              resizeToAvoidBottomInset: true,
              body: model.viewState == ViewState.ideal
                  ? Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          CustomTextField(
                              width: size.width * 0.85,
                              height: size.height * 0.1,
                              isPassword: false,
                              textEditingController: _emailController),
                          CustomTextField(
                              width: size.width * 0.85,
                              height: size.height * 0.1,
                              isPassword: false,
                              textEditingController: _phoneController),
                          CustomButton(
                            label: "Update",
                            onPressed: () {
                              if (!ValidationUtils.isValidEmail(
                                  _emailController.text)) {
                                CustomSnackBar.show(context, "Invalid email");
                                return;
                              }
                              if (!ValidationUtils.isValidPhoneNumber(
                                  _phoneController.text)) {
                                CustomSnackBar.show(context, "Invalid phone");
                                return;
                              } else {
                                model.updateData(
                                    contactUsModel: ContactUsModel(
                                        email: _emailController.text,
                                        phone: _phoneController.text));
                              }
                            },
                            width: size.width * 0.85,
                            height: size.height * 0.1,
                          )
                        ]))
                  : LoadingView(
                      height: size.height * 0.3, width: size.width / 2.5),
            ),
          );
        });
  }
}

import 'package:college_management/app/app_state.dart';
import 'package:college_management/app/base_view.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/constants/route_constants.dart';
import 'package:college_management/views/helper_classes/custom_snackbar.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<LoginViewModel>(
        refresh: (LoginViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: AppPalette.violetLt,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(35),
                                bottomRight: Radius.circular(35))),
                        height: size.height / 3.5,
                      ),
                      SizedBox(height: size.height * 0.08),
                      CustomTextField(
                        textEditingController: _usernameController,
                        labelText: "Username",
                        width: size.width * 0.85,
                        height: size.height * 0.08,
                        isPassword: false,
                      ),
                      SizedBox(height: size.height * 0.015),
                      CustomTextField(
                        textEditingController: _passwordController,
                        labelText: "Password",
                        width: size.width * 0.85,
                        height: size.height * 0.08,
                        isPassword: true,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.55),
                        child: const Text(
                          "Forget password?",
                          style:
                              TextStyle(color: AppPalette.secondaryTextColor),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      CustomButton(
                          label: "Login",
                          onPressed: () async {

                            if (_usernameController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              if (_passwordController.text.length < 6) {
                                CustomSnackbar.show(context, "Password should contain at least 6 characters");
                                return; // Stop further execution
                              }

                              model.login(
                                appState: context.read<AppState>(),
                                userId: _usernameController.text,
                                password: _passwordController.text,
                              );
                            } else {
                              CustomSnackbar.show(context, "Fields can't be empty");
                            }
                          },

                          width: size.width * 0.75,
                          height: size.height * 0.06),
                      SizedBox(height: size.height * 0.01),
                      GestureDetector(onTap: (){
                          GoRouter.of(context).goNamed(RouteConstants.signUp);
                        },
                        child: const Text(
                          "Don't have an account? Signup",
                          style: TextStyle(color: AppPalette.secondaryTextColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

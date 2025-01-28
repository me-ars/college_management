import 'package:college_management/app/base_view.dart';
import 'package:flutter/material.dart';
import '../../view_models/auth/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      refresh: (LoginViewModel model) {},
      builder: (context, model, child) {
        return const Scaffold();
      },
    );
  }
}

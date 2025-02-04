import 'package:college_management/views/auth/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/route_constants.dart';

import '../../app/app_state.dart';

class AppRouter {
  final AppState _appState;

  AppRouter({required AppState appState}) : _appState = appState;
  late final appRouter = GoRouter(
    redirect: (context, state) async {
      return null;
    },
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        name: RouteConstants.login,
        path: '/',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey<String>(RouteConstants.login),
          child: SignupView(),
        ),
      ),
      GoRoute(
        name: RouteConstants.signUp,
        path: '/signup',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey<String>(RouteConstants.signUp),
          child: SignupView(),
        ),
      ),
    ],
  );
}

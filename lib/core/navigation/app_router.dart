import 'package:college_management/views/auth/signup_view.dart';
import 'package:college_management/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/auth/login_view.dart';
import '../constants/route_constants.dart';

import '../../app/app_state.dart';
class AppRouter {
  final AppState _appState;

  AppRouter({required AppState appState}) : _appState = appState;

  late final appRouter = GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      if (_appState.faculty != null || _appState.student != null) {
        return '/home';
      }
      return '/';
    },
    routes: <RouteBase>[
      GoRoute(
        name: RouteConstants.login,
        path: '/',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey<String>(RouteConstants.login),
          child: LoginView(), // Changed from SignupView to LoginView for clarity
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
      GoRoute(
        name: RouteConstants.home,
        path: '/home',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey<String>(RouteConstants.home),
          child: HomeView(),
        ),
      ),
    ],
  );
}

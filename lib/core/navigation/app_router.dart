import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/auth/login_view.dart';
import '../constants/route_constants.dart' as route_names;

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
        name: route_names.login,
        path: '/',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey<String>(route_names.login),
          child: LoginView(),
        ),
      ),
    ],
  );
}

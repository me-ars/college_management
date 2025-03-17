import 'package:college_management/views/auth/signup_view.dart';
import 'package:college_management/views/calender_view.dart';
import 'package:college_management/views/contact_us_view.dart';
import 'package:college_management/views/fee_management_view.dart';
import 'package:college_management/views/home_view.dart';
import 'package:college_management/views/students_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/announcement_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/faculty_view.dart';
import '../constants/route_constants.dart';

import '../../app/app_state.dart';
class AppRouter {
  final AppState _appState;

  AppRouter({required AppState appState}) : _appState = appState;

  late final appRouter = GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      if (_appState.faculty != null || _appState.student != null || _appState.admin) {
        return '/home'; // ✅ If user is logged in or admin, go to home
      }
      return '/'; // ✅ If no user is logged in, go to login
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
          routes: [
            GoRoute(
              name: RouteConstants.studentsView,
              path: '/studentsView',
              pageBuilder: (context, state) => const MaterialPage<void>(
                key: ValueKey<String>(RouteConstants.studentsView),
                child: StudentsView(),
              ),
            ),
            GoRoute(
              name: RouteConstants.feeDetails,
              path: '/feeDetails',
              pageBuilder: (context, state) => const MaterialPage<void>(
                key: ValueKey<String>(RouteConstants.feeDetails),
                child: FeeView(),
              ),
            ),
            GoRoute(
              name: RouteConstants.calenderView,
              path: '/calenderView',
              pageBuilder: (context, state) => const MaterialPage<void>(
                key: ValueKey<String>(RouteConstants.calenderView),
                child: CalenderView(),
              ),
            ),
            GoRoute(
              name: RouteConstants.teachersView,
              path: '/teachersView',
              pageBuilder: (context, state) => const MaterialPage<void>(
                key: ValueKey<String>(RouteConstants.teachersView),
                child: FacultyView(),
              ),
            ),
            GoRoute(
              name: RouteConstants.announcements,
              path: '/announcements',
              pageBuilder: (context, state) => const MaterialPage<void>(
                key: ValueKey<String>(RouteConstants.feeDetails),
                child: AnnouncementView(),
              ),
            ),
            GoRoute(
              name: RouteConstants.contactDetails,
              path: '/contactDetails',
              pageBuilder: (context, state) => const MaterialPage<void>(
                key: ValueKey<String>(RouteConstants.contactDetails),
                child: ContactUsView(),
              ),
            ),
          ]),
    ],
  );
}

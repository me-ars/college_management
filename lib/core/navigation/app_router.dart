import 'package:college_management/views/attendence_view.dart';
import 'package:college_management/views/auth/signup_view.dart';
import 'package:college_management/views/calender_view.dart';
import 'package:college_management/views/contact_us_view.dart';
import 'package:college_management/views/fee_management_view.dart';
import 'package:college_management/views/home_view.dart';
import 'package:college_management/views/internal_mark_view.dart';
import 'package:college_management/views/profile_view.dart';
import 'package:college_management/views/students_view.dart';
import 'package:college_management/views/students_view/leave_application_view.dart';
import 'package:college_management/views/students_view/student_attendance_view.dart';
import 'package:college_management/views/students_view/student_fee_view.dart';
import 'package:college_management/views/students_view/students_internal_mark_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/announcement_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/faculty_view.dart';
import '../../views/request_view.dart';
import '../constants/route_constants.dart';

import '../../app/app_state.dart';

class AppRouter {
  final AppState _appState;

  AppRouter({required AppState appState}) : _appState = appState;

  late final appRouter = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async{
      final isLoggedIn = _appState.faculty != null ||
          _appState.student != null ||
          _appState.isAdmin;
      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/signup';

      // Not logged in and trying to access protected route
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // Logged in but trying to access auth route
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        name: RouteConstants.login,
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey<String>(RouteConstants.login),
          child: LoginView(),
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
        path: '/',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey<String>(RouteConstants.home),
          child: HomeView(),
        ),
        routes: [
          GoRoute(
            name: RouteConstants.studentsView,
            path: 'studentsView',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.studentsView),
              child: StudentsView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.feeDetails,
            path: 'feeDetails',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.feeDetails),
              child: FeeView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.calenderView,
            path: 'calenderView',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.calenderView),
              child: CalenderView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.teachersView,
            path: 'teachersView',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.teachersView),
              child: FacultyView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.announcements,
            path: 'announcements',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.announcements),
              child: AnnouncementView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.contactDetails,
            path: 'contactDetails',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.contactDetails),
              child: ContactUsView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.internalMarks,
            path: 'internalMarks',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.internalMarks),
              child: InternalMarksView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.leaveRequest,
            path: 'leaveRequest',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.leaveRequest),
              child:RequestView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.attendance,
            path: 'attendance',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.attendance),
              child:AttendanceView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.profileView,
            path: 'profileView',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.profileView),
              child: ProfileView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.sendRequest,
            path: 'sendRequest',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.sendRequest),
              child: LeaveApplicationView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.viewFee,
            path: 'viewFee',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.viewFee),
              child: StudentFeeView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.studentAttendance,
            path: 'studentsAttendance',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key:  ValueKey<String>(RouteConstants.studentAttendance),
              child: StudentAttendanceView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.studentInternalMark,
            path: 'studentsInternalMark',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key:  ValueKey<String>(RouteConstants.studentInternalMark),
              child: StudentsInternalMarkView(),
            ),
          ),
        ],
      ),
    ],
  );
}
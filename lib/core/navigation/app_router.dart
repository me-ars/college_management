import 'package:college_management/view_models/students_attendance_view_model.dart';
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
//
// class AppRouter {
//   final AppState _appState;
//
//   AppRouter({required AppState appState}) : _appState = appState;
//
//   late final appRouter = GoRouter(
//     initialLocation: '/home',
//     redirect: (context, state) {
//       if (_appState.faculty != null || _appState.student != null || _appState.admin) {
//         return '/home'; // ✅ If user is logged in or admin, go to home
//       }
//       return '/'; // ✅ If no user is logged in, go to login
//     },
//
//     routes: <RouteBase>[
//       GoRoute(
//         name: RouteConstants.login,
//         path: '/',
//         pageBuilder: (context, state) => const MaterialPage<void>(
//           key: ValueKey<String>(RouteConstants.login),
//           child: LoginView(), // Changed from SignupView to LoginView for clarity
//         ),
//       ),
//       GoRoute(
//         name: RouteConstants.signUp,
//         path: '/signup',
//         pageBuilder: (context, state) => const MaterialPage<void>(
//           key: ValueKey<String>(RouteConstants.signUp),
//           child: SignupView(),
//         ),
//       ),
//       GoRoute(
//         name: RouteConstants.home,
//         path: '/home',
//         pageBuilder: (context, state) => const MaterialPage<void>(
//           key: ValueKey<String>(RouteConstants.home),
//           child: HomeView(),
//         ),
//           routes: [
//             GoRoute(
//               name: RouteConstants.studentsView,
//               path: '/studentsView',
//               pageBuilder: (context, state) => const MaterialPage<void>(
//                 key: ValueKey<String>(RouteConstants.studentsView),
//                 child: StudentsView(),
//               ),
//             ),
//             GoRoute(
//               name: RouteConstants.feeDetails,
//               path: '/feeDetails',
//               pageBuilder: (context, state) => const MaterialPage<void>(
//                 key: ValueKey<String>(RouteConstants.feeDetails),
//                 child: FeeView(),
//               ),
//             ),
//             GoRoute(
//               name: RouteConstants.calenderView,
//               path: '/calenderView',
//               pageBuilder: (context, state) => const MaterialPage<void>(
//                 key: ValueKey<String>(RouteConstants.calenderView),
//                 child: CalenderView(),
//               ),
//             ),
//             GoRoute(
//               name: RouteConstants.teachersView,
//               path: '/teachersView',
//               pageBuilder: (context, state) => const MaterialPage<void>(
//                 key: ValueKey<String>(RouteConstants.teachersView),
//                 child: FacultyView(),
//               ),
//             ),
//             GoRoute(
//               name: RouteConstants.announcements,
//               path: '/announcements',
//               pageBuilder: (context, state) => const MaterialPage<void>(
//                 key: ValueKey<String>(RouteConstants.feeDetails),
//                 child: AnnouncementView(),
//               ),
//             ),
//             GoRoute(
//               name: RouteConstants.contactDetails,
//               path: '/contactDetails',
//               pageBuilder: (context, state) => const MaterialPage<void>(
//                 key: ValueKey<String>(RouteConstants.contactDetails),
//                 child: ContactUsView(),
//               ),
//             ),
//           ]),
//     ],
//   );
// }
class AppRouter {
  final AppState _appState;

  AppRouter({required AppState appState}) : _appState = appState;

  late final appRouter = GoRouter(
    initialLocation: '/home',

    // redirect: (context, state) {
    //   // If the user is not logged in and not already on the login or signup page, redirect to login
    //   if (_appState.faculty == null && _appState.student == null && !_appState.admin) {
    //     if (state.path != '/' && state.path != '/signup') {
    //       return '/';
    //     }
    //   }
    //   // If the user is logged in and tries to access the login or signup page, redirect to home
    //   else if ((_appState.faculty != null || _appState.student != null || _appState.admin) &&
    //       (state.path == '/' || state.path == '/signup')) {
    //     return '/home';
    //   }
    //   // Otherwise, allow the navigation to proceed
    //   return null;
    // },

    routes: <RouteBase>[
      GoRoute(
        name: RouteConstants.login,
        path: '/',
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
          GoRoute(
            name: RouteConstants.internalMarks,
            path: '/internalMarks',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.internalMarks),
              child: InternalMarksView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.leaveRequest,
            path: '/leaveRequest',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.leaveRequest),
              child:RequestView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.attendance,
            path: '/attendance',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.attendance),
              child:AttendanceView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.profileView,
            path: '/profileView',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.profileView),
              child: ProfileView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.sendRequest,
            path: '/sendRequest',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.profileView),
              child: LeaveApplicationView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.viewFee,
            path: '/viewFee',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key: ValueKey<String>(RouteConstants.viewFee),
              child: StudentFeeView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.studentAttendance,
            path: '/studentsAttendance',
            pageBuilder: (context, state) => const MaterialPage<void>(
              key:  ValueKey<String>(RouteConstants.studentAttendance),
              child: StudentAttendanceView(),
            ),
          ),
          GoRoute(
            name: RouteConstants.studentInternalMark,
            path: '/studentsInternalMark',
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
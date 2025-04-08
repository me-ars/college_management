import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:college_management/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/faculty.dart';
import '../core/models/student.dart';
import '../core/navigation/app_router.dart';
import '../core/theme/theme.dart';
import 'app_state.dart';

class MesAimat extends StatefulWidget {
 final Student? student;
 final Faculty? faculty;
 final bool isAdmin;

  const MesAimat(
      {super.key, this.student, this.faculty, required this.isAdmin});

  @override
  State<MesAimat> createState() => _MesAimatState();
}

class _MesAimatState extends State<MesAimat> {
  late AppState _appState;

  @override
  void initState() {
    _appState = AppState(
        isAdmin: widget.isAdmin,
        firebaseService: locator<FirebaseService>(),
        faculty: widget.faculty,
        student: widget.student);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _appState,
      child: Builder(
        builder: (context) {
          final appRouter = AppRouter(appState: _appState).appRouter;

          // AppRouter(appState: Provider.of<AppState>(context)).appRouter;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'MesAimat',
            theme: AppTheme.lightThemeMode,
            routeInformationParser: appRouter.routeInformationParser,
            routeInformationProvider: appRouter.routeInformationProvider,
            routerDelegate: appRouter.routerDelegate,
          );
        },
      ),
    );
  }
}

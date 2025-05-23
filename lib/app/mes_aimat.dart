import 'package:college_management/core/models/admin_model.dart';
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
  final AdminModel? adminModel;

  const MesAimat({super.key,
    this.student,
    this.faculty,
    required this.isAdmin,
    this.adminModel});

  @override
  State<MesAimat> createState() => _MesAimatState();
}

class _MesAimatState extends State<MesAimat> {
  late AppState _appState;

  @override
  void initState() {
    _appState = AppState(
        isAdmin: widget.isAdmin,
        faculty: widget.faculty,
        student: widget.student,
        admin: widget.adminModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _appState,
      child: Builder(
        builder: (context) {
          final appRouter =
              AppRouter(appState: Provider.of<AppState>(context)).appRouter;
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

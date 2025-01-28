import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/navigation/app_router.dart';
import '../core/theme/theme.dart';
import 'app_state.dart';

class MesAimat extends StatefulWidget {
  const MesAimat({super.key});

  @override
  State<MesAimat> createState() => _MesAimatState();
}

class _MesAimatState extends State<MesAimat> {
  late AppState _appState;

  @override
  void initState() {
    _appState = AppState();
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

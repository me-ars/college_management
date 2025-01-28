part of 'init_dependencies.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
//singleton
  locator.registerLazySingleton<FirebaseService>(() => FirebaseServiceImpl());
//non singleton
  locator.registerFactory<LoginViewModel>(() => LoginViewModel());
}

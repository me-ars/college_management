part of 'init_dependencies.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
//singleton
  locator.registerLazySingleton<AuthService>(() => AuthServiceImpl(firebaseService: locator()));
  locator.registerLazySingleton<FirebaseService>(()=>FirebaseServiceImpl());
  locator.registerLazySingleton<DatabaseService>(() => DatabaseServiceImpl());

//non singleton
  locator.registerFactory<LoginViewModel>(
      () => LoginViewModel(authService: locator(),databaseService: locator()));
  locator.registerFactory<SignupViewModel>(() =>
      SignupViewModel(firebaseService: locator(), databaseService: locator()));
  locator.registerFactory<HomeViewModel>(() => HomeViewModel());
}

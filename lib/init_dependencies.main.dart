part of 'init_dependencies.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
//singleton
  locator.registerLazySingleton<AuthService>(() => AuthServiceImpl(firebaseService: locator()));
  locator.registerLazySingleton<FirebaseService>(()=>FirebaseServiceImpl());
//non singleton
  locator.registerFactory<LoginViewModel>(() => LoginViewModel());
  locator.registerFactory<SignupViewModel>(
      () => SignupViewModel(firebaseService: locator()));
}

part of 'init_dependencies.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
//singleton
  locator.registerLazySingleton<AuthService>(() => AuthServiceImpl(firebaseService: locator()));
  locator.registerLazySingleton<FirebaseService>(()=>FirebaseServiceImpl());
  locator.registerLazySingleton<DatabaseService>(() => DatabaseServiceImpl());
  locator.registerLazySingleton<FeeService>(
          () => FeeServiceImpl(firebaseService: locator()));

//non singleton
  locator.registerFactory<LoginViewModel>(
      () => LoginViewModel(authService: locator(),databaseService: locator()));
  locator.registerFactory<SignupViewModel>(() =>
      SignupViewModel(firebaseService: locator(), databaseService: locator()));
  locator.registerFactory<StudentsViewModel>(
      () => StudentsViewModel(firebaseService: locator()));
  locator.registerFactory<HomeViewModel>(() => HomeViewModel());
  locator.registerFactory<FacultyViewModel>(
      () => FacultyViewModel(firebaseService: locator()));
  locator.registerFactory<ContactUsViewModel>(
      () => ContactUsViewModel(firebaseService: locator()));
  locator
      .registerFactory<FeeViewModel>(() => FeeViewModel(feeService: locator()));
  locator.registerFactory<CalenderViewModel>(
      () => CalenderViewModel(firebaseService: locator()));
  locator.registerFactory<AnnouncementViewModel>(
      () => AnnouncementViewModel(firebaseService: locator()));
  locator.registerFactory<InternalMarksViewModel>(
      () => InternalMarksViewModel(firebaseService: locator()));
  locator.registerFactory<RequestViewModel>(
          () => RequestViewModel(firebaseService: locator()));
  locator.registerFactory<AttendanceViewModel>(
          () => AttendanceViewModel(firebaseService: locator()));
  locator.registerFactory<ProfileViewModel>(
      () => ProfileViewModel(authService: locator()));
  //student view
  locator.registerFactory<LeaveApplicationViewModel>(
      () => LeaveApplicationViewModel(firebaseService: locator()));
  locator.registerFactory<StudentFeeViewModel>(
      () => StudentFeeViewModel(firebaseService: locator()));
  locator.registerFactory<StudentsInternalMarkViewModel>(
      () => StudentsInternalMarkViewModel(firebaseService: locator()));
  locator.registerFactory<StudentsAttendanceViewModel>(
      () => StudentsAttendanceViewModel(firebaseService: locator()));
}

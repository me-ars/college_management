import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/faculty.dart';
import 'package:college_management/core/models/student.dart';
import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:college_management/view_models/base_view_model.dart';

class StudentsViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  StudentsViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  List<Faculty> _faculty = [];

  List<Faculty> get faculty => _faculty;
  List<Student> _students = [];

  List<Student> get students => _students;

  onModelReady() async {
    try {
      setViewState(state: ViewState.busy);

      // Fetch all users (students + faculty)
      var data = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.users,
      );

      if (data != null && data.isNotEmpty) {
        _faculty = [];
        // _students = [];

        for (var item in data) {
          if (item.containsKey("employeeId")) {
            _faculty.add(Faculty.fromMap(item)); // Faculty
          } else if (item.containsKey("studentId")) {
            _students.add(Student.fromMap(item)); // Student
          }
        }
      } else {
        print("⚠️ No user data found.");
      }
      if(_students.isEmpty){
        print("empty");
        setViewState(state: ViewState.empty);
      }
      else {
        setViewState(state: ViewState.ideal);
      }
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          onModelReady();
        },
      );
    }
  }

  deleteUser({required String uid,required int index}) async {
    try {
      setViewState(state: ViewState.busy);
    await  _firebaseService.deleteData(collectionName: FirebaseCollectionConstants.users, documentId: uid);
    _faculty.removeAt(index);
    setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(error: e, retryMethod: deleteUser(uid: uid,index: index));
    }
  }

  add() async {
    try {
      Student fac = Student(
          firstName: "firstName",
          lastName: "lastName",
          studentId: "123",
          course: "Mca",
          joiningDate: "joiningDate",
          batch: "subject",
          gender: "gender",
          dob: "dob",
          phone: "phone",
          email: "email",
          guardianName: "coName",
          guardianPhone: "coPhoneNumber",
          bachelors: "",
          plusTwo: "",
          sslc: "",
          address: "address");
      await _firebaseService.setData(
          collectionName: "users", documentId: "123", data: fac.toMap());
      print("added");
    } catch (e) {
      print(e);
    }
  }
}

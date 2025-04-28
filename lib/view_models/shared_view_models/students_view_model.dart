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
  List<Student> _filteredStudents = [];

  List<Student> get filteredStudents => _filteredStudents;

  onModelReady({required String sem, required String course}) async {
    try {
      setViewState(state: ViewState.busy);
      _filteredStudents.clear();
      _students.clear();
      var data = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.users,
      );

      if (data != null && data.isNotEmpty) {
        _faculty = [];
        _students = []; // Ensure _students is properly initialized

        for (var item in data) {
          if (item.containsKey("employeeId")) {
            _faculty.add(Faculty.fromMap(item));
          } else if (item.containsKey("studentId")) {
            _students.add(Student.fromMap(item));
          }
        }


        for (var student in _students) {
          if (student.sem?.trim().toLowerCase() == sem.trim().toLowerCase() &&
              student.course.trim().toLowerCase() ==
                  course.trim().toLowerCase()) {
            _filteredStudents.add(student);
          }
        }

      } else {
      }

      if (_filteredStudents.isEmpty) {
        setViewState(state: ViewState.empty);
      } else {
        setViewState(state: ViewState.ideal);
      }
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          onModelReady(sem: sem, course: course);
        },
      );
    }
  }
  deleteUser({required String uid, required int index}) async {
    try {
      setViewState(state: ViewState.busy);

      await _firebaseService.deleteData(
          collectionName: FirebaseCollectionConstants.users,
          documentId: uid
      );

      // Remove from filtered students list as well
      _filteredStudents.removeWhere((element) => element.studentId == uid);

      _students.removeWhere((element) => element.studentId == uid);
showSnackBar(snackBarMessage: "Deleted student Successfully");
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          deleteUser(uid: uid, index: index);
        },
      );
    }
  }

  Future updateSem({required Student student}) async {
    try {
      setViewState(state: ViewState.busy);

      int sem = int.parse(student.sem!);
      int newSem = sem + 1; // Corrected increment

      if (sem < 3) {
        Student updatedStudent = student.copyWith(sem: newSem.toString());

        await _firebaseService.updateData(
          collectionName: FirebaseCollectionConstants.users,
          documentId: student.studentId,
          updatedData: updatedStudent.toMap(),
        );
        _filteredStudents.removeWhere((element) => element.studentId==student.studentId,);
        showSnackBar(snackBarMessage: "Semester updated");
        setViewState(state: ViewState.ideal);
      } else {
        showSnackBar(snackBarMessage: "Already in final semester");
        setViewState(state: ViewState.ideal);
      }
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          updateSem(student: student);
        },
      );
    }
  }

}

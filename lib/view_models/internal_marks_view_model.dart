import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management/core/models/internal_mark_model.dart';
import 'package:college_management/view_models/base_view_model.dart';
import '../core/constants/firebase_collection_constants.dart';
import '../core/enums/view_state.dart';
import '../core/models/faculty.dart';
import '../core/models/student.dart';
import '../core/models/student_internal_mark.dart';
import '../core/services/firebase_service/firebase_service.dart';
class InternalMarksViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  InternalMarksViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  List<Faculty> _faculty = [];
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  List<StudentInternalMark> _studentInternalMarks = [];

  List<Faculty> get faculty => _faculty;
  List<Student> get students => _students;
  List<Student> get filteredStudents => _filteredStudents;
  List<StudentInternalMark> get studentInternalMarks => _studentInternalMarks;

  Future<void> onModelReady({required String sem, required String course}) async {
    try {
      setViewState(state: ViewState.busy);
      _filteredStudents.clear();
      _studentInternalMarks.clear();

      // Fetch users (students + faculty)
      var userData = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.users,
      );

      // Fetch internal marks
      String collectionName = course == "MCA"
          ? FirebaseCollectionConstants.mcaInternalMark
          : FirebaseCollectionConstants.mbaInternalMark;

      var internalMarksData = await _firebaseService.getData(
        collectionName: collectionName,
      );

      // Process fetched internal marks
      if (internalMarksData != null) {
        for (var doc in internalMarksData) {
          _studentInternalMarks.add(StudentInternalMark(
            studentId: doc['studentId'] ?? '',
            internalMarks: (doc['internalMarks'] as List<dynamic>?)?.map((e) {
              return InternalMark.fromMap(e as Map<String, dynamic>);
            }).toList() ?? [], // Ensure list is always valid
          ));
        }
      }

      // Process user data
      if (userData != null && userData.isNotEmpty) {
        _faculty.clear();
        _students.clear();

        for (var item in userData) {
          if (item.containsKey("employeeId")) {
            _faculty.add(Faculty.fromMap(item)); // Faculty
          } else if (item.containsKey("studentId")) {
            _students.add(Student.fromMap(item)); // Student
          }
        }
      }
print(_studentInternalMarks);
      // Filter students by semester and course
      for (var student in _students) {
        if (student.sem == sem && student.course == course) {
          _filteredStudents.add(student);
        }
      }
      setViewState(state: _filteredStudents.isEmpty ? ViewState.empty : ViewState.ideal);
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          onModelReady(sem: sem, course: course);
        },
      );
    }
  }

  Future<void> fetchStudentInternalMarks(String studentId, String course) async {
    try {
      setViewState(state: ViewState.busy);
      _studentInternalMarks.clear();

      String collectionName = course == "MCA"
          ? FirebaseCollectionConstants.mcaInternalMark
          : FirebaseCollectionConstants.mbaInternalMark;

      DocumentSnapshot docSnap =
      await FirebaseFirestore.instance.collection(collectionName).doc(studentId).get();

      if (docSnap.exists) {
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
        _studentInternalMarks.add(StudentInternalMark.fromMap(data));
      } else {
        print("No internal marks found for this student.");
      }

      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          fetchStudentInternalMarks(studentId, course);
        },
      );
    }
  }

  Future<void> addInternalMark({required InternalMark internalMark}) async {
    try {
      String collectionName = internalMark.course == "MCA"
          ? FirebaseCollectionConstants.mcaInternalMark
          : FirebaseCollectionConstants.mbaInternalMark;

      DocumentReference docRef = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(internalMark.studentId);
      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        // Get existing marks list
        List<dynamic> existingMarks =
            (docSnap.data() as Map<String, dynamic>)['internalMarks'] ?? [];

        // Update if mark with the same UID exists
        bool markExists =
        existingMarks.any((mark) => mark['uid'] == internalMark.uid);

        if (markExists) {
          existingMarks = existingMarks.map((mark) {
            if (mark['uid'] == internalMark.uid) {
              return internalMark.toMap(); // Replace with updated mark
            }
            return mark;
          }).toList();
        } else {
          // Add new mark
          existingMarks.add(internalMark.toMap());
        }

        // Update Firestore document
        await _firebaseService.updateData(
          collectionName: collectionName,
          documentId: internalMark.studentId,
          updatedData: {
            'internalMarks': existingMarks, // Ensures previous marks are retained
            'studentId': internalMark.studentId, // Ensures studentId is stored properly
          },
        );

      } else {
        // Create a new document
        await _firebaseService.setData(
          collectionName: collectionName,
          documentId: internalMark.studentId,
          data: {
            'studentId': internalMark.studentId,
            'internalMarks': [internalMark.toMap()]
          },
        );
      }
      showSnackBar(snackBarMessage: "Internal mark added successfully");
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          addInternalMark(internalMark: internalMark);
        },
      );
    }
  }
}

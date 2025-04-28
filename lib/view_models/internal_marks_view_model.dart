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
  List<InternalMark> _internalMarks = [];
  List<StudentInternalMark> _studentInternalMarks = [];

  List<Faculty> get faculty => _faculty;
  List<Student> get students => _students;
  List<Student> get filteredStudents => _filteredStudents;
  List<InternalMark> get internalMarks => _internalMarks;
  List<StudentInternalMark> get studentInternalMarks => _studentInternalMarks;

  Future<void> onModelReady({required String sem, required String course}) async {
    try {
      setViewState(state: ViewState.busy);
      _filteredStudents.clear();
      _internalMarks.clear();
      _studentInternalMarks.clear();

      var userData = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.users,
      );

      String collectionName = course == "MCA"
          ? FirebaseCollectionConstants.mcaInternalMark
          : FirebaseCollectionConstants.mbaInternalMark;

      var internalMarksData = await _firebaseService.getData(
        collectionName: collectionName,
      );

      if (userData != null && userData.isNotEmpty) {
        _faculty.clear();
        _students.clear();

        for (var item in userData) {
          if (item.containsKey("employeeId")) {
            _faculty.add(Faculty.fromMap(item));
          } else if (item.containsKey("studentId")) {
            _students.add(Student.fromMap(item));
          }
        }
      }

      // Filter students based on sem and course
      for (var student in _students) {
        if (student.sem == sem && student.course == course) {
          _filteredStudents.add(student);
        }
      }

      // Map internal marks to filtered students
      if (_filteredStudents.isNotEmpty && internalMarksData != null) {
        for (var item in internalMarksData) {
          final studentId = item['studentId'];
          final marksRaw = item['internalMarks'] ?? [];

          // Check if the student is in the filtered list
          final exists = _filteredStudents.any((s) => s.studentId == studentId);
          if (!exists) continue;

          List<InternalMark> marks = (marksRaw as List).map((markData) {
            return InternalMark.fromMap(markData as Map<String, dynamic>);
          }).toList();

          _studentInternalMarks.add(
            StudentInternalMark(studentId: studentId, internalMarks: marks),
          );
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

  Future<void> addInternalMark({required InternalMark internalMark,required String sem,required String course}) async {
    try {
      String collectionName = internalMark.course == "MCA"
          ? FirebaseCollectionConstants.mcaInternalMark
          : FirebaseCollectionConstants.mbaInternalMark;

      DocumentReference docRef = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(internalMark.studentId);

      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        List<dynamic> existingMarks =
            (docSnap.data() as Map<String, dynamic>)['internalMarks'] ?? [];

        bool markExists =
        existingMarks.any((mark) => mark['uid'] == internalMark.uid);

        if (markExists) {
          existingMarks = existingMarks.map((mark) {
            if (mark['uid'] == internalMark.uid) {
              return internalMark.toMap();
            }
            return mark;
          }).toList();
        } else {
          existingMarks.add(internalMark.toMap());
        }

        await _firebaseService.updateData(
          collectionName: collectionName,
          documentId: internalMark.studentId,
          updatedData: {
            'internalMarks': existingMarks,
            'studentId': internalMark.studentId,
          },
        );
      } else {
        await _firebaseService.setData(
          collectionName: collectionName,
          documentId: internalMark.studentId,
          data: {
            'studentId': internalMark.studentId,
            'internalMarks': [internalMark.toMap()],
          },
        );
      }
onModelReady(sem: sem, course: course);
      showSnackBar(snackBarMessage: "Internal mark added successfully");
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          addInternalMark(internalMark: internalMark,course: course,sem: sem);
        },
      );
    }
  }
}

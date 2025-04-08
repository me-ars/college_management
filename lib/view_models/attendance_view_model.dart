import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/student.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../core/models/attendance_model.dart';
import '../core/services/firebase_service/firebase_service.dart';

class AttendanceViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  AttendanceViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  List<Student> _allStudents = [];

  List<Student> get allStudents => _allStudents;

  List<String> _absentStudentIds = [];

  List<String> get absentStudentIds => _absentStudentIds;

  List<AttendanceModel> _attendanceRecords = [];

  List<AttendanceModel> get attendanceRecords => _attendanceRecords;

  List<Student> _absentStudents = [];
  Future<void> onModelReady({required String date, required String sem}) async {
    try {
      setViewState(state: ViewState.busy);

      _allStudents.clear();
      _attendanceRecords.clear();
      _absentStudentIds.clear();
      _absentStudents.clear();

      // Fetch all users
      var studentData = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.users,
      );

      if (studentData.isNotEmpty) {
        // Filter and map students
        _allStudents = (studentData as List<dynamic>)
            .where((e) => e is Map<String, dynamic> && e.containsKey('studentId'))
            .map<Student>((e) => Student.fromMap(e as Map<String, dynamic>))
            .where((student) => student.course == 'MCA' && student.sem == sem)
            .toList();
      }

      // Rest of your attendance logic...
      var attendanceData = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.attendance,
        documentId: date
      );

      if (attendanceData.isNotEmpty) {
        print("Full attendanceData: $attendanceData");

        var firstElement = attendanceData[0];
        print("First element: $firstElement");

        var data = firstElement['records'];
        print("Extracted records: $data");

        if (data is List) {
          // _attendanceRecords = data
          //     .where((dynamic e) => e is Map<String, dynamic>)
          //     .map((e) => AttendanceModel.fromMap(e as Map<String, dynamic>))
          //     .where((record) =>
          // record.course == 'MCA' &&
          //     record.sem == sem &&
          //     record.attendanceDate == date)
          //     .toList();
          _attendanceRecords = data
              .where((dynamic e) => e is Map<String, dynamic>)
              .map((e) => AttendanceModel.fromMap(e as Map<String, dynamic>))
              .toList();

          print("Filtered attendance records: $_attendanceRecords");
        } else {
          print("Error: records is not a List!");
        }
      }



      // Extract absent student IDs
      _absentStudentIds = _attendanceRecords
          .where((record) => !record.isPresent)
          .map((record) => record.studentId)
          .toList();

      // Find absent students
      _absentStudents = _allStudents
          .where((student) => _absentStudentIds.contains(student.studentId))
          .toList();

      setViewState(
          state: _attendanceRecords.isEmpty ? ViewState.empty : ViewState.ideal);
    } catch (e, s) {
      print(s);
      showException(
        error: e,
        retryMethod: () => onModelReady(date: date, sem: sem),
      );
    }
  }
  Future<void> addAttendance({required List<String> absentStudentIds}) async {
    try {
      setViewState(state: ViewState.busy);

      // Create attendance records for all students
      _attendanceRecords = _allStudents.map((student) {
        bool isAbsent = absentStudentIds.contains(student.studentId);
        return AttendanceModel(
          isPresent: !isAbsent, // If student is in absent list, they are absent
          uid: "${student.studentId}_${DateTime.now().day}",
          studentId: student.studentId,
          sem: student.sem!,
          course: student.course,
          attendanceDate:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
        );
      }).toList();

      // Convert list of AttendanceModel to List<Map<String, dynamic>> for Firebase
      List<Map<String, dynamic>> attendanceData = _attendanceRecords
          .map((record) => record.toMap()) // Assuming AttendanceModel has a toMap() method
          .toList();

      // Save data in Firebase
      await _firebaseService.setData(
        collectionName: FirebaseCollectionConstants.attendance,
        documentId:
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
        data: {'attendance': attendanceData}, // Firebase expects a map, wrapping in a field
      );

      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
        error: e,
        retryMethod: () => addAttendance(absentStudentIds: absentStudentIds),
      );
    }
  }
}

import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../core/services/firebase_service/firebase_service.dart';

class StudentsAttendanceViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  StudentsAttendanceViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  List<String> _attendance = [];

  List<String> get attendance => _attendance;
  Future<void> onModelReady({required String studentId}) async {
    try {
      setViewState(state: ViewState.busy);

      _attendance = await _firebaseService.getDocumentIdsByStudentIdInAttendance(
        collectionName: FirebaseCollectionConstants.attendance,
        studentId: studentId,
      );
      if(_attendance.isEmpty){
        setViewState(state: ViewState.empty);
      }else {
        setViewState(state: ViewState.ideal);
      }
    } catch (e,s) {
      print(s);
      showException(
        error: e,
        retryMethod: () {
          onModelReady(studentId: studentId);
        },
      );
    }
  }


}

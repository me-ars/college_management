import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/internal_mark_model.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../core/services/firebase_service/firebase_service.dart';

class StudentsInternalMarkViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  StudentsInternalMarkViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  List<InternalMark> _internalMarks = [];

  List<InternalMark> get internalMarks => _internalMarks;
  Future<void> onModelReady({required String studentId, required String course}) async {
    try {
      setViewState(state: ViewState.busy);

      var data = await _firebaseService.getData(
        collectionName: course.toLowerCase() == 'mca'
            ? FirebaseCollectionConstants.mcaInternalMark
            : FirebaseCollectionConstants.mbaLeaveApplications,
        documentId: studentId,
      );

      if (data != null && data.isNotEmpty) {
        var marks = data[0]['internalMarks'] as List<dynamic>?;
        if (marks != null) {
          for (var markMap in marks) {
            _internalMarks.add(InternalMark.fromMap(markMap));
          }
        }
      }

      setViewState(state: _internalMarks.isEmpty ? ViewState.empty : ViewState.ideal);
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          onModelReady(studentId: studentId, course: course);
        },
      );
    }
  }


}

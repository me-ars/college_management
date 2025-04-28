import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/leave_request.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../core/models/student.dart';
import '../core/services/firebase_service/firebase_service.dart';

class LeaveApplicationViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  LeaveApplicationViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  List<LeaveRequest> _leaveRequest = [];

  List<LeaveRequest> get leaveRequest => _leaveRequest;

  Future<void> onModelReady({required Student student}) async {
    try {
      setViewState(state: ViewState.busy);
      var dataList = await _firebaseService.getData(
          collectionName: student.course.toLowerCase() == 'mca'
              ? FirebaseCollectionConstants.mcaLeaveApplications
              : FirebaseCollectionConstants.mbaLeaveApplications,
          documentId: student.studentId);

      if (dataList.isNotEmpty) {
        var document = dataList.first;

        if (document.containsKey("leaveRequests")) {
          var leaveRequests = document["leaveRequests"] as List<dynamic>;

          for (var request in leaveRequests) {
            _leaveRequest.add(LeaveRequest.fromMap(request as Map<String, dynamic>));
          }
        }

      }
if(_leaveRequest.isNotEmpty){
  setViewState(state: ViewState.ideal);
}else if(_leaveRequest.isEmpty){
  setViewState(state: ViewState.empty);
}
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            onModelReady(student: student);
          });
    }
  }
  Future<void> addRequest({required LeaveRequest request}) async {
    try {
      DateTime now = DateTime.now();
      DateTime fromDate = DateTime.parse(request.fromDate);
      DateTime toDate = DateTime.parse(request.toDate);

      if (fromDate.isBefore(now) || toDate.isBefore(now)) {
        showSnackBar(snackBarMessage: "Leave start and end dates must be in the future.");
        return;
      }

      var dataList = await _firebaseService.getData(
        collectionName: request.course.toLowerCase() == 'mca'
            ? FirebaseCollectionConstants.mcaLeaveApplications
            : FirebaseCollectionConstants.mbaLeaveApplications,
        documentId: request.studentId,
      );

      Map<String, dynamic>? document;
      if (dataList.isNotEmpty) {
        document = dataList.first;
      }

      List<dynamic> leaveRequests = [];
      if (document != null && document.containsKey("leaveRequests")) {
        leaveRequests = List.from(document["leaveRequests"]);
      }

      // Add new request
      leaveRequests.add(request.toMap());

      if (document != null) {
        await _firebaseService.updateData(
          collectionName: request.course.toLowerCase() == 'mca'
              ? FirebaseCollectionConstants.mcaLeaveApplications
              : FirebaseCollectionConstants.mbaLeaveApplications,
          documentId: request.studentId,
          updatedData: {"leaveRequests": leaveRequests},
        );
      } else {
        await _firebaseService.setData(
          collectionName: FirebaseCollectionConstants.mcaLeaveApplications,
          documentId: request.studentId,
          data: {"leaveRequests": leaveRequests},
        );
      }

      _leaveRequest.add(request);

      setViewState(state: ViewState.ideal); // or notifyListeners();
    } catch (e) {
      showException(error: e, retryMethod: () {
        addRequest(request: request);
      });
    }
  }
}

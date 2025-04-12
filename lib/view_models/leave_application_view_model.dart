import 'package:cloud_firestore/cloud_firestore.dart';
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
      //todo mca application
      var dataList = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.mcaLeaveApplications,
        documentId: student.studentId
      );

      if (dataList.isNotEmpty) {  // ✅ Ensure document exists
        var document = dataList.first;  // ✅ Get the first document (since it's a single document query)

        if (document.containsKey("leaveRequests")) {  // ✅ Ensure field exists
          var leaveRequests = document["leaveRequests"] as List<dynamic>;  // ✅ Extract the array

          for (var request in leaveRequests) {
            _leaveRequest.add(LeaveRequest.fromMap(request as Map<String, dynamic>));  // ✅ Convert each item in the array
          }
        }

      }
if(_leaveRequest.isNotEmpty){
  setViewState(state: ViewState.ideal);
}else if(_leaveRequest.isEmpty){
  setViewState(state: ViewState.empty);
}
    } catch (e, s) {
      showException(
          error: e,
          retryMethod: () {
            onModelReady(student: student);
          });
    }
  }

  Future<void> addRequest(
      {required LeaveRequest request, required Student student}) async {
    try {
      setViewState(state: ViewState.busy);
      DateTime now = DateTime.now();
      DateTime fromDate = DateTime.parse(request.fromDate);
      DateTime toDate = DateTime.parse(request.toDate);

      // ✅ Validation: Start and End date must be in the future
      if (fromDate.isBefore(now) || toDate.isBefore(now)) {
        showSnackBar(snackBarMessage: "Leave start and end dates must be in the future.");
        return;
      }

      var dataList = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.mcaLeaveApplications,
        documentId: '123456789',
      );

      Map<String, dynamic>? document;

      if (dataList.isNotEmpty) {
        document = dataList.first;
      }

      List<dynamic> leaveRequests = [];

      if (document != null && document.containsKey("leaveRequests")) {
        leaveRequests = List.from(document["leaveRequests"]);
      }

      // Add the new request to the list
      leaveRequests.add(request.toMap());

      if (document != null) {
        // Update Firestore if the document exists
        await _firebaseService.updateData(
          collectionName: FirebaseCollectionConstants.mcaLeaveApplications,
          documentId: "123456789",
          updatedData: {"leaveRequests": leaveRequests},
        );
      } else {
        // Create a new document if it does not exist
        await _firebaseService.setData(
          collectionName: FirebaseCollectionConstants.mcaLeaveApplications,
          documentId: "123456789",
          data: {"leaveRequests": leaveRequests},
        );
      }
      onModelReady(student: student);
    } catch (e) {
      print("Error: $e");
      showException(error: e, retryMethod: () {
            addRequest(request: request, student: student);
          });
    }
  }


}

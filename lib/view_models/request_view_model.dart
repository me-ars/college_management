import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/leave_request.dart';
import 'package:college_management/view_models/base_view_model.dart';
import '../core/services/firebase_service/firebase_service.dart';

class RequestViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  RequestViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  List<LeaveRequest> _verifiedRequest = [];

  List<LeaveRequest> get verifiedRequest => _verifiedRequest;
  List<LeaveRequest> _allrequest = [];

  List<LeaveRequest> _unVerifiedRequest = [];

  List<LeaveRequest> get unVerifiedRequest => _unVerifiedRequest;
  bool _fetchVerifiedList = false;

  bool get fetchVerifiedList => _fetchVerifiedList;

  void setVerifyFilter({required bool fetchVerified}) {
    print("setVerifyFilter called with: $fetchVerified"); // Debugging log
    _fetchVerifiedList = fetchVerified;
    notifyListeners(); // Ensure UI updates
  }
  Future<void> onModelReady(
      {required String facultyCourse, required String sem}) async {
    try {
      setViewState(state: ViewState.busy);

      // Clear previous data
      _allrequest.clear();
      _verifiedRequest.clear();
      _unVerifiedRequest.clear();

      var data = await _firebaseService.getData(
        collectionName: facultyCourse.toLowerCase() == "mca"
            ? FirebaseCollectionConstants.mcaLeaveApplications
            : FirebaseCollectionConstants.mbaLeaveApplications,
        documentId: "123456789", // Fetch a specific document
      );

      if (data.isNotEmpty) {
        var document = data.first; // Get the first document

        if (document.containsKey("leaveRequests")) {
          var requests = document["leaveRequests"] as List<dynamic>;

          for (var requestMap in requests) {
            LeaveRequest request = LeaveRequest.fromMap(requestMap);
            _allrequest.add(request);

            if (request.sem == sem) {
              if (request.verified) {
                _verifiedRequest.add(request);
              } else if (DateTime.parse(request.fromDate).isAfter(DateTime.now())) {
                _unVerifiedRequest.add(request);
              }
            }
          }
        }
      }

      if (_fetchVerifiedList) {
        if (_verifiedRequest.isEmpty) {
          setViewState(state: ViewState.empty);
        }
      } else {
        if (_unVerifiedRequest.isNotEmpty) {
          setViewState(state: ViewState.ideal);
        } else {
          setViewState(state: ViewState.empty);
        }
      }
    } catch (e) {
      showException(
        error: e,
        retryMethod: () => onModelReady(facultyCourse: facultyCourse, sem: sem),
      );
    }
  }


  clearAllRequests({required String facultyCourse}) async {
    try {
      List<String> deletableRequest = [];
      if (_allrequest.isNotEmpty) {
        for (var i in _allrequest) {
          deletableRequest.add(i.uid);
        }
      }
      await _firebaseService.deleteMultipleDocuments(
          collectionName: facultyCourse.toLowerCase() == "mca"
              ? FirebaseCollectionConstants.mcaLeaveApplications
              : FirebaseCollectionConstants.mbaLeaveApplications,
          documentIds: deletableRequest);
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            clearAllRequests(facultyCourse: facultyCourse);
          });
    }
  }
  Future<void> verifyRequest({required LeaveRequest request}) async {
    try {
      setViewState(state: ViewState.busy);

      // Fetch existing data
      var dataList = await _firebaseService.getData(
        collectionName: request.course.toLowerCase() == "mca"
            ? FirebaseCollectionConstants.mcaLeaveApplications
            : FirebaseCollectionConstants.mbaLeaveApplications,
        documentId: "123456789", // Fetch the correct document
      );

      Map<String, dynamic>? document;

      if (dataList.isNotEmpty) {
        document = dataList.first; // Get the first document
      }

      if (document == null || !document.containsKey("leaveRequests")) {
        print("⚠️ No leave requests found!");
        return;
      }

      List<dynamic> leaveRequests = List.from(document["leaveRequests"]);

      // Update the specific request in the list
      for (int i = 0; i < leaveRequests.length; i++) {
        LeaveRequest tempRequest = LeaveRequest.fromMap(leaveRequests[i]);
        if (tempRequest.uid == request.uid) {
          leaveRequests[i] = request.copyWith(verified: true).toMap();
          break;
        }
      }

      // Update Firestore
      await _firebaseService.updateData(
        collectionName: request.course.toLowerCase() == "mca"
            ? FirebaseCollectionConstants.mcaLeaveApplications
            : FirebaseCollectionConstants.mbaLeaveApplications,
        documentId: "123456789",
        updatedData: {
          "leaveRequests": leaveRequests
        },
      );

      // Move request to verified list
      _unVerifiedRequest.removeWhere((req) => req.uid == request.uid);
      _verifiedRequest.add(request.copyWith(verified: true));

      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
        error: e,
        retryMethod: () => verifyRequest(request: request),
      );
    }
  }

  Future addRequest() async {
    await _firebaseService.setData(
        collectionName: FirebaseCollectionConstants.mcaLeaveApplications,
        documentId: "123456789",
        data: LeaveRequest(
                studentLastName: "B",
                studentFirstName: "Aparna",
                uid: "123456789",
                studentId: "018",
                course: "MCA",
                sem: "2",
                fromDate: DateTime.now().add(Duration(days: 15)).toString(),
                toDate: DateTime.now().add(Duration(days: 16)).toString(),
                appliedDate: DateTime.now().toString(),
                reason: "FEVER",
                verified: false)
            .toMap());
  }
}

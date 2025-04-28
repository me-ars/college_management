import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/leave_request.dart';
import 'package:college_management/view_models/base_view_model.dart';
import '../core/services/firebase_service/firebase_service.dart';
class RequestViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  RequestViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  final List<LeaveRequest> _allRequests = [];
  final List<LeaveRequest> _verifiedRequests = [];
  final List<LeaveRequest> _unverifiedRequests = [];

  bool _showVerified = false;

  List<LeaveRequest> get verifiedRequests => _verifiedRequests;
  List<LeaveRequest> get unverifiedRequests => _unverifiedRequests;
  bool get showVerified => _showVerified;

  void setVerifyFilter({required bool showVerified}) {
    _showVerified = showVerified;
    notifyListeners();
  }

  Future<void> onModelReady({required String facultyCourse, required String sem}) async {
    try {
      setViewState(state: ViewState.busy);

      // Clear existing data
      _allRequests.clear();
      _verifiedRequests.clear();
      _unverifiedRequests.clear();

      // Fetch data
      final data = await _firebaseService.getData(
        collectionName: facultyCourse.toLowerCase() == "mca"
            ? FirebaseCollectionConstants.mcaLeaveApplications
            : FirebaseCollectionConstants.mbaLeaveApplications,
      );

      if (data.isNotEmpty) {
        final document = data.first;

        if (document.containsKey("leaveRequests")) {
          final requests = List<Map<String, dynamic>>.from(document["leaveRequests"]);

          for (var map in requests) {
            final request = LeaveRequest.fromMap(map);
            if (request.sem != sem) continue;

            _allRequests.add(request);
            if (request.verified) {
              _verifiedRequests.add(request);
            } else if (DateTime.parse(request.fromDate).isAfter(DateTime.now())) {
              _unverifiedRequests.add(request);
            }
          }
        }
      }

      _updateViewStateBasedOnFilter();

    } catch (e) {
      showException(
        error: e,
        retryMethod: () => onModelReady(facultyCourse: facultyCourse, sem: sem),
      );
    }
  }

  void _updateViewStateBasedOnFilter() {
    if (_showVerified) {
      if (_verifiedRequests.isEmpty) {
        setViewState(state: ViewState.empty);
      } else {
        setViewState(state: ViewState.ideal);
      }
    } else {
      if (_unverifiedRequests.isEmpty) {
        setViewState(state: ViewState.empty);
      } else {
        setViewState(state: ViewState.ideal);
      }
    }
  }

  Future<void> verifyRequest({required LeaveRequest request}) async {
    try {
      setViewState(state: ViewState.busy);

      final dataList = await _firebaseService.getData(
        collectionName: request.course.toLowerCase() == "mca"
            ? FirebaseCollectionConstants.mcaLeaveApplications
            : FirebaseCollectionConstants.mbaLeaveApplications,
        documentId: request.studentId,
      );

      if (dataList.isEmpty || !dataList.first.containsKey("leaveRequests")) {
        setViewState(state: ViewState.empty);
        return;
      }

      final document = dataList.first;
      final List<Map<String, dynamic>> leaveRequests =
      List<Map<String, dynamic>>.from(document["leaveRequests"]);

      for (int i = 0; i < leaveRequests.length; i++) {
        final tempRequest = LeaveRequest.fromMap(leaveRequests[i]);
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
        documentId: request.studentId,
        updatedData: {"leaveRequests": leaveRequests},
      );

      // Update local lists
      _unverifiedRequests.removeWhere((r) => r.uid == request.uid);
      _verifiedRequests.add(request.copyWith(verified: true));

      _updateViewStateBasedOnFilter();

    } catch (e) {
      showException(
        error: e,
        retryMethod: () => verifyRequest(request: request),
      );
    }
  }

  Future<void> clearAllRequests({required String facultyCourse}) async {
    try {
      final idsToDelete = _allRequests.map((r) => r.uid).toList();

      if (idsToDelete.isNotEmpty) {
        await _firebaseService.deleteMultipleDocuments(
          collectionName: facultyCourse.toLowerCase() == "mca"
              ? FirebaseCollectionConstants.mcaLeaveApplications
              : FirebaseCollectionConstants.mbaLeaveApplications,
          documentIds: idsToDelete,
        );
      }

      _allRequests.clear();
      _verifiedRequests.clear();
      _unverifiedRequests.clear();
      setViewState(state: ViewState.empty);

    } catch (e) {
      showException(
        error: e,
        retryMethod: () => clearAllRequests(facultyCourse: facultyCourse),
      );
    }
  }
}

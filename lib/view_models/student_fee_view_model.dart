import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/fee_model.dart';
import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:college_management/view_models/base_view_model.dart';

class StudentFeeViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  StudentFeeViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  List<Fee> _fee = [];

  List<Fee> get fee => _fee;

  Future<void> onModelReady({required String studentId}) async {
    try {
      setViewState(state: ViewState.busy);
      var data = await _firebaseService.getData(
          collectionName: FirebaseCollectionConstants.fee,
          documentId: '2607');
      if (data.isNotEmpty) {
        var document = data.first;
        if (document.containsKey("feeDetails")) {
          var leaveRequests = document["feeDetails"] as List<dynamic>;

          for (var request in leaveRequests) {
            _fee.add(Fee.fromMap(request as Map<String, dynamic>));
          }
        }
        setViewState(state: ViewState.ideal);
      } else {
        setViewState(state: ViewState.empty);
      }
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            onModelReady(studentId: studentId);
          });
    }
  }
}

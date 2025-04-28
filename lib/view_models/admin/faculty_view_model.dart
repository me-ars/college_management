import 'package:college_management/view_models/base_view_model.dart';
import '../../core/constants/firebase_collection_constants.dart';
import '../../core/enums/view_state.dart';
import '../../core/models/faculty.dart';
import '../../core/services/firebase_service/firebase_service.dart';

class FacultyViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  FacultyViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  List<Faculty> _faculty = [];

  List<Faculty> get faculty => _faculty;

  onModelReady() async {
    try {
      setViewState(state: ViewState.busy);
     await _fetchUsers();
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
        error: e,
        retryMethod: () {
          onModelReady();
        },
      );
    }
  }
Future<void> _fetchUsers()async{
  {
      var data = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.users,
      );

      if (data != null && data.isNotEmpty) {
        _faculty = [];
        // _students = [];

        for (var item in data) {
          if (item.containsKey("employeeId")) {
            _faculty.add(Faculty.fromMap(item)); // Faculty
          }
        }
      } else {
        showSnackBar(snackBarMessage: "⚠️ No user data found.");
      }
    }
  }
  deleteUser({required String uid, required int index}) async {
    try {
      setViewState(state: ViewState.busy);
      await _firebaseService.deleteData(
          collectionName: FirebaseCollectionConstants.users, documentId: uid);
      _faculty.removeAt(index);
      showSnackBar(snackBarMessage: 'Faculty deleted successfully');
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(error: e, retryMethod: deleteUser(uid: uid, index: index));
    }
  }


  assignAsHod({required Faculty faculty}) async {
    try {
      setViewState(state: ViewState.busy);
      Faculty hod = faculty.copyWith(isHOD: true);
      await _firebaseService.updateData(
          collectionName: FirebaseCollectionConstants.users,
          documentId: faculty.employeeId,
          updatedData: hod.toMap());
showSnackBar(snackBarMessage: "Assigned as HOD");
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            assignAsHod(faculty: faculty);
          });
    }
  }
}

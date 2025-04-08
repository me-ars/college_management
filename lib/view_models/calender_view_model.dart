
import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/calender_event_model.dart';
import 'package:college_management/view_models/base_view_model.dart';
import '../core/services/firebase_service/firebase_service.dart';

class CalenderViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  CalenderViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  List<CalenderEventModel> _events = [];

  List<CalenderEventModel> get events => _events;

  onModelReady() async {
    try {
      setViewState(state: ViewState.busy);
      var response = await _firebaseService.getData(
          collectionName: FirebaseCollectionConstants.calenderEvents);
      if (!response.isEmpty) {
        for (var event in response) {
          _events.add(CalenderEventModel.fromMap(event));
        }
      }
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            onModelReady();
          });
    }
  }

  addEvent({required CalenderEventModel eventModel}) async {
    try {
      setViewState(state: ViewState.busy);
      await _firebaseService.setData(
          documentId: eventModel.date,
          collectionName: FirebaseCollectionConstants.calenderEvents,
          data: eventModel.toMap());
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            addEvent(eventModel: eventModel);
          });
    }
  }
}

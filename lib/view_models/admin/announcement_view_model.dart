import 'dart:async';

import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/announcement_model.dart';
import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:college_management/view_models/base_view_model.dart';

class AnnouncementViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  AnnouncementViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  List<AnnouncementModel> _announcements = [];

  List<AnnouncementModel> get announcements => _announcements;

  onModelReady() async {
    try {
      setViewState(state: ViewState.busy);
      await _fetchAnnouncements();
      setViewState(
          state: _announcements.isEmpty ? ViewState.empty : ViewState.ideal);
    } catch (e) {
      showException(error: e, retryMethod: onModelReady);
    }
  }

  Future<void> _fetchAnnouncements() async {
    try {
      setViewState(state: ViewState.busy);
      var announcements = await _firebaseService.getData(
          collectionName: FirebaseCollectionConstants.announcements);

      if (announcements != null) {
        _announcements = announcements
            .map<AnnouncementModel>((data) => AnnouncementModel.fromMap(data))
            .toList();
      }
      setViewState(state: ViewState.ideal);

      // TODO: Add filtering for users according to their course.
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAnnouncement({required String uid}) async {
    try {
      setViewState(state: ViewState.busy);
      await _firebaseService.deleteData(
          collectionName: FirebaseCollectionConstants.announcements,
          documentId: uid);

      _announcements.removeWhere((element) => element.uid == uid);

      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(error: e, retryMethod: () => deleteAnnouncement(uid: uid));
    }
  }

  Future<void> sendAnnouncements({required String message}) async {
    try {
      String uid = DateTime.now().toString();

      await _firebaseService.setData(
          collectionName: FirebaseCollectionConstants.announcements,
          documentId: uid,
          data: AnnouncementModel(
                  course: "MCA",
                  uid: uid,
                  date: DateTime.now().toString(),
                  message: message)
              .toMap());

      await _fetchAnnouncements();
    } catch (e) {
      showException(
          error: e, retryMethod: () => sendAnnouncements(message: message));
    }
  }
}

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

  onModelReady({required String course,required bool isAdminOrHod}) async {
    try {
      setViewState(state: ViewState.busy);
      await _fetchAnnouncements(course: course);
      if(isAdminOrHod){
        setViewState(state: ViewState.ideal);
      }
     else {
        setViewState(
            state: _announcements.isEmpty ? ViewState.empty : ViewState.ideal);
      }
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            onModelReady(course: course,isAdminOrHod: isAdminOrHod
            );
          });
    }
  }
  Future<void> _fetchAnnouncements({required String course}) async {
    try {
      List<AnnouncementModel> allAnnouncements = [];
      var announcements = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.announcements,
      );

      if (announcements != null) {
        for (var announcement in announcements) {
          allAnnouncements.add(AnnouncementModel.fromMap(announcement));
        }

        if (course.toLowerCase() == 'admin') {
          // If the user is admin, fetch all announcements
          _announcements.addAll(allAnnouncements);
        } else {
          // Otherwise, filter announcements for course or admin
          for (var announcement in allAnnouncements) {
            if (announcement.course.toLowerCase() == 'admin' ||
                announcement.course.toLowerCase() == course.toLowerCase()) {
              _announcements.add(announcement);
            }
          }
        }
      }
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

  Future<void> sendAnnouncements(
      {required String message, required String course}) async {
    try {
      String uid = DateTime.now().toString();

      await _firebaseService.setData(
          collectionName: FirebaseCollectionConstants.announcements,
          documentId: uid,
          data: AnnouncementModel(
                  course: course,
                  uid: uid,
                  date: DateTime.now().toString(),
                  message: message)
              .toMap());

      await _fetchAnnouncements(course: course);
    } catch (e) {
      showException(
          error: e,
          retryMethod: () =>
              sendAnnouncements(message: message, course: course));
    }
  }
}

import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/contact_us_model.dart';
import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:college_management/view_models/base_view_model.dart';

class ContactUsViewModel extends BaseViewModel {
  final FirebaseService _firebaseService;

  ContactUsViewModel({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  ContactUsModel? _contactUsModel;

  ContactUsModel? get contactUsModel => _contactUsModel;

  onModelReady() async {
    try {
      setViewState(state: ViewState.busy);
      await _fetchData();
      if (_contactUsModel != null) {
        setViewState(state: ViewState.ideal);
      } else {
        setViewState(state: ViewState.empty);
      }
    } catch (e) {
      showException(error: e, retryMethod: () {
        onModelReady();
      });
    }
  }

  _fetchData() async {
    var response = await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.contactDetails);

      _contactUsModel = ContactUsModel.fromMap(response[0]);

  }
add()async{
    await _firebaseService.setData(collectionName:FirebaseCollectionConstants.contactDetails , documentId: "contactUs", data: ContactUsModel(email: "aparna@gmail.com", phone: "").toMap());
}
  updateData({required ContactUsModel contactUsModel}) async {
    try {
      setViewState(state: ViewState.busy);
      await _firebaseService.setData(
          collectionName: FirebaseCollectionConstants.contactDetails,
          documentId: "contactUs",
          data: ContactUsModel(email: contactUsModel.email, phone: contactUsModel.phone).toMap());
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(error: e, retryMethod: () {
        updateData(contactUsModel: contactUsModel);
      });
    }
  }
}

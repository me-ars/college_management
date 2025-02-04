abstract class FirebaseService {
  Future<void> setData(
      {required String collectionName,
      required String documentId,
      required Map<String, dynamic> data});

  Future<dynamic> getData({required String collectionName, String? documentId});
}

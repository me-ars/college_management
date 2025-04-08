abstract class FirebaseService {
  Future<void> setData(
      {required String collectionName,
      required String documentId,
      required Map<String, dynamic> data});

  Future<dynamic> getData({
    required String collectionName,
    String? documentId,
    String? filterField,
    dynamic filterValue,
  });

  Future<List<String>> getDocumentIdsByStudentIdInAttendance({
    required String collectionName,
    required String studentId,
  });
  Future<void> deleteData(
      {required String collectionName, required String documentId});

  Future<void> updateData({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> updatedData,
  });
  Future<void> deleteMultipleDocuments({
    required String collectionName,
    required List<String> documentIds,
  });
}

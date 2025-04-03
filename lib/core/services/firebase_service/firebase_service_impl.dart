import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:flutter/foundation.dart';
class FirebaseServiceImpl extends FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> setData({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).set(data, SetOptions(merge: true));
      debugPrint("✅ Data successfully set in $collectionName/$documentId");
    } catch (e, stackTrace) {
      debugPrint("❌ Error setting data: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getData({
    required String collectionName,
    String? documentId,
    String? filterField,
    dynamic filterValue,
  }) async {
    try {
      if (documentId != null) {
        DocumentSnapshot documentSnapshot = await _firestore.collection(collectionName).doc(documentId).get();
        if (documentSnapshot.exists) {
          return [documentSnapshot.data() as Map<String, dynamic>];
        } else {
          debugPrint("⚠️ Document $documentId does not exist in $collectionName.");
          return [];
        }
      } else {
        Query query = _firestore.collection(collectionName);

        if (filterField != null && filterValue != null) {
          query = query.where(filterField, isEqualTo: filterValue);
        }

        QuerySnapshot querySnapshot = await query.get();
        List<Map<String, dynamic>> documents =
        querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return documents;
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error getting data: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> deleteData({
    required String collectionName,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
      debugPrint("✅ Data successfully deleted from $collectionName/$documentId");
    } catch (e, stackTrace) {
      debugPrint("❌ Error deleting data: $e\nStackTrace: $stackTrace");
      throw FirebaseException;
    }
  }

  /// Updates specific fields of a document in Firestore
   @override
  Future<void> updateData({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(updatedData);
      debugPrint("✅ Data successfully updated in $collectionName/$documentId");
    } catch (e, stackTrace) {
      debugPrint("❌ Error updating data: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }
  @override
  Future<void> deleteMultipleDocuments({
    required String collectionName,
    required List<String> documentIds,
  }) async {
    try {
      for (String documentId in documentIds) {
        await _firestore.collection(collectionName).doc(documentId).delete();
      }
      debugPrint("✅ Successfully deleted multiple documents from $collectionName");
    } catch (e, stackTrace) {
      debugPrint("❌ Error deleting multiple documents: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }
}


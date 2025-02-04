import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class FirebaseServiceImpl extends FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> setData({required String collectionName, required String documentId, required Map<String, dynamic> data}) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).set(data, SetOptions(merge: true));
      debugPrint("✅ Data successfully set in $collectionName/$documentId");
    } catch (e, stackTrace) {
      debugPrint("❌ Error setting data: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }

  @override
  Future<dynamic> getData({required String collectionName, String? documentId}) async {
    try {
      if (documentId != null) {
        // Fetch single document
        DocumentSnapshot documentSnapshot = await _firestore.collection(collectionName).doc(documentId).get();
        if (documentSnapshot.exists) {
          return documentSnapshot.data();
        } else {
          debugPrint("⚠️ Document $documentId does not exist in $collectionName.");
          return null;
        }
      } else {
        // Fetch all documents in the collection
        QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
        List<Map<String, dynamic>> documents =
        querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        return documents;
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error getting data: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }
}

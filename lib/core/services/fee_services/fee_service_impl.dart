import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_management/core/models/fee_model.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_service/firebase_service.dart';
import 'fee_service.dart';
class FeeServiceImpl implements FeeService {
  final FirebaseService _firebaseService;

  FeeServiceImpl({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  @override
  Future<void> addFeeData(String documentId, Fee fee) async {
    try {
      await _firebaseService.setData(
        collectionName: "fees",
        documentId: documentId,
        data: {
          "feeDetails": FieldValue.arrayUnion([fee.toMap()])
        },
      );

      debugPrint("✅ Fee data successfully added to $documentId");
    } catch (e, stackTrace) {
      debugPrint("❌ Error adding fee data: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }

  Future<List<Fee>> getFeeData(String documentId) async {
    try {
      List<Map<String, dynamic>> result = await _firebaseService.getData(
        collectionName: "fees",
        documentId: documentId,
      );

      if (result.isNotEmpty) {
        Map<String, dynamic> data = result.first;
        List<dynamic> feeList = data["feeDetails"] ?? [];

        List<Fee> fees = feeList.map((fee) => Fee.fromMap(fee)).toList();

        debugPrint("✅ Retrieved ${fees.length} fee records for $documentId");
        return fees;
      } else {
        debugPrint("⚠️ No fee data found for $documentId");
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error fetching fee data: $e\nStackTrace: $stackTrace");
      return [];
    }
  }
  /// Deletes a specific fee entry from the feeDetails array by uid.
  Future<void> deleteFeeData(String documentId, String feeUid) async {
    try {
      // Fetch the existing feeDetails array
      List<Fee> fees = await getFeeData(documentId);

      // Filter out the fee with the given uid
      List<Fee> updatedFees = fees.where((fee) => fee.uid != feeUid).toList();

      // Convert updated list to Map format
      List<Map<String, dynamic>> updatedFeeList = updatedFees.map((fee) => fee.toMap()).toList();

      // Update Firestore with the new fee list
      await _firebaseService.setData(
        collectionName: "fees",
        documentId: documentId,
        data: {
          "feeDetails": updatedFeeList,
        },
      );

      debugPrint("✅ Successfully deleted fee with uid: $feeUid from $documentId");
    } catch (e, stackTrace) {
      debugPrint("❌ Error deleting fee data: $e\nStackTrace: $stackTrace");
      rethrow;
    }
  }
}
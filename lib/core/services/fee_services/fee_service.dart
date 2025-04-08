import 'package:college_management/core/models/fee_model.dart';

abstract class FeeService{
  Future<void> addFeeData(String documentId, Fee fee) ;

}
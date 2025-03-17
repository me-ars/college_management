import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/services/fee_services/fee_service.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../../core/models/fee_model.dart';

class FeeViewModel extends BaseViewModel {
  final FeeService _feeService;

  FeeViewModel({required FeeService feeService}) : _feeService = feeService;

  Future addFee({required String studentUid, required Fee fee}) async {
    try {
      setViewState(state: ViewState.busy);
      _feeService.addFeeData(studentUid, fee);
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            addFee(studentUid: studentUid, fee: fee);
          });
    }
  }
}

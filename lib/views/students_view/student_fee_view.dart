import 'package:college_management/app/base_view.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/view_models/student_fee_view_model.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:flutter/material.dart';
class StudentFeeView extends StatelessWidget {
  const StudentFeeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BaseView<StudentFeeViewModel>(
      onModelReady: (StudentFeeViewModel model) {
        model.onModelReady(studentId: '2607');
      },
      refresh: (StudentFeeViewModel model) {},
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Fee details'),
              backgroundColor: AppPalette.violetLt,
            ),
            body: Column(
              children: [
                if (model.viewState == ViewState.ideal)
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.fee.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(color: AppPalette.violetLt,
                            child: ListTile(
                              title: Text('Sem ${model.fee[index].sem}'),
                              subtitle: Text(' Fee ${model.fee[index].feeFor}'),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else if (model.viewState == ViewState.busy)
                  Expanded(
                    child: Center(
                      child: LoadingView(
                        height: size.height * 0.3,
                        width: size.width / 2.5,
                      ),
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No fee details available",
                        style: TextStyle(color: AppPalette.primaryTextColor),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:college_management/app/app_state.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/base_view.dart';
import '../view_models/admin/announcement_view_model.dart';

class AnnouncementView extends StatefulWidget {
  const AnnouncementView({super.key});

  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView> {
  void _showFullMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: AppPalette.offWhite,
          title: const Text(" Message",style: TextStyle(color: AppPalette.primaryTextColor),),
          content: Text(message,style: const TextStyle(color: AppPalette.primaryTextColor),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  TextEditingController _announcementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<AnnouncementViewModel>(
        onModelReady: (AnnouncementViewModel model) {
          String course = context.read<AppState>().isAdmin
              ? "admin"
              : context.read<AppState>().student != null
                  ? context.read<AppState>().student!.course
                  : context.read<AppState>().faculty!.course;
          model.onModelReady(course: course,isAdminOrHod:context.read<AppState>().isAdmin ||
              (context.read<AppState>().faculty != null &&
                  context.read<AppState>().faculty?.isHOD == true));
        },
        onDispose:(AnnouncementViewModel model) {
          _announcementController.clear();
        },
        refresh: (AnnouncementViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
                backgroundColor: AppPalette.violetLt,
                title: const Text("Announcements")),
            body: model.viewState==ViewState.ideal?Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: model.announcements.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width * 0.85,
                          decoration: BoxDecoration(
                              color: AppPalette.violetLt,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            trailing: Visibility(
                              visible: context.read<AppState>().isAdmin &&
                                  context.read<AppState>().faculty != null,
                              child: IconButton(
                                onPressed: () {
                                  model.deleteAnnouncement(
                                      uid: model.announcements[index].uid);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppPalette.primaryTextColor,
                                ),
                              ),
                            ),
                            title: Text(model.announcements[index].message),
                            onTap: () => _showFullMessage(
                                model.announcements[index].message),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: context.read<AppState>().isAdmin ||
                      (context.read<AppState>().faculty != null &&
                          context.read<AppState>().faculty?.isHOD == true),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: size.height * 0.1,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              isPassword: false,
                              width: size.width * 0.8,
                              height: size.height * 0.1,
                              labelText: "Enter the message",
                              textEditingController: _announcementController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            width: size.width * 0.1,
                            height: size.height * 0.1,
                            onPressed: () {
                              model.sendAnnouncements(
                                course: context.read<AppState>().isAdmin
                                    ? "admin"
                                    : context.read<AppState>().student != null
                                    ? context.read<AppState>().student!.course
                                    : context.read<AppState>().faculty!.course,
                                message: _announcementController.text,
                              );
                              _announcementController.clear();
                            },
                            label: ">",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


              ],
                  )
                : model.viewState == ViewState.empty
                    ? const Center(
                        child: Text(
                          'No announcement',
                          style: TextStyle(color: AppPalette.primaryTextColor),
                        ),
                      )
                    : LoadingView(
                        height: size.height * 0.3, width: size.width / 2.5),
          ));
        });
  }
}

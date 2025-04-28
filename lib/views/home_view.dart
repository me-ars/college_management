import 'package:college_management/app/app_state.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/constants/route_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/views/shared/gallery_tile.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app/base_view.dart';
import '../view_models/home_view_model.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseView<HomeViewModel>(
      onModelReady: (HomeViewModel model) {
        model.onModelReady();
      },
      refresh: (HomeViewModel model) {},
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: model.viewState == ViewState.ideal
                ? Center(
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          homeScreeHead(
                            height: size.height / 5.2,
                            width: size.width,
                              avatarText:
                                  context.read<AppState>().faculty != null
                                      ? context
                                          .read<AppState>()
                                          .faculty!
                                          .firstName[0]
                                          .toUpperCase()
                                      : context.read<AppState>().student != null
                                          ? context
                                              .read<AppState>()
                                              .student!
                                              .firstName[0]
                                              .toUpperCase()
                                          : 'A',
                              context: context),
                          SizedBox(height: size.height * 0.02),
                          Center(
                              child: context.read<AppState>().faculty != null
                                  ? facultyHomeBody(context: context)
                                  : context.read<AppState>().student != null
                                      ? studentHomeBody(context: context)
                                      : adminHomeBody(context: context)),
                          Center(
                            child: GalleryTile(
                              height: size.height / 5.2,
                              width: size.width * 0.9,
                              images: const [
                                "assets/demo_images/1.jpeg",
                                "assets/demo_images/11.jpeg",
                                "assets/demo_images/2.jpeg",
                                "assets/demo_images/3.jpeg"
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                        ],
                      ),
                    ),
                )
                : LoadingView(
                    height: size.height * 0.3, width: size.width / 2.5),
          ),
        );
      },
    );
  }
}

Widget homeScreeHead(
    {required double height,
    required double width,
    required String avatarText,
    required BuildContext context}) {
  return Container(
    height: height,
    decoration: const BoxDecoration(
        color: AppPalette.violetLt,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
    child: Padding(
      padding: EdgeInsets.only(left: width * 0.065),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
              height: height * 0.3,
              image: const AssetImage("assets/mes aimat.png")),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.read<AppState>().faculty != null
                        ? context.read<AppState>().faculty!.firstName
                        : context.read<AppState>().student != null
                            ? context.read<AppState>().student!.firstName
                            : "Admin",
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.primaryTextColor),
                  ),
                  Text(
                    context.read<AppState>().faculty != null
                        ? '${context.read<AppState>().faculty!.course} Faculty'
                        : context.read<AppState>().student != null
                            ? context.read<AppState>().student!.course
                            : "Admin",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.primaryTextColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.goNamed(RouteConstants.profileView);
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.4, bottom: height * 0.15),
                  child: CircleAvatar(
                    backgroundColor: AppPalette.offWhite,
                    child: Text(
                      avatarText,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.primaryTextColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget adminHomeBody({required BuildContext context}) {
  Size size =MediaQuery.of(context).size;
 var tileHeight=size.height * 0.2;
var tileWidth=size.width / 4;
  return Wrap(
    spacing: 5, // Space between items horizontally
    runSpacing: 10.0, // Space between items vertically
    alignment: WrapAlignment.center, // Center align items
    children: [
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.teachersView);
        },
        iconImage: "assets/icons/teacher.png",
        optionName: "Teachers",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.studentsView);
        },
        iconImage: "assets/icons/students.png",
        optionName: "Students",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.calenderView);
        },
        iconImage: "assets/icons/calender.png",
        optionName: "Calender",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.announcements);
        },
        iconImage: "assets/icons/announcement.png",
        optionName: "Announcements",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.contactDetails);
        },
        iconImage: "assets/icons/attendance.png",
        optionName: "Contact details",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.feeDetails);
        },
        iconImage: "assets/icons/money.png",
        optionName: "Fee",
      ),

    ],
  );
}

Widget facultyHomeBody({required BuildContext context}) {
  Size size = MediaQuery.of(context).size;
  var tileHeight = size.height * 0.15;
  var tileWidth = size.width / 4;
  return LayoutBuilder(
    builder: (context, constraints) {
      return Wrap(
        spacing: 5,
        runSpacing: 10.0,
        alignment: WrapAlignment.start, // Ensures elements align properly
        children: [
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.internalMarks);
            },
            iconImage: "assets/icons/mark.png",
            optionName: "Internal Mark",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.studentsView);
            },
            iconImage: "assets/icons/students.png",
            optionName: "Students",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.calenderView);
            },
            iconImage: "assets/icons/calender.png",
            optionName: "Calender",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.announcements);
            },
            iconImage: "assets/icons/announcement.png",
            optionName: "Announcements",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.contactDetails);
            },
            iconImage: "assets/icons/contact-mail.png",
            optionName: "Contact details",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.attendance);
            },
            iconImage: "assets/icons/attendance.png",
            optionName: "Attendance",
          ),
          // Last row with left alignment
          Row(
            mainAxisSize: MainAxisSize.min, // Prevents extra space
            children: [
              CustomIconTile(
                height: tileHeight,
                width: tileWidth,
                onTap: () {
                  context.goNamed(RouteConstants.leaveRequest);
                },
                iconImage: "assets/icons/request_.png",
                optionName: "Request",
              ),
              // CustomIconTile(
              //   height: tileHeight,
              //   width: tileWidth,
              //   onTap: () {
              //     context.goNamed(RouteConstants.feeDetails);
              //   },
              //   iconImage: "assets/icons/money.png",
              //   optionName: "Fee",
              // ),
            ],
          ),
        ],
      );
    },
  );
}
Widget studentHomeBody({required BuildContext context}) {
  Size size = MediaQuery.of(context).size;
  var tileHeight = size.height * 0.15;
  var tileWidth = size.width / 4;
  return LayoutBuilder(
    builder: (context, constraints) {
      return Wrap(
        spacing: 5,
        runSpacing: 10.0,
        alignment: WrapAlignment.start, // Ensures elements align properly
        children: [
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.studentInternalMark);
            },
            iconImage: "assets/icons/mark.png",
            optionName: "Internal Mark",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.calenderView);
            },
            iconImage: "assets/icons/calender.png",
            optionName: "Calender",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.announcements);
            },
            iconImage: "assets/icons/announcement.png",
            optionName: "Announcements",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.contactDetails);
            },
            iconImage: "assets/icons/contact-mail.png",
            optionName: "Contact details",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.studentAttendance);
            },
            iconImage: "assets/icons/attendance.png",
            optionName: "Attendance",
          ),
          CustomIconTile(
            height: tileHeight,
            width: tileWidth,
            onTap: () {
              context.goNamed(RouteConstants.viewFee);
            },
            iconImage: "assets/icons/money.png",
            optionName: "View Fee",
          ),
          // Last row with left alignment
          Row(
            mainAxisSize: MainAxisSize.min, // Prevents extra space
            children: [
              CustomIconTile(
                height: tileHeight,
                width: tileWidth,
                onTap: () {
                  context.goNamed(RouteConstants.sendRequest);
                },
                iconImage: "assets/icons/request_.png",
                optionName: "Request",
              ),
            ],
          ),
        ],
      );
    },
  );
}



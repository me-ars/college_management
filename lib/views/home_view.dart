import 'package:college_management/app/app_state.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/constants/route_constants.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/views/shared/gallery_tile.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
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
    print(context.read<AppState>().faculty);
    Size size = MediaQuery.of(context).size;
    return BaseView<HomeViewModel>(
      onModelReady: (HomeViewModel model){
        model.onModelReady();
      },
        refresh: (HomeViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: model.viewState == ViewState.ideal
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          homeScreeHead(
                              height: size.height / 5.2,
                              width: size.width,
                              avatarText: "A"),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Center(
                            child: GalleryTile(
                                height: size.height / 5.2,
                                width: size.width * 0.9,
                                images: const [
                                  "assets/demo_images/1.jpeg",
                                  "assets/demo_images/11.jpeg",
                                  "assets/demo_images/2.jpeg",
                                  "assets/demo_images/3.jpeg"
                                ]),
                          ),
                          Expanded(
                            child: adminHomeBody(
                              context: context,
                            ),
                          )
                        ],
                      ),
                    )
                  : LoadingView(
                      height: size.height * 0.3, width: size.width / 2.5),
            ),
          );
        });
  }
}

Widget homeScreeHead(
    {required double height,
    required double width,
    required String avatarText}) {
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
               const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Anandu Rs",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.primaryTextColor),
                  ),
                  Text(
                   "Admin",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.primaryTextColor),
                  ),
                ],
              ),
              Padding(
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
        iconImage: "",
        optionName: "Teachers",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.studentsView);
        },
        iconImage: "",
        optionName: "Students",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.calenderView);
        },
        iconImage: "",
        optionName: "Calender",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.announcements);
        },
        iconImage: "",
        optionName: "Announcements",
      ),
      CustomIconTile(
        height: tileHeight,
        width: tileWidth,
        onTap: () {
          context.goNamed(RouteConstants.contactDetails);
        },
        iconImage: "",
        optionName: "Contact details",
      ),
    ],
  );
  //   GridView.builder(
  //   itemCount: 4,
  //   gridDelegate:
  //       const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //   itemBuilder: (context, index) {
  //     return CustomIconTile(
  //         height: height,
  //         width: width,
  //         onTap: () {
  //           context.goNamed(RouteConstants.calenderView);
  //         },
  //         iconImage: "",
  //         optionName: iconNames[index]);
  //   },
  // );
}

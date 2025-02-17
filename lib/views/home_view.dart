import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/views/shared/gallery_tile.dart';
import 'package:college_management/views/shared/loading_view.dart';
import 'package:college_management/views/widgets/custom_icon_tile.dart';
import 'package:flutter/material.dart';
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
      onModelReady: (HomeViewModel model){
        model.onModelReady();
      },
        refresh: (HomeViewModel model) {},
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: model.viewState == ViewState.ideal
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        homeScreeHead(
                            height: size.height / 5.2,
                            width: size.width,
                            avatarText: "A"),
                        GalleryTile( height: size.height / 5.2,
                            width: size.width,images: []),
                        Expanded(
                          child: adminHomeBody(
                            height: size.height / 4,
                            width: size.width / 2.5,
                          ),
                        )
                      ],
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

Widget adminHomeBody({required double height, required double width}) {
  List<String> iconNames = ["Teachers", "Students", "Fee", "Calender"];
  return GridView.builder(
    itemCount: 4,
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (context, index) {
      return CustomIconTile(
          height: height,
          width: width,
          onTap: () {},
          iconImage: "",
          optionName: iconNames[index]);
    },
  );
}

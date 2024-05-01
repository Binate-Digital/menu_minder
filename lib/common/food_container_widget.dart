import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/profile_banner_widget.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/spooncular/data/spooncular_random_reciepies_model.dart';
import 'package:menu_minder/view/user_profile/screens/friends_profile_screen.dart';
import 'package:provider/provider.dart';

import '../utils/app_constants.dart';
import '../utils/asset_paths.dart';
import '../utils/styles.dart';
import '../view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'custom_extended_image_with_loading.dart';

class FoodContainer extends StatelessWidget {
  final int index;
  final RecipeModel? recipeModel;
  final bool? isSelected;
  final double? imageWidth;
  final double? imageHeight;
  const FoodContainer({
    super.key,
    required this.onTap,
    required this.index,
    this.isSelected,
    this.recipeModel,
    this.imageWidth,
    this.imageHeight,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    print("Recieipe Model: ${recipeModel?.toJson().toString()}");
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8, bottom: 8),
          decoration: BoxDecoration(
              color: AppColor.COLOR_WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: AppColor.THEME_COLOR_SECONDARY.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 10)
              ]),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // recipeModel != null
                  //     ? ClipRRect(
                  //         borderRadius: BorderRadius.circular(20),
                  //         child: Container(
                  //           height: 100,
                  //           width: 150,
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(20)),
                  //           child: recipeModel != null &&
                  //                   recipeModel!.recipeImages!.isEmpty
                  //               ? Center(
                  //                   child: Image.asset(
                  //                   AssetPath.PHOTO_PLACE_HOLDER,
                  //                   scale: 2,
                  //                 ))
                  //               : ExtendedImage.network(dotenv.get('IMAGE_URL') +
                  //                   recipeModel!.recipeImages![0]),
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  recipeModel != null
                      ? Container(
                          height: imageHeight ?? 100,
                          width: imageWidth ??
                              MediaQuery.of(context).size.width / 2,
                          // margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(14),
                          ),
                          child: recipeModel?.recipeImages != null &&
                                  recipeModel!.recipeImages!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: MyCustomExtendedImage(
                                    imageUrl: recipeModel!.recipeImages![0]
                                            .startsWith('http')
                                        ? recipeModel!.recipeImages![0]
                                        : dotenv.get('IMAGE_URL') +
                                            recipeModel!.recipeImages![0],
                                  ),
                                )
                              : Center(
                                  child: Image.asset(
                                    AssetPath.PHOTO_PLACE_HOLDER,
                                    fit: BoxFit.cover,
                                    scale: 2,
                                  ),
                                ),
                        )
                      : const SizedBox(),
                  AppStyles.height8SizedBox(),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2,
                  //   child: AppStyles.headingStyle(
                  //     recipeModel?.title ?? '',
                  //     fontSize: 15,

                  //     fontWeight: FontWeight.bold,
                  //     overflow: TextOverflow.ellipsis,

                  //   ),
                  // ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CustomText(
                      textAlign: TextAlign.start,
                      text: recipeModel?.title ?? '',
                      fontSize: 15,
                      weight: FontWeight.bold, lineSpacing: 1.2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppStyles.height12SizedBox(),
                  ProfileBanner(
                    userModelData: recipeModel?.userData,
                    radius: 14,
                    onTap: () {
                      print("ON TAPPING PROFILE");

                      if (recipeModel?.userData?.Id ==
                          context.read<AuthProvider>().userdata?.data?.Id) {
                        AppMessage.showMessage(AppString.MY_PROFILE_MESSAGE);
                      } else {
                        AppNavigator.push(
                            context,
                            FriendsProfileScreen(
                                userID: recipeModel?.userData?.Id ?? ''));
                      }
                    },
                    nameSize: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        isSelected != null && isSelected == true
            ? Positioned(
                top: 10,
                right: 15,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: AppColor.THEME_COLOR_SECONDARY,
                        shape: BoxShape.circle),
                    child: const Icon(Icons.check)),
              )
            : const SizedBox()
      ],
    );
  }
}

class FoodContainerSpoonCular extends StatelessWidget {
  final int index;
  final Recipes? recipeModel;
  const FoodContainerSpoonCular({
    super.key,
    required this.onTap,
    required this.index,
    this.recipeModel,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    print("Recieipe Model: ${recipeModel?.toJson().toString()}");
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
          color: AppColor.COLOR_WHITE,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: AppColor.THEME_COLOR_SECONDARY.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // recipeModel != null
              //     ? ClipRRect(
              //         borderRadius: BorderRadius.circular(20),
              //         child: Container(
              //           height: 100,
              //           width: 150,
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(20)),
              //           child: recipeModel != null &&
              //                   recipeModel!.recipeImages!.isEmpty
              //               ? Center(
              //                   child: Image.asset(
              //                   AssetPath.PHOTO_PLACE_HOLDER,
              //                   scale: 2,
              //                 ))
              //               : ExtendedImage.network(dotenv.get('IMAGE_URL') +
              //                   recipeModel!.recipeImages![0]),
              //         ),
              //       )
              //     : const SizedBox(),
              recipeModel != null
                  ? Container(
                      height: 100,
                      width: 150,
                      // margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(14),
                      ),
                      child: recipeModel?.image != null &&
                              recipeModel!.image!.isNotEmpty
                          // ? ExtendedImage.network(
                          //     dotenv.get('IMAGE_URL') +
                          //         recipeModel!.recipeImages![0],
                          //     fit: BoxFit
                          //         .cover, // Make sure the image covers the container
                          //   )

                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: MyCustomExtendedImage(
                                imageUrl: recipeModel!.image!,
                              ),
                            )
                          : Center(
                              child: Image.asset(
                                AssetPath.PHOTO_PLACE_HOLDER,
                                fit: BoxFit.cover,
                                scale: 2,
                              ),
                            ),
                    )
                  : const SizedBox(),
              AppStyles.height8SizedBox(),
              SizedBox(
                height: 50,
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: recipeModel?.title ?? '',
                  fontSize: 15,
                  weight: FontWeight.bold, lineSpacing: 1.4,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              AppStyles.height12SizedBox(),
              // ProfileBanner(
              //   userModelData: recipeModel?.userData,
              //   radius: 14,
              //   nameSize: 14,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

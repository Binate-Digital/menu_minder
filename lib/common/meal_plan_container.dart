import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/profile_banner_widget.dart';

import '../utils/app_constants.dart';
import '../utils/asset_paths.dart';
import '../utils/styles.dart';
import '../view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'custom_extended_image_with_loading.dart';
import 'custom_text.dart';

class MealPlanContainer extends StatelessWidget {
  final int index;
  final bool hideEditButton;

  final MealPlanModel? recipeModel;
  final VoidCallback? onEditTapped;
  const MealPlanContainer({
    super.key,
    required this.onTap,
    this.hideEditButton = false,
    required this.index,
    required this.onEditTapped,
    this.recipeModel,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                  //     ? Container(
                  //         height: 100,
                  //         width: 150,
                  //         decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(10)),
                  //         child: recipeModel != null &&
                  //                 recipeModel!.reciepieData!.recipeImages !=
                  //                     null &&
                  //                 recipeModel!
                  //                     .reciepieData!.recipeImages!.isEmpty
                  //             ? Center(
                  //                 child: Image.asset(
                  //                 AssetPath.PHOTO_PLACE_HOLDER,
                  //                 scale: 2,
                  //               ))
                  //             : ExtendedImage.network(dotenv.get('IMAGE_URL') +
                  //                 recipeModel!.reciepieData!.recipeImages![0]),
                  //       )
                  //     : Container(
                  //         height: 100,
                  //         decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(10)),
                  //         child: Image.asset(index % 2 == 1
                  //             ? AssetPath.FOOD1
                  //             : AssetPath.FOOD2),
                  //       ),

                  recipeModel != null
                      ? Container(
                          height: 98,
                          width: 150,
                          // margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: recipeModel?.reciepieData?.recipeImages !=
                                      null &&
                                  recipeModel!
                                      .reciepieData!.recipeImages!.isNotEmpty
                              // ? ExtendedImage.network(
                              //     dotenv.get('IMAGE_URL') +
                              //         recipeModel!
                              //             .reciepieData!.recipeImages![0],
                              //     fit: BoxFit
                              //         .cover, // Make sure the image covers the container
                              //   )

                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: MyCustomExtendedImage(
                                    imageUrl: dotenv.get('IMAGE_URL') +
                                        recipeModel!
                                            .reciepieData!.recipeImages![0],
                                  ),
                                )
                              : Center(
                                  child: Image.asset(
                                    AssetPath.PHOTO_PLACE_HOLDER,
                                    scale: 2,
                                  ),
                                ),
                        )
                      : const SizedBox(),
                  AppStyles.height8SizedBox(),
                  // FittedBox(
                  //   // heigsht: 40,
                  //   child: AppStyles.headingStyle(
                  //       recipeModel?.reciepieData?.title ?? '',
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  SizedBox(
                    // height: 40,
                    child: CustomText(
                      textAlign: TextAlign.start,
                      text: recipeModel?.reciepieData?.title ?? '',
                      fontSize: 15,
                      weight: FontWeight.bold, lineSpacing: 1.4,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppStyles.height12SizedBox(),
                  ProfileBanner(
                    userModelData: recipeModel?.reciepieData?.userData,
                    radius: 14,
                    nameSize: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !hideEditButton && recipeModel?.myMealPlan == 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: onEditTapped,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.THEME_COLOR_PRIMARY1,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColor.COLOR_WHITE,
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }
}

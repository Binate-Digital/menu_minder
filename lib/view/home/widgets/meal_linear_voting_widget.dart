// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/nearby_restraunt/screens/nearby_screen.dart';
import 'package:menu_minder/view/user_profile/screens/friends_profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_extended_image_with_loading.dart';
import '../../../common/custom_progressbar_widget.dart';
import '../../../common/decision_container_widget.dart';
import '../../../common/primary_button.dart';
import '../../../common/profile_banner_widget.dart';
import '../../../utils/dummy.dart';
import '../../../utils/styles.dart';
import '../../my_polls/data/my_poll_response_model.dart';

class MealLinearVotingWidget extends StatelessWidget {
  Widget? postButtons;
  bool? showMore;
  bool? hasBottomOptions;
  VoidCallback? onMore;
  VoidCallback? onAgreeButton;
  PollData? pollData;

  MealLinearVotingWidget({
    Key? key,
    this.postButtons,
    this.showMore = false,
    this.hasBottomOptions = true,
    this.onAgreeButton,
    this.onMore,
    this.pollData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecisionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileBanner(
                radius: 20,
                nameSize: 16,
                userModelData: context.read<AuthProvider>().userdata?.data,
              ),
              if (showMore == true)
                InkWell(onTap: onMore, child: const Icon(Icons.more_vert))
            ],
          ),

          AppStyles.height12SizedBox(),

          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: pollData?.recipeModel?.recipeImages != null &&
                        pollData!.recipeModel!.recipeImages!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: MyCustomExtendedImage(
                          imageUrl: pollData!.recipeModel!.recipeImages![0]
                                  .startsWith('http')
                              ? pollData!.recipeModel!.recipeImages![0]
                              : dotenv.get('IMAGE_URL') +
                                  pollData!.recipeModel!.recipeImages![0],
                        ),
                      )
                    : Center(
                        child: Image.asset(
                          AssetPath.PHOTO_PLACE_HOLDER,
                          fit: BoxFit.cover,
                          scale: 2,
                        ),
                      ),
              ),
              AppStyles.height12SizedBox(width: 10, height: 0),
              Expanded(
                  child: CustomText(
                textAlign: TextAlign.start,
                text: pollData?.recipeModel?.title,
                maxLines: 2,
                weight: FontWeight.w500,
              ))
            ],
          ),

          // SizedBox(
          //   height: 90,
          //   width: 90,
          // ),

          AppStyles.height18SizedBox(),
          AppStyles.contentStyle("Description",
              fontSize: 14, fontWeight: FontWeight.w500),
          AppStyles.contentStyle(pollData?.title ?? "", fontSize: 14),
          AppStyles.height12SizedBox(),
          // const CustomProgressBarWidget(
          //   heading: "Agree",
          //   percentage: 0.8,
          // ),
          // AppStyles.height12SizedBox(),
          // const CustomProgressBarWidget(
          //   heading: "Disagree",
          //   percentage: 0.2,
          // ),

          pollData?.button != null
              ? Column(
                  children: [
                    ...List.generate(
                      pollData!.button!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CustomProgressBarWidget(
                          heading: pollData?.button?[index].text ?? '',
                          percentage:
                              pollData?.button?[index].percentage ?? 0.0,
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(),

          AppStyles.height20SizedBox(),
          if (hasBottomOptions == true)
            postButtons ??
                Row(
                  children: [
                    Expanded(
                        child: PrimaryButton(
                      text: "Disagree",
                      onTap: () {
                        int selectedIndex = -1;
                        AppDialog.showDialogs(
                            StatefulBuilder(builder: (context, state) {
                          return Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  3,
                                  (index) => InkWell(
                                    onTap: () {
                                      selectedIndex = index;
                                      state(() {});
                                      print("here");
                                      /*  AppNavigator.pop(context); */
                                    },
                                    child: DecisionContainer(
                                        containerColor: AppColor.COLOR_GREY4,
                                        bgColor: selectedIndex == index
                                            ? AppColor.THEME_COLOR_SECONDARY
                                            : AppColor.COLOR_GREY4,
                                        child: AppStyles.contentStyle(
                                            LOREM_UTLRA_SMALL,
                                            fontSize: 14)),
                                  ),
                                ),
                              ),
                              AppStyles.height16SizedBox(),
                              PrimaryButton(
                                  text: "Decline",
                                  onTap: () {
                                    AppNavigator.pop(context);
                                    Future.delayed(
                                            const Duration(milliseconds: 100))
                                        .then((value) => AppNavigator.push(
                                            context,
                                            const NearbyRestrauntScreen()));
                                  }),
                              if (selectedIndex != -1)
                                Column(
                                  children: [
                                    AppStyles.height8SizedBox(),
                                    PrimaryButton(
                                        text: "Done",
                                        textColor: AppColor.COLOR_BLACK,
                                        buttonColor:
                                            AppColor.THEME_COLOR_SECONDARY,
                                        onTap: () {
                                          AppNavigator.pop(context);
                                        }),
                                  ],
                                ),
                            ],
                          );
                        }), "Suggestions", context, hasBack: true);
                      },
                      buttonColor: Colors.grey,
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: PrimaryButton(
                            text: "Agree", onTap: onAgreeButton ?? () {}))
                  ],
                )
        ],
      ),
    );
  }
}

class HomeVoteWidget extends StatelessWidget {
  Widget? postButtons;
  bool? showMore;
  bool? hasBottomOptions;
  VoidCallback? onMore;
  VoidCallback? onAgreeButton;
  PollData? pollData;

  HomeVoteWidget({
    Key? key,
    this.postButtons,
    this.showMore = false,
    this.hasBottomOptions = true,
    this.onAgreeButton,
    this.onMore,
    this.pollData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecisionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileBanner(
                radius: 20,
                nameSize: 16,
                onTap: () {
                  if (pollData?.userID?.Id ==
                      context.read<AuthProvider>().userdata?.data?.Id) {
                    AppMessage.showMessage(AppString.MY_PROFILE_MESSAGE);
                  } else {
                    AppNavigator.push(context,
                        FriendsProfileScreen(userID: pollData!.userID!.Id!));
                  }
                },
                userModelData: pollData?.userID,
              ),
              if (showMore == true)
                InkWell(onTap: onMore, child: const Icon(Icons.more_vert))
            ],
          ),

          AppStyles.height12SizedBox(),
        pollData!.button![0].votes!.isEmpty ?
          Row(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: pollData?.recipeModel?.recipeImages != null &&
                        pollData!.recipeModel!.recipeImages!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: MyCustomExtendedImage(
                          imageUrl: pollData!.recipeModel!.recipeImages![0]
                                  .startsWith('http')
                              ? pollData!.recipeModel!.recipeImages![0]
                              : dotenv.get('IMAGE_URL') +
                                  pollData!.recipeModel!.recipeImages![0],
                        ),
                      )
                    : Center(
                        child: Image.asset(
                          AssetPath.PHOTO_PLACE_HOLDER,
                          fit: BoxFit.cover,
                          scale: 2,
                        ),
                      ),
              ),
              AppStyles.height12SizedBox(width: 10, height: 0),
              Expanded(
                  child: CustomText(
                textAlign: TextAlign.start,
                maxLines: 3,
                text: pollData?.recipeModel?.title,
                weight: FontWeight.w500,
              ))
            ],
          )
              :   Row(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child:   pollData?.button?[0].votes?[0].finalRecipe?.image != null &&
                    pollData!.button![0].votes![0].finalRecipe!.image!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: MyCustomExtendedImage(
                    imageUrl:  pollData!.button![0].votes![0].finalRecipe!.image
                        !.startsWith('http')
                        ?  pollData!.button![0].votes![0].finalRecipe!.image ?? ''
                        : '${dotenv.get('IMAGE_URL')}${pollData!.button![0].votes![0].finalRecipe!.image}' ,
                  ),
                )
                    : Center(
                  child: Image.asset(
                    AssetPath.PHOTO_PLACE_HOLDER,
                    fit: BoxFit.cover,
                    scale: 2,
                  ),
                ),
              ),
              AppStyles.height12SizedBox(width: 10, height: 0),
              Expanded(
                  child: CustomText(
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    text: pollData!.button![0].votes![0].finalRecipe?.title ?? '',
                    weight: FontWeight.w500,
                  ))
            ],
          ) ,

          AppStyles.height12SizedBox(),
          AppStyles.contentStyle('Description',
              fontSize: 14, fontWeight: FontWeight.w500),
          AppStyles.height12SizedBox(),

          AppStyles.contentStyle(pollData?.title ?? "", fontSize: 14),
          AppStyles.height12SizedBox(),
          // const CustomProgressBarWidget(
          //   heading: "Agree",
          //   percentage: 0.8,
          // ),
          // AppStyles.height12SizedBox(),
          // const CustomProgressBarWidget(
          //   heading: "Disagree",
          //   percentage: 0.2,
          // ),

          pollData?.button != null
              ? Column(
                  children: [
                    ...List.generate(
                      pollData!.button!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CustomProgressBarWidget(
                          heading: pollData?.button?[index].text ?? '',
                          percentage:
                              pollData?.button?[index].percentage?.toDouble() ??
                                  0.0,
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(),

          AppStyles.height20SizedBox(),
          if (hasBottomOptions == true)
            postButtons ??
                Row(
                  children: [
                    Expanded(
                        child: PrimaryButton(
                      text: "Disagree",
                      onTap: () {
                        int selectedIndex = -1;
                        AppDialog.showDialogs(
                            StatefulBuilder(builder: (context, state) {
                          return Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  3,
                                  (index) => InkWell(
                                    onTap: () {
                                      selectedIndex = index;
                                      state(() {});
                                      print("here");
                                      /*  AppNavigator.pop(context); */
                                    },
                                    child: DecisionContainer(
                                        containerColor: AppColor.COLOR_GREY4,
                                        bgColor: selectedIndex == index
                                            ? AppColor.COLOR_BLACK
                                            : AppColor.COLOR_GREEN1,
                                        child: AppStyles.contentStyle(
                                            LOREM_UTLRA_SMALL,
                                            fontSize: 14)),
                                  ),
                                ),
                              ),
                              AppStyles.height16SizedBox(),
                              PrimaryButton(
                                  text: "Decline",
                                  onTap: () {
                                    AppNavigator.pop(context);
                                    Future.delayed(
                                            const Duration(milliseconds: 100))
                                        .then((value) => AppNavigator.push(
                                            context,
                                            const NearbyRestrauntScreen()));
                                  }),
                              if (selectedIndex != -1)
                                Column(
                                  children: [
                                    AppStyles.height8SizedBox(),
                                    PrimaryButton(
                                        text: "Done",
                                        textColor: AppColor.COLOR_BLACK,
                                        buttonColor:
                                            AppColor.THEME_COLOR_SECONDARY,
                                        onTap: () {
                                          AppNavigator.pop(context);
                                        }),
                                  ],
                                ),
                            ],
                          );
                        }), "Suggestions", context, hasBack: true);
                      },
                      buttonColor: Colors.grey,
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: PrimaryButton(
                            text: "Agree", onTap: onAgreeButton ?? () {}))
                  ],
                )
        ],
      ),
    );
  }
}

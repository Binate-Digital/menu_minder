// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/models/user_model.dart';
import 'package:menu_minder/view/home/data/all_pole_model.dart';
import 'package:menu_minder/view/my_polls/data/my_poll_response_model.dart';
import 'package:menu_minder/view/poll_results/screens/poll_result_screen_recieverside.dart';
import 'package:menu_minder/view/poll_results/screens/polls_result_screen.dart';
import 'package:menu_minder/view/user_profile/screens/friends_profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/above_heading_linear_widget.dart';
import '../../../common/custom_extended_image_with_loading.dart';
import '../../../common/custom_text.dart';
import '../../../common/decision_container_widget.dart';
import '../../../common/profile_banner_widget.dart';
import '../../../utils/dummy.dart';
import '../../../utils/styles.dart';
import '../../auth/bloc/provider/auth_provider.dart';

class MultipleVotingsContainer extends StatelessWidget {
  bool? showMore;
  bool? hasBottomOptions;
  VoidCallback? onMore;
  PollData allPolData;
  MultipleVotingsContainer({
    Key? key,
    this.showMore,
    this.hasBottomOptions,
    required this.allPolData,
    this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final userId = context.read<AuthProvider>().userdata!.data!.Id!;

    // final userInfo =  allPolData.userID!.Id ==
    //                                                   userId
    //                                               ? val
    //                                                   .getFilteredChats!
    //                                                   .data![index]
    //                                                   .receiverId!
    //                                                   .userName!
    //                                               : val
    //                                                   .getFilteredChats!
    //                                                   .data![index]
    //                                                   .senderId!
    //                                                   .userName!
    return DecisionContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileBanner(
              // userModelData: UserModelData(),
              onTap: () {
                if (allPolData.userID?.Id ==
                    context.read<AuthProvider>().userdata?.data?.Id) {
                  AppMessage.showMessage(AppString.MY_PROFILE_MESSAGE);
                } else {
                  AppNavigator.push(context,
                      FriendsProfileScreen(userID: allPolData.userID!.Id!));
                }
              },

              userModelData: allPolData.userID,

              radius: 20,
              nameSize: 16,
            ),
            if (showMore == true)
              InkWell(onTap: onMore, child: const Icon(Icons.more_vert))
          ],
        ),

        AppStyles.height12SizedBox(),
        Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: allPolData.recipeModel?.recipeImages != null &&
                      allPolData.recipeModel!.recipeImages!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: MyCustomExtendedImage(
                        imageUrl: allPolData.recipeModel!.recipeImages![0]
                                .startsWith('http')
                            ? allPolData.recipeModel!.recipeImages![0]
                            : dotenv.get('IMAGE_URL') +
                                allPolData.recipeModel!.recipeImages![0],
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
              text: allPolData.recipeModel?.title,
              maxLines: 3,
              weight: FontWeight.w500,
            ))
          ],
        ),

        AppStyles.height18SizedBox(),
        AppStyles.contentStyle("Description",
            fontSize: 14, fontWeight: FontWeight.w500),
        AppStyles.contentStyle(allPolData.title ?? '', fontSize: 14),
        AppStyles.height12SizedBox(),

        ...List.generate(
          allPolData.button?.length ?? 0,
          (index) => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AboveHeadingLinearWidget(
              heading: allPolData.button?[index].text ?? '',
              percentage: allPolData.button?[index].percentage ?? 0.0,
            ),
          ),
        ),
        AppStyles.height16SizedBox(),

        PrimaryButton(
            text: 'View Details',
            onTap: () {
              AppNavigator.push(
                  context,
                  PollResultScreenRecieverSide(
                    pollID: allPolData.sId,
                  ));
            })

        ///
      ],
    ));
  }
}

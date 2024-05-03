import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/user_profile/screens/friends_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/profile_banner_widget.dart';
import '../../../utils/styles.dart';

class SuggesstionListScreen extends StatelessWidget {
  const SuggesstionListScreen(
      {super.key, required this.mealPlanModel, required this.mealType});
  final MealPlanModel mealPlanModel;
  final String mealType;

  @override
  Widget build(BuildContext context) {
    final currentUserID = context.read<AuthProvider>().userdata?.data?.Id!;
    return Scaffold(
      appBar: AppStyles.pinkAppBar(
        context,
        'Suggesstions',
        hasBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: mealPlanModel.familyMembers != null &&
                mealPlanModel.familyMembers!.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return mealPlanModel.familyMembers![index].userId ==
                          currentUserID
                      ? const SizedBox()
                      : AskSuggestionWidget(
                          mealPlanID: mealPlanModel.mealPlanID!,
                          familyMembers: mealPlanModel.familyMembers![index],
                        );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: mealPlanModel.familyMembers?.length ?? 0)
            : const Center(
                child: CustomText(
                  text: 'No Family Members found.',
                ),
              ),
      ),
    );
  }
}

class AskSuggestionWidget extends StatefulWidget {
  final FamilyMemberModel? familyMembers;
  final String mealPlanID;
  const AskSuggestionWidget({
    super.key,
    required this.familyMembers,
    required this.mealPlanID,
  });

  @override
  State<AskSuggestionWidget> createState() => _AskSuggestionWidgetState();
}

class _AskSuggestionWidgetState extends State<AskSuggestionWidget> {
  ValueNotifier<bool> showSuggestion = ValueNotifier(false);
  final suggesstion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.THEME_COLOR_SECONDARY.withOpacity(.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: widget.familyMembers != null,
                // replacement: CustomText(
                //   text: 'No Members Found',
                // ),
                child: InkWell(
                  onTap: () {
                    final currentUserID =
                        context.read<AuthProvider>().userdata?.data?.Id!;
                    if (widget.familyMembers?.userId == currentUserID) {
                      AppMessage.showMessage(AppString.MY_PROFILE_MESSAGE);
                    } else {
                      AppNavigator.push(
                        context,
                        FriendsProfileScreen(
                            userID: widget.familyMembers!.userId!),
                      );
                    }
                  },
                  child: FamliMamberBanner(
                    userModelData: widget.familyMembers!,
                  ),
                ),
              ),
              Visibility(
                visible: widget.familyMembers?.suggestionData == null &&
                    widget.familyMembers!.userId !=
                        context.read<AuthProvider>().userdata!.data!.Id!,
                child: InkWell(
                  onTap: () {
                    context.read<CoreProvider>().askSuggesstion(
                        context: context,
                        postUserID: widget.familyMembers!.userId!,
                        mealPlanID: widget.mealPlanID);
                  },
                  child: AppStyles.contentStyle("Ask Suggestion",
                      color: AppColor.THEME_COLOR_PRIMARY1,
                      textDecoration: TextDecoration.underline,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          // ValueListenableBuilder(
          //     valueListenable: showSuggestion,
          //     builder: (context, val, _) {
          //       return Column(
          //         children: [
          //           AppStyles.height4SizedBox(),
          //           if (val)
          //             PrimaryTextField(
          //                 hintText: "Suggestion",
          //                 borderColor: AppColor.TRANSPARENT_COLOR,
          //                 hasTrailingWidget: true,
          //                 trailingWidget: AssetPath.SEND_MESSAGE,
          //                 onTrailingTap: () {
          //                   showSuggestion.value = false;
          //                   suggesstion.clear();
          //                 },
          //                 fillColor: Colors.grey.shade100,
          //                 controller: suggesstion)
          //         ],
          //       );
          //     }),

          Visibility(
              visible: widget.familyMembers?.suggestionData != null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Suggesstion',
                      weight: FontWeight.bold,
                      fontColor: AppColor.THEME_COLOR_PRIMARY2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      maxLines: 12,
                      textAlign: TextAlign.start,
                      text: widget.familyMembers!.suggestionData?.text ?? '',
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

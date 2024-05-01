import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:menu_minder/common/bottom_sheet_option_widget.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/network/firebase_messaging_service.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/create_new_poll/screens/create_new_poll_screen.dart';
import 'package:menu_minder/view/my_polls/data/my_poll_response_model.dart';
import 'package:menu_minder/view/poll_members/screens/poll_members_screen.dart';
import 'package:menu_minder/view/poll_results/screens/polls_result_screen.dart';
import 'package:provider/provider.dart';
import '../../home/widgets/meal_linear_voting_widget.dart';

class MyPollsScreen extends StatefulWidget {
  const MyPollsScreen({super.key, this.fromNotification = false});
  final bool fromNotification;

  @override
  State<MyPollsScreen> createState() => _MyPollsScreenState();
}

class _MyPollsScreenState extends State<MyPollsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoreProvider>().getMyPoles(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromNotification) {
          AppNavigator.pushAndRemoveUntil(context, const BottomBar());
        } else {
          AppNavigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
          child: PrimaryButton(
              text: "Create New Poll",
              onTap: () {
                AppNavigator.push(
                    context,
                    const CreateNewPollScreen(
                      isEdit: false,
                    ));

                // final currentRoute =
                //     ModalRoute.of(StaticData.navigatorKey.currentContext!)
                //         ?.settings
                //         .name
                //         .toString();

                // final routeName =
                //     Navigator.of(StaticData.navigatorKey.currentContext!)
                //         .widget
                //         .pages
                //         .first
                //         .name;

                // log("ROUTE NAME ${routeName}");
              }),
        ),
        appBar: AppStyles.pinkAppBar(
          context,
          "My Polls",
          onleadingTap: () {
            if (widget.fromNotification) {
              AppNavigator.pushAndRemoveUntil(context, const BottomBar());
            } else {
              AppNavigator.pop(context);
            }
          },
        ),
        body: Padding(
          padding: AppStyles.screenPadding(),
          child: Consumer<CoreProvider>(builder: (context, val, _) {
            if (val.getMyPoleLoadState == States.loading) {
              return const CustomLoadingBarWidget();
            } else if (val.getMyPoleLoadState == States.success) {
              return val.getMyPolles?.data != null &&
                      val.getMyPolles!.data!.isEmpty
                  ? const Center(
                      child: CustomText(
                        text: 'No Data Found',
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) => MealLinearVotingWidget(
                        pollData: val.getMyPolles!.data![index],
                        showMore: true,
                        hasBottomOptions: true,
                        onMore: () {
                          pollsBottomSheet(
                              context, val.getMyPolles!.data![index]);
                        },
                        postButtons: PrimaryButton(
                            text: "View Poll Result",
                            onTap: () {
                              AppNavigator.push(
                                  context,
                                  PollResultScreen(
                                    pollID: val.getMyPolles!.data![index].sId,
                                  ));
                            }),
                      ),
                      itemCount: val.getMyPolles?.data?.length ?? 0,
                      separatorBuilder: (BuildContext context, int index) =>
                          AppStyles.height12SizedBox(),
                    );
            } else if (val.getMyPoleLoadState == States.failure) {
              return const Center(
                child: CustomText(
                  text: 'No Data Found',
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
        ),
      ),
    );
  }

  pollsBottomSheet(BuildContext context, PollData pollData) =>
      AppDialog.modalBottomSheet(
          context: context,
          child: Column(
            children: [
              BottomSheetOptions(
                  heading: "View Members",
                  imagePath: AssetPath.PROFILE,
                  onTap: () {
                    AppNavigator.pop(context);
                    Future.delayed(const Duration(microseconds: 100));
                    AppNavigator.push(
                        context,
                        PollMembersScreen(
                          familyMembers: pollData.familyMembers,
                        ));
                  }),
              // BottomSheetOptions(
              //     heading: "Edit Poll",
              //     imagePath: AssetPath.EDIT,
              //     onTap: () {
              //       AppNavigator.pop(context);
              //       Future.delayed(const Duration(microseconds: 100));

              //       AppNavigator.push(
              //           context,
              //           CreateNewPollScreen(
              //             isEdit: true,
              //             pollData: pollData,
              //           ));
              //     }),

              // BottomSheetOptions(
              //     heading: "Delete Poll",
              //     bottomDivider: false,
              //     imagePath: AssetPath.DELETE,
              //     onTap: () {
              //       AppNavigator.pop(context);
              //       Future.delayed(const Duration(milliseconds: 200))
              //           .then((value) => AppDialog.showDialogs(
              //               Column(
              //                 children: [
              //                   Padding(
              //                     padding: const EdgeInsets.symmetric(
              //                         horizontal: 48.0, vertical: 12),
              //                     child: AppStyles.headingStyle(
              //                         "Are you sure you want to delete this poll?",
              //                         textAlign: TextAlign.center,
              //                         fontWeight: FontWeight.w400),
              //                   ),
              //                   Row(
              //                     children: [
              //                       Expanded(
              //                           child: PrimaryButton(
              //                               text: "Cancel",
              //                               buttonColor: Colors.grey.shade600,
              //                               onTap: () {
              //                                 AppNavigator.pop(context);
              //                               })),
              //                       const SizedBox(
              //                         width: 10,
              //                       ),
              //                       Expanded(
              //                           child: PrimaryButton(
              //                               text: "Yes",
              //                               // buttonColor: AppColor.COLOR_RED1,
              //                               onTap: () {
              //                                 context
              //                                     .read<CoreProvider>()
              //                                     .deletePoll(
              //                                   context,
              //                                   pollData,
              //                                   onSuccess: () {
              //                                     AppNavigator.pop(context);
              //                                   },
              //                                 );
              //                               })),
              //                     ],
              //                   )
              //                 ],
              //               ),
              //               "Delete Poll",
              //               context));
              //     }),
            ],
          ));
}





// OLD UI LIST

// ListView.separated(
//                     itemBuilder: (context, index) => index == 0
//                         ? MealLinearVotingWidget(
//                             showMore: true,
//                             hasBottomOptions: true,
//                             onMore: () {
//                               pollsBottomSheet(context);
//                             },
//                             postButtons: PrimaryButton(
//                                 text: "View Poll Result",
//                                 onTap: () {
//                                   AppNavigator.push(
//                                       context, const PollResultScreen());
//                                 }),
//                           )
//                         : MultipleVotingsContainer(
//                             showMore: true,
//                             onMore: () {
//                               pollsBottomSheet(context);
//                             },
//                           ),
//                     itemCount: 2,
//                     separatorBuilder: (BuildContext context, int index) =>
//                         AppStyles.height12SizedBox(),
//                   );
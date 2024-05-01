import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_minder/common/bottom_sheet_option_widget.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_textfield.dart';
import 'package:menu_minder/providers/chat_provider.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/app_validator.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/chat/screens/chat_screen.dart';
import 'package:menu_minder/view/profile/widgets/personal_info_widget.dart';
import 'package:provider/provider.dart';
import '../../../common/primary_button.dart';
import '../../../utils/actions.dart';
import '../../../utils/app_constants.dart';
import '../../home/widgets/recipes_widget.dart';
import '../../recipe_details/screens/recipe_details_screen.dart';
import '../widgets/followers_list_widget.dart';

class FriendsProfileScreen extends StatefulWidget {
  const FriendsProfileScreen({super.key, required this.userID});
  final String userID;

  @override
  State<FriendsProfileScreen> createState() => _FriendsProfileScreenState();
}

class _FriendsProfileScreenState extends State<FriendsProfileScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  _loadProfile(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<CoreProvider>().loadFriendsProfile(
        context,
        widget.userID,
        onSuccess: () {
          context
              .read<CoreProvider>()
              .loadFriendRecipies(context, widget.userID);
        },
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<CoreProvider>().getBlockedUsersList();
    });
  }

  bool isFollowed = false;
  @override
  Widget build(BuildContext context) {
    _loadProfile(context);
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "User Profile",
          isRounded: false,
          trailing: IconButton(
              onPressed: () {
                final isUserBlocked = context
                    .read<CoreProvider>()
                    .blockedUsers
                    ?.data!
                    .any(
                        (element) => element.receiverId!.sId! == widget.userID);

                final buttonText = isUserBlocked != null && isUserBlocked
                    ? "Unblock User"
                    : "Block User";
                AppDialog.modalBottomSheet(
                    context: context,
                    child: Column(
                      children: [
                        BottomSheetOptions(
                            heading: buttonText,
                            imagePath: AssetPath.BLOCK_USER,
                            onTap: () {
                              AppNavigator.pop(context);
                              Future.delayed(const Duration(milliseconds: 100))
                                  .then((value) => AppDialog.showDialogs(
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 48.0, vertical: 12),
                                            child: AppStyles.headingStyle(
                                                "Are you sure you want to block this person?",
                                                textAlign: TextAlign.center,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: PrimaryButton(
                                                      text: "Cancel",
                                                      buttonColor:
                                                          Colors.grey.shade600,
                                                      onTap: () {
                                                        AppNavigator.pop(
                                                            context);
                                                      })),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: PrimaryButton(
                                                      text: "Yes",
                                                      // buttonColor: AppColor.COLOR_RED1,
                                                      onTap: () {
                                                        // AppNavigator.pop(
                                                        //     context);c
                                                        context
                                                            .read<
                                                                CoreProvider>()
                                                            .blockUser(
                                                          widget.userID,
                                                          context,
                                                          onSuccess: () {
                                                            AppNavigator.pop(
                                                                context);
                                                            AppNavigator.pop(
                                                                context);

                                                            // AppNavigator.pop(
                                                            //     context);
                                                            context
                                                                .read<
                                                                    CoreProvider>()
                                                                .getBlockedUsersList();
                                                          },
                                                        );
                                                      })),
                                            ],
                                          )
                                        ],
                                      ),
                                      "Block",
                                      context));
                            }),
                        BottomSheetOptions(
                            heading: "Report User",
                            imagePath: AssetPath.REPORT_USER,
                            bottomDivider: false,
                            onTap: () {
                              List<ReportUser> reportList = [
                                ReportUser(true, LOREM_UTLRA_SMALL),
                                ReportUser(false, LOREM_UTLRA_SMALL),
                                ReportUser(false, LOREM_UTLRA_SMALL),
                                ReportUser(false, "Other"),
                              ];

                              AppNavigator.pop(context);
                              Future.delayed(const Duration(milliseconds: 200))
                                  .then((value) => AppDialog.showDialogs(
                                          StatefulBuilder(
                                              builder: (context, state) {
                                        final keys = GlobalKey<FormState>();
                                        return Column(
                                          children: [
                                            Column(
                                                children: List.generate(
                                                    reportList.length, (index) {
                                              ValueNotifier<bool> checkbox =
                                                  ValueNotifier(
                                                      reportList[index]
                                                          .isReport);
                                              return ValueListenableBuilder(
                                                  valueListenable: checkbox,
                                                  builder: (context, val, _) {
                                                    return Row(
                                                      children: [
                                                        Checkbox(
                                                          value:
                                                              reportList[index]
                                                                  .isReport,
                                                          onChanged: (v) {
                                                            checkbox.value = v!;
                                                            reportList[index]
                                                                .isReport = v;
                                                            for (var i = 0;
                                                                i <
                                                                    reportList
                                                                        .length;
                                                                i++) {
                                                              if (i != index) {
                                                                reportList[i]
                                                                        .isReport =
                                                                    false;
                                                              }
                                                            }
                                                            state(() {});
                                                          },
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2)),
                                                        ),
                                                        AppStyles.subHeadingStyle(
                                                            index == 3
                                                                ? "Others"
                                                                : LOREM_UTLRA_SMALL),
                                                      ],
                                                    );
                                                  });
                                            })),
                                            if (reportList.last.isReport)
                                              Form(
                                                key: keys,
                                                child: PrimaryTextField(
                                                    hintText: "Description",
                                                    maxLines: 5,
                                                    borderColor: AppColor
                                                        .TRANSPARENT_COLOR,
                                                    fillColor: Colors
                                                        .grey.shade100,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          275)
                                                    ],
                                                    validator: (val) =>
                                                        AppValidator
                                                            .validateField(
                                                                "Description",
                                                                val!),
                                                    controller:
                                                        TextEditingController()),
                                              ),
                                            AppStyles.height8SizedBox(),
                                            PrimaryButton(
                                                text: "Submit",
                                                onTap: () {
                                                  if (reportList
                                                      .where((element) =>
                                                          element.isReport ==
                                                          true)
                                                      .isNotEmpty) {
                                                    if (reportList
                                                        .last.isReport) {
                                                      if (keys.currentState!
                                                          .validate()) {
                                                        Utils.showToast(
                                                            message:
                                                                "Report submitted");
                                                        AppNavigator.pop(
                                                            context);
                                                      }
                                                    } else {
                                                      Utils.showToast(
                                                          message:
                                                              "Report submitted");
                                                      AppNavigator.pop(context);
                                                    }
                                                  } else {
                                                    Utils.showToast(
                                                        message:
                                                            "Please select any option");
                                                  }
                                                })
                                          ],
                                        );
                                      }), "Report User", context,
                                          hasBack: true));
                            }),
                      ],
                    ));
              },
              icon: const Icon(Icons.more_vert))),
      body: Consumer<CoreProvider>(builder: (context, val, _) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FriendProfileInfo(
                  leftButtonText: isFollowed ? "Unfollow" : "Follow",
                  leftButtonTap: () {
                    isFollowed = !isFollowed;
                    // setState(() {});
                  },
                  leftTextColor: isFollowed
                      ? AppColor.COLOR_BLACK
                      : AppColor.THEME_COLOR_PRIMARY1,
                  leftButtonColor: isFollowed
                      ? AppColor.THEME_COLOR_SECONDARY
                      : AppColor.COLOR_WHITE,
                  rightButtonText: "Message",
                  onFollowers: () {
                    _tabController!.index = 0;
                    AppDialog.plainDialog(
                      context,
                      FollowersListWidget(tabController: _tabController),
                    );
                  },
                  onFollowing: () {
                    _tabController!.index = 1;
                    AppDialog.plainDialog(
                      context,
                      FollowersListWidget(tabController: _tabController),
                    );
                  },
                  rightButtonTap: () {
                    context.read<ChatProvider>().isWaiting = true;
                    AppNavigator.push(
                        context,
                        ChatScreen(
                          // currentIndex: ,
                          friendName: val.friendProfile?.userName ?? '',
                          isFriend: true,
                          friendID: val.friendProfile!.sId!,
                        ));
                  },
                  friendData: val.friendProfile),
              Visibility(
                visible: val.freindsReciepies?.data != null,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppDimen.SCREEN_PADDING,
                    right: AppDimen.SCREEN_PADDING,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppStyles.height16SizedBox(),
                      AppStyles.headingStyle("Recipes"),
                      AppStyles.height16SizedBox(),
                      val.freindsReciepies?.data != null &&
                              val.freindsReciepies!.data!.isEmpty
                          ? const Center(
                              child: CustomText(
                                text: 'No Recipes yet.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : RecipesWidget(
                              receipies: val.freindsReciepies?.data ?? [],
                              isFromProfileDetails: true,
                              onTap: () {
                                // AppNavigator.push(
                                //     context,
                                //     RecipeDetailsScreen(
                                //       isFromProfileDetails: true,
                                //     ));
                              },
                            ),
                      AppStyles.height16SizedBox(),
                      // AppStyles.headingStyle("Meal of the Day?"),
                      // AppStyles.height16SizedBox(),
                      // MealLinearVotingWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ReportUser {
  bool isReport;
  final String reportContent;

  ReportUser(this.isReport, this.reportContent);
}

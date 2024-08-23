import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/providers/notifications_provider.dart';
import 'package:menu_minder/view/inbox/widgets/inbox_container_widget.dart';
import 'package:menu_minder/view/meal_plan/screens/meal_plan_detail_screen.dart';
import 'package:menu_minder/view/my_polls/screens/my_polls_screen.dart';
import 'package:menu_minder/view/notifications/custom_slidable.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_loading_bar.dart';
import '../../../common/primary_button.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/enums.dart';
import '../../show_family_members/screens/show_family_member_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.isFromNotifications = false});
  final bool isFromNotifications;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  _loadNotifications(BuildContext context, {bool isRefresh = false}) {
    context.read<NotificationProvider>().getNotifications(isRfresh: isRefresh);
  }

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _loadNotifications(
              context,
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = RefreshController();

    return Scaffold(
      appBar: AppStyles.pinkAppBar(
        context,
        "Notifications",
        onleadingTap: () async {
          if (widget.isFromNotifications) {
            AppNavigator.pushAndRemoveUntil(context, const BottomBar());
          } else {
            AppNavigator.pop(context);
          }
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          print(widget.isFromNotifications);
          if (widget.isFromNotifications) {
            AppNavigator.pushAndRemoveUntil(context, const BottomBar());
          } else {
            AppNavigator.pop(context);
          }
          return false;
        },
        child: Padding(
          padding: AppStyles.screenPadding(),
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadNotifications(context, isRefresh: false);
            },
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: Consumer<NotificationProvider>(
                      builder: (context, provider, _) {
                    return provider.getNotificationsState == States.loading
                        ? const CustomLoadingBarWidget()
                        : provider.getNotificationsState == States.failure
                            ? const Center(
                                child: CustomText(
                                text: "No notifications found",
                              ))
                            : provider.notificationData?.data != null &&
                                    provider.notificationData!.data!.isEmpty
                                ? const Center(
                                    child: CustomText(
                                      fontSize: 18,
                                      text: 'No Notifications yet.',
                                    ),
                                  )
                                : ListView.separated(
                                    itemBuilder: (context, index) =>
                                        CustomSlidableWidget(
                                          isenable: true,
                                          onTap: () {
                                            AppDialog.showDialogs(
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 48),
                                                      child: AppStyles.headingStyle(
                                                          "Are you sure you want to delete this Notification?",
                                                          textAlign:
                                                              TextAlign.center,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                PrimaryButton(
                                                                    text:
                                                                        "Cancel",
                                                                    buttonColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade600,
                                                                    onTap: () {
                                                                      AppNavigator
                                                                          .pop(
                                                                              context);
                                                                    })),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(child: Consumer<
                                                                NotificationProvider>(
                                                            builder: (context,
                                                                val, _) {
                                                          if (val.deleteNotificationState ==
                                                              States.success) {
                                                            AppNavigator.pop(
                                                                context);
                                                            AppMessage.showMessage(
                                                                'Notification deleted successfully.');

                                                            val.initState();
                                                          }
                                                          return val.deleteNotificationState ==
                                                                  States.loading
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    CircularProgressIndicator(
                                                                      backgroundColor:
                                                                          AppColor
                                                                              .COLOR_WHITE,
                                                                      color: AppColor
                                                                          .THEME_COLOR_PRIMARY1,
                                                                    ),
                                                                  ],
                                                                )
                                                              : PrimaryButton(
                                                                  text:
                                                                      "Delete",
                                                                  buttonColor:
                                                                      AppColor
                                                                          .COLOR_RED1,
                                                                  onTap: () {
                                                                    context
                                                                        .read<
                                                                            NotificationProvider>()
                                                                        .deleteNotification(
                                                                            notificationModel:
                                                                                provider.notificationData!.data![index]);
                                                                  });
                                                        })),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                "Delete Notification",
                                                context);
                                          },
                                          child: InboxContainer(
                                            isNotifications: true,
                                            onTap: () {
                                              final type = provider
                                                  .notificationData
                                                  ?.data?[index]
                                                  .notificationType;

                                              // print(provider.notificationData
                                              //     ?.data?[index]
                                              //     .toJson());

                                              // print("TYE $type");
                                              // if (type?.toLowerCase() ==
                                              //     AppString
                                              //         .NOTIFICATION_TYPE_POLL) {
                                              //   AppNavigator.push(context,
                                              //       const MyPollsScreen());
                                              // }
                                              _handleNotifications(
                                                type!,
                                                context: context,
                                                pollID: provider
                                                    .notificationData
                                                    ?.data?[index]
                                                    .pollID,
                                              );

                                              print("TYE $type");
                                            },
                                            inbox: provider
                                                .notificationData!.data![index],
                                          ),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        AppStyles.horizontalDivider(),
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: provider
                                            .notificationData?.data?.length ??
                                        0);
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  _handleNotifications(
    String type, {
    required BuildContext context,
    String? pollID,
  }) {
    switch (type) {
      case 'newRecipee':
        AppNavigator.pushAndRemoveUntil(context, BottomBar());
        break;
      case 'newPole':
        bottomIndex.value = 0;

        AppNavigator.pushAndRemoveUntil(
            context,
            BottomBar(
              index: 0,
              pollID: pollID,
            ));
        break;
      case 'poleVote':
        AppNavigator.push(context, MyPollsScreen());
        break;

      case 'askSuggestion':
        // AppNavigator.push(context, MealPlanDetailScreen());
        break;
      case 'AcceptFollowRequest':
        AppNavigator.push(context, const ShowFamilyMemberScreen());
        break;
      default:
        break;
    }
  }
}

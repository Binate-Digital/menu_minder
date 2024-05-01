import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/providers/notifications_provider.dart';
import 'package:menu_minder/utils/constants.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/inbox/data/message_list_model.dart';
import 'package:provider/provider.dart';

import '../../../common/dotted_image.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/styles.dart';
import '../../notifications/data/get_notification_model.dart';

class InboxContainer extends StatelessWidget {
  final NotificationModel inbox;
  final bool isNotifications;
  final Function()? onTap;
  const InboxContainer({
    super.key,
    required this.inbox,
    this.isNotifications = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  DottedImage(
                    radius: 20,
                    netWorkUrl: inbox.senderId?.userImage,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppStyles.headingStyle(inbox.notificationTitle ?? '',
                          fontSize: 14),
                      SizedBox(
                        width: isNotifications
                            ? MediaQuery.of(context).size.width / 1.86
                            : MediaQuery.of(context).size.width / 1.4,
                        child: AppStyles.contentStyle(
                            inbox.notificationBody ?? '',
                            color: AppColor.COLOR_GREY1),
                      )
                    ],
                  )
                ],
              ),
            ),
            // AppStyles.height4SizedBox(),
            Visibility(
              visible: inbox.notificationType == 'friendRequest',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          context.read<CoreProvider>().acceptOrRejectRequest(
                              inbox, context, onSuccess: () {
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              context
                                  .read<NotificationProvider>()
                                  .getNotifications();
                            });
                            // AppNavigator.pop(context);
                            // context
                            //     .read<NotificationProvider>()
                            //     .getNotifications(null);
                          }, status: 'rejected');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColor.THEME_COLOR_PRIMARY2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 17,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          context.read<CoreProvider>().acceptOrRejectRequest(
                              inbox, context, onSuccess: () {
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              context
                                  .read<NotificationProvider>()
                                  .getNotifications();
                            });
                            // AppNavigator.pop(context);
                            // context
                            //     .read<NotificationProvider>()
                            //     .getNotifications(null);
                          }, status: 'accepted');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColor.THEME_COLOR_SECONDARY,
                          ),
                          child: const Icon(
                            Icons.done,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppStyles.contentStyle(
                      inbox.createdAt != null
                          ? Utils.formatDate(
                                  pattern: Constants.MM_DD_YYYY_FORMAT,
                                  date: DateTime.parse(inbox.createdAt!))
                              .toString()
                          : '',
                      color: AppColor.COLOR_GREY1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final RecentMessage inbox;
  const MessageTile({
    super.key,
    required this.inbox,
  });

  @override
  Widget build(BuildContext context) {
    final friendData = inbox.receiverId!.sId ==
            context.read<AuthProvider>().userdata!.data!.Id!
        ? inbox.senderId
        : inbox.receiverId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DottedImage(
                radius: 20,
                netWorkUrl: friendData?.userImage,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppStyles.headingStyle(friendData?.userName ?? '',
                      fontSize: 14),
                  inbox.message == null
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 14,
                            ),
                            AppStyles.height4SizedBox(height: 1, width: 4),
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: CustomText(
                                text: 'Photo',
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      : AppStyles.contentStyle(inbox.message ?? '',
                          color: AppColor.COLOR_GREY1)
                ],
              )
            ],
          ),

          // const CircleAvatar(
          //   backgroundColor: AppColor.THEME_COLOR_SECONDARY,
          //   radius: 10,
          //   child: Text(
          //     '1',
          //     style: TextStyle(
          //         color: AppColor.COLOR_BLACK,
          //         fontSize: 10,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          AppStyles.height4SizedBox(),
          AppStyles.contentStyle(
              Utils.formatDate(
                  pattern: 'HH:MM a', date: DateTime.parse(inbox.createdAt!)),
              color: AppColor.COLOR_GREY1)
        ],
      ),
    );
  }
}

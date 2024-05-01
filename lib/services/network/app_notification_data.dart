import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/view/inbox/screens/inbox_screen.dart';
import 'package:menu_minder/view/notifications/screens/notification_screen.dart';
import 'package:provider/provider.dart';

class AppNotificationData {
  void foregroundNotificationData(
      {BuildContext? context, required Map<String, dynamic> notificationData}) {
    log("App Notification Foreground data is:${notificationData.toString()}");
    log("Notification Type:${notificationData["notification_type"]}");
    // AppNavigator.push(context!, const NotificationsScreen());

    //Agar notification ma service receive aya to service receive api hit hogi
    // if (notificationData["notification_type"] == "space") {
    //   Get.to(BusinessDetail("push_notification",notificationData));
    // }
  }

  //This data has been called when notification comes and app is in background
  void backgroundNotificationData(
      {BuildContext? context,
      required Map<String, dynamic> notificationData}) async {
    log("App Notification Background data is:${notificationData.toString()}");
    log('App Notification Sent Time:${notificationData["notification_type"]}');

    if (notificationData["notification_type"] == "newPole") {
      context!.read<CoreProvider>().getHomeRecipies(context, '');
      // getx.Get.snackbar("Alert", "Someone sent you a message",
      //     backgroundColor: AppColors.PRIMARY_COLOR2_BLUE,
      //     colorText: AppColors.WHITE_COLOR);
      // Get.to(ChatScreen());

      // Get.to(BusinessDetail("push_notification",notificationData));
    } else if (notificationData["notification_type"] == 'chatNotification') {
      AppNavigator.push(context!, InboxScreen());
    } else {
      AppNavigator.push(context!, NotificationsScreen());
    }
  }

  //This data has been called when notifiation comes and app is closed or terminated
  void terminateNotificationData(
      {BuildContext? context,
      required Map<String, dynamic> notificationData}) async {
    log("App Notification terminate Background data is:${notificationData.toString()}");
    log("App Notification Sent Time:${notificationData["sentTime"]}");
    if (notificationData["notification_type"] == "newPole") {
      // getx.Get.snackbar("Alert", "Someone sent you a message",
      //     backgroundColor: AppColors.PRIMARY_COLOR2_BLUE,
      //     colorText: AppColors.WHITE_COLOR);
      // Get.to(ChatScreen());

      // Get.to(BusinessDetail("push_notification",notificationData));
    } else if (notificationData["notification_type"] == 'chatNotification') {
      AppNavigator.push(context!, InboxScreen());
    } else {
      AppNavigator.push(context!, NotificationsScreen());
    }
  }
}

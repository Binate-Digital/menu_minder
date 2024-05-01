// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
// import 'package:menu_minder/utils/actions.dart';
// import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
// import 'package:menu_minder/view/auth/screens/social_login_screen.dart';
// import 'package:menu_minder/view/create_profile/screens/create_profile_screen.dart';
// import 'package:menu_minder/view/my_polls/screens/my_polls_screen.dart';
// import 'package:menu_minder/view/notifications/screens/notification_screen.dart';
// import 'package:provider/provider.dart';

// import '../../utils/bottom_bar.dart';
// import 'shared_preference.dart';

// class NotificationNavigationClass {
//   AuthProvider? _userProvider;

//   void notificationMethod(
//       {required BuildContext context,
//       Map<String, dynamic>? notificationData,
//       String? pushNotificationType}) {
//     _setUserSession(context: context);

//     log("NOTIFCATION DATA is NOT NULL${notificationData.toString()}");

//     if (notificationData != null) {
//       if (notificationData['notification_type'] == 'newPole') {
//         AppNavigator.push(context, const MyPollsScreen());
//       } else {
//         AppNavigator.push(context, const NotificationsScreen());
//       }
//     } else {
//       AppNavigator.pushAndRemoveUntil(context, const BottomBar());
//     }

//     // if (notificationData != null) {
//     //   if (notificationData["notification_type"] ==
//     //       AppString.PUSH_NOTIFICATION_TYPE_NEW_POLL) {
//     //     AppNavigator.push(context, const MyPollsScreen());
//     //     //   if (notificationData['title'].toString().toLowerCase() ==
//     //     //       "New Order Received".toLowerCase()) {
//     //     //     AppNavigator.pushAndRemoveUntil(
//     //     //         context, BottomNavigationBarView(index: 0));
//     //     //   } else if (notificationData['title'] == "Order rejected" ||
//     //     //       notificationData['title'] == "Order completed") {
//     //     //     AppNavigator.pushAndRemoveUntil(
//     //     //         context, BottomNavigationBarView(index: 2, tabIndex: 1));
//     //     //   } else {
//     //     //     AppNavigator.pushAndRemoveUntil(
//     //     //         context, BottomNavigationBarView(index: 2));
//     //     //   }
//     //     // } else {
//     //     //   final currentRoute = Get.currentRoute;

//     //     //   log("GETX CURRETN ROUTE $currentRoute");

//     //     //   if (currentRoute == "/notification_screen") {
//     //     //     AppNavigator.pushReplacement(
//     //     //         context,
//     //     //         NotificationScreen(
//     //     //           notificationType: pushNotificationType,
//     //     //         ));
//     //     //   } else {
//     //     //     AppNavigator.push(
//     //     //         context,
//     //     //         NotificationScreen(
//     //     //           notificationType: pushNotificationType,
//     //     //         ));
//     //     //   }
//     //     // }
//     //   } else {
//     //     AppNavigator.push(context, const NotificationsScreen());
//     //   }
//     // } else {
//     //   AppNavigator.push(context, const BottomBar());
//     // }
//   }

//   void checkUserSessionMethod({required BuildContext context}) {
//     if (SharedPreference().getUser() != null) {
//       final user = jsonDecode(SharedPreference().getUser()!);
//       //assign reference to user provider
//       _userProvider = Provider.of<AuthProvider>(context, listen: false);
//       _userProvider?.setUser(user);

//       if (_userProvider!.userdata!.data!.userIsComplete == 1) {
//         print(_userProvider!.userdata!.data!.userAuthentication);
//         AppNavigator.pushAndRemoveUntil(context, const BottomBar());
//       } else {
//         AppNavigator.pushAndRemoveUntil(
//             context,
//             const CreateProfileScreen(
//               isEdit: false,
//             ));
//       }
//     } else {
//       AppNavigator.pushAndRemoveUntil(context, const SocialLoginScreen());
//       // AppNavigation.navigateToRemovingAll(
//       //     context, AppRouteName.preLoginScreenRoute);
//     }
//   }

//   void _setUserSession({required BuildContext context}) {
//     if (SharedPreference().getUser() != null) {
//       _userProvider = Provider.of<AuthProvider>(context, listen: false);
//       if (_userProvider?.userdata == null) {
//         //set login response to user provider method
//         _userProvider?.setUser(jsonDecode(SharedPreference().getUser()!));
//       }
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/routes_names.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/auth/screens/social_login_screen.dart';
import 'package:menu_minder/view/inbox/inbox_arguments.dart';
import 'package:menu_minder/view/my_polls/screens/my_polls_screen.dart';
import 'package:provider/provider.dart';
import '../../view/notifications/screens/notification_screen.dart';
import 'shared_preference.dart';

class NotificationNavigationClass {
  void notificationMethod(
      {required BuildContext context,
      Map<String, dynamic>? notificationData,
      String? pushNotificationType}) {
    _setUserSession(context: context);
    if (notificationData != null) {
      // Logger().i("Notification Data");
      // Logger().i(notificationData);
      // Logger().i(notificationData["notification_type"]);
      // Logger().i(notificationData);

      _navigateToScreens(
        notificationType: notificationData["notification_type"],
        notificationData: notificationData,
        context: context,
        pushNotificationType: pushNotificationType,
      );
    } else {
      print("notificationMethod else method");
      // clearAppDataMethod(context: context);
    }
  }

  void _navigateToScreens(
      {required String notificationType,
      Map<String, dynamic>? notificationData,
      required String? pushNotificationType,
      required BuildContext context}) {
    String? mainType;

    print("NOTIFICATION TYPE ${notificationData?['notification_type']}");

    if (notificationData?['notification_type'] == 'poleVote') {
      AppNavigator.pushAndRemoveUntil(
          context,
          const MyPollsScreen(
            fromNotification: true,
          ));
    } else if (notificationData?['notification_type'] == 'chatNotification') {
      const newRouteName = AppRouteName.inBoxScreen;
      bool isNewRouteSameAsCurrent = false;

      Navigator.popUntil(context, (route) {
        if (route.settings.name == newRouteName) {
          isNewRouteSameAsCurrent = true;
        }
        return true;
      });

      if (!isNewRouteSameAsCurrent) {
        Navigator.pushNamed(context, newRouteName,
            arguments: InboxScreenArguments(
              isFromKilledNotifications:
                  pushNotificationType == AppString.KILLED_NOTIFICATION,
            ));
      }
    } else if (notificationData?['notification_type'] == 'newPole') {
      bottomIndex.value = 0;
      AppNavigator.pushAndRemoveUntil(
          context,
          BottomBar(
            index: 0,
            pollID: notificationData?['pole_id'],
          ));
    } else {
      AppNavigator.push(
          context,
          const NotificationsScreen(
            isFromNotifications: true,
          ));
    }

    // if (AppStrings.PLANNER_TYPES.contains(notificationType)) {
    //   mainType = NetworkStrings.PLANNER_PUSH_KEY;
    // }

    // /// Navigate to Screens Based on types
    // ///
    // /// Planner Main Tasks
    // if (mainType == NetworkStrings.PLANNER_PUSH_KEY) {
    //   if (pushNotificationType == AppStrings.KILLED_NOTIFICATION) {
    //     AppNavigation.navigateReplacementNamed(
    //       context,
    //       AppRouteName.PLANNER_DETAIL_SCREEN,
    //       arguments:
    //           documentsArguments(notificationData, notificationType, true),
    //     );
    //   } else {
    //     if (StaticData.globalRoute == AppRouteName.CREATE_EDIT_PLANNER_ROUTE) {
    //       AppNavigation.navigateReplacementNamed(
    //         context,
    //         AppRouteName.PLANNER_DETAIL_SCREEN,
    //         arguments:
    //             documentsArguments(notificationData, notificationType, false),
    //       );
    //     } else {
    //       AppNavigation.navigateTo(
    //         context,
    //         AppRouteName.PLANNER_DETAIL_SCREEN,
    //         arguments:
    //             documentsArguments(notificationData, notificationType, false),
    //       );
    //     }
    //   }
    // }

    // /// planner Sub Tasks
    // /// Reminder
    // else if (notificationType == NetworkStrings.TASK_REMINDER_PUSH_KEY ||
    //     notificationType == NetworkStrings.REMINDER_PUSH_KEY) {
    //   bool isReminder = notificationType == NetworkStrings.REMINDER_PUSH_KEY;
    //   if (pushNotificationType == AppStrings.KILLED_NOTIFICATION) {
    //     AppNavigation.navigateReplacementNamed(
    //         context, AppRouteName.SUBTASK_LISTING_SCREEN,
    //         arguments: SubtaskListingArguments(
    //           date: notificationData?['date'],
    //           isKilled: true,
    //           index: isReminder ? 1 : 2,
    //         ));
    //   } else {
    //     if (StaticData.globalRoute == AppRouteName.CREATE_EDIT_PLANNER_ROUTE) {
    //       AppNavigation.navigateReplacementNamed(
    //           context, AppRouteName.SUBTASK_LISTING_SCREEN,
    //           arguments: SubtaskListingArguments(
    //             date: notificationData?['date'],
    //             isKilled: false,
    //             index: isReminder ? 1 : 2,
    //           ));
    //     } else {
    //       AppNavigation.navigateTo(context, AppRouteName.SUBTASK_LISTING_SCREEN,
    //           arguments: SubtaskListingArguments(
    //             date: notificationData?['date'],
    //             isKilled: true,
    //             index: isReminder ? 1 : 2,
    //           ));
    //     }
    //   }
    // }
  }

  // DocumentsArguments documentsArguments(
  //   Map<String, dynamic>? notificationData,
  //   String notificationType,
  //   bool? isKilled,
  // ) {
  //   return DocumentsArguments(
  //     isEdit: true,
  //     documentId: notificationData?["other_id"],
  //     date: notificationData?["date"],
  //     cardId: notificationData?["card_id"],
  //     title: notificationData?["title"],
  //     index: AppStrings.PLANNER_TYPES.indexOf(notificationType),
  //     isKilled: isKilled,
  //   );
  // }

  void checkUserSessionMethod({required BuildContext context}) {
    print("Check User session Method ");
    AuthProvider? userProvider = context.read<AuthProvider>();
    if (SharedPreference().getUser() != null) {
      userProvider.setUser(jsonDecode(SharedPreference().getUser()!));

      print("In  splash : user Not null ");
      _navigateToHomeScreen(context: context);
    } else {
      _navigateToPreLoginSelection(context);
    }
  }

  void _navigateToPreLoginSelection(BuildContext context) {
    // AppNavigation.navigateToRemovingAll(
    //     context, AppRouteName.PRE_LOGIN_SCREEN_ROUTE);

    AppNavigator.pushAndRemoveUntil(context, SocialLoginScreen());
  }

  void _navigateToHomeScreen({String? role, required BuildContext context}) {
    // AppNavigation.navigateReplacementNamed(
    //   context,
    //   AppRouteName.BOTTOM_NAV_BAR_SCREEN_ROUTE,
    // );

    AppNavigator.pushAndRemoveUntil(context, BottomBar());
  }

  void _setUserSession({required BuildContext context}) {
    if (SharedPreference().getUser() != null) {
      if (context.read<AuthProvider>().userdata == null) {
        /// Set login response to user provider method
        print("abccccccccccc");
        context
            .read<AuthProvider>()
            .setUser(jsonDecode(SharedPreference().getUser()!));
      }
    }
  }
}

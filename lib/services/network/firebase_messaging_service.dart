// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:menu_minder/utils/strings.dart';

// import 'connectivity_manager.dart';
// import 'notification_navigation.dart';
// import 'shared_preference.dart';

// class FirebaseMessagingService {
//   static ConnectivityManager? _connectivityManager;
//   static FirebaseMessagingService? _messagingService;
//   static FirebaseMessaging? _firebaseMessaging;
//   late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
//   DarwinInitializationSettings? _initializationSettingsIOS;
//   AndroidInitializationSettings? _initializationSettingsAndroid;
//   AndroidNotificationDetails? _androidLocalNotificationDetails;
//   AndroidNotificationChannel? androidNotificationChannel;
//   NotificationDetails? _androidNotificationDetails;
//   InitializationSettings? _initializationSettings;
//   NotificationAppLaunchDetails? _notificationAppLaunchDetails;
//   bool? _didNotificationLaunchApp;
//   NotificationNavigationClass _notificationNavigationClass =
//       NotificationNavigationClass();

//   FirebaseMessagingService._createInstance() {
//     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   }

//   factory FirebaseMessagingService() {
//     if (_messagingService == null) {
//       _messagingService = FirebaseMessagingService._createInstance();
//       _firebaseMessaging = _getMessagingService();
//       _connectivityManager = ConnectivityManager();
//     }
//     return _messagingService!;
//   }

//   static FirebaseMessaging _getMessagingService() {
//     return _firebaseMessaging ??= FirebaseMessaging.instance;
//   }

//   Future<String?> getToken() async {
//     if (await _connectivityManager!.isInternetConnected()) {
//       return _firebaseMessaging!.getToken();
//     } else {
//       return null;
//     }
//   }

//   Future initializeNotificationSettings() async {
//     NotificationSettings? settings = await _firebaseMessaging
//         ?.requestPermission(
//           alert: true,
//           announcement: false,
//           badge: true,
//           carPlay: false,
//           criticalAlert: false,
//           provisional: false,
//           sound: true,
//         );

//     if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings?.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     androidNotificationChannel = AndroidNotificationChannel(
//       AppString.NOTIFICATION_ID,
//       AppString.NOTIFICATION_TITLE,
//       description: AppString.NOTIFICATION_DESCRIPTION,
//       importance: Importance.max,
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(androidNotificationChannel!);

//     await terminateTapNotification();

//     if (Platform.isIOS) {
//       await _initializeIosLocalNotificationSettings();
//     } else {
//       await _initializeAndroidLocalNotificationSettings();
//     }
//   }

//   Future<void> _initializeIosLocalNotificationSettings() async {
//     _initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );

//     _initializationSettings = InitializationSettings(
//       iOS: _initializationSettingsIOS,
//       android: _initializationSettingsAndroid,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       _initializationSettings!,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         onTapLocalNotification(response.payload);
//       },
//       onDidReceiveBackgroundNotificationResponse: (
//         NotificationResponse response,
//       ) {
//         onTapLocalNotification(response.payload);
//       },
//     );
//   }

//   Future<void> _initializeAndroidLocalNotificationSettings() async {
//     _initializationSettingsAndroid = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );

//     _initializationSettings = InitializationSettings(
//       android: _initializationSettingsAndroid,
//       iOS: _initializationSettingsIOS,
//     );

//     _androidLocalNotificationDetails = AndroidNotificationDetails(
//       AppString.LOCAL_NOTIFICATION_ID,
//       AppString.LOCAL_NOTIFICATION_TITLE,
//       channelDescription: AppString.LOCAL_NOTIFICATION_DESCRIPTION,
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );

//     _androidNotificationDetails = NotificationDetails(
//       android: _androidLocalNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       _initializationSettings!,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         onTapLocalNotification(response.payload);
//       },
//       onDidReceiveBackgroundNotificationResponse: (
//         NotificationResponse response,
//       ) {
//         onTapLocalNotification(response.payload);
//       },
//     );
//   }

//   Future<void> _backgroundTapLocalNotification() async {
//     _notificationAppLaunchDetails =
//         await _flutterLocalNotificationsPlugin
//             .getNotificationAppLaunchDetails();
//     _didNotificationLaunchApp =
//         _notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

//     if (_didNotificationLaunchApp ?? false) {
//       onCloseAppTapLocalNotification(
//         _notificationAppLaunchDetails?.notificationResponse?.payload ?? null,
//       );
//     } else {
//       await terminateTapNotification();
//     }
//   }

//   void foregroundNotification() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
//       try {
//         print("foreground message data is " + message!.data.toString());
//         _showLocalNotification(
//           localNotificationId:
//               DateTime.now().hour +
//               DateTime.now().minute +
//               DateTime.now().second,
//           notificationData: message.data,
//         );
//       } catch (error) {
//         log("error");
//       }
//     });
//   }

//   void backgroundTapNotification() {
//     print("Background notification click");
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
//       try {
//         RemoteMessage? terminatedMessage =
//             await _firebaseMessaging?.getInitialMessage();
//         SharedPreference().setNotificationMessageId(
//           messageId: message?.messageId,
//         );
//         print("Background Message:${message?.data}");
//         print("Message Notification:${message?.notification?.toString()}");
//         if (SharedPreference().getUser() != null) {
//           print("Shared User not null");
//           if (message != null) {
//             _notificationNavigationClass.notificationMethod(
//               context: StaticData.navigatorKey.currentContext!,
//               notificationData: message.data,
//               pushNotificationType: AppString.BACKGROUND_NOTIFICATION,
//             );
//           } else {
//             print("Check user session else method");
//             _notificationNavigationClass.checkUserSessionMethod(
//               context: StaticData.navigatorKey.currentContext!,
//             );
//           }
//         } else {
//           print("Check user session else 2 method");
//           _notificationNavigationClass.checkUserSessionMethod(
//             context: StaticData.navigatorKey.currentContext!,
//           );
//         }
//       } catch (error) {
//         log("error");
//         print(error);
//       }
//     });
//   }

//   Future<void> terminateTapNotification() async {
//     print("Terminate method");
//     RemoteMessage? _terminatedMessage =
//         await _firebaseMessaging?.getInitialMessage();

//     if (SharedPreference().getUser() != null) {
//       if (SharedPreference().getNotificationMessageId() !=
//           _terminatedMessage?.messageId) {
//         if (_terminatedMessage != null) {
//           _notificationNavigationClass.notificationMethod(
//             context: StaticData.navigatorKey.currentContext!,
//             notificationData: _terminatedMessage.data,
//             pushNotificationType: AppString.KILLED_NOTIFICATION,
//           );
//         } else {
//           _notificationNavigationClass.checkUserSessionMethod(
//             context: StaticData.navigatorKey.currentContext!,
//           );
//         }
//       } else {
//         _notificationNavigationClass.checkUserSessionMethod(
//           context: StaticData.navigatorKey.currentContext!,
//         );
//       }
//     } else {
//       _notificationNavigationClass.checkUserSessionMethod(
//         context: StaticData.navigatorKey.currentContext!,
//       );
//     }
//   }

//   Future<void> _showLocalNotification({
//     int? localNotificationId,
//     Map<String, dynamic>? notificationData,
//   }) async {
//     if (notificationData != null) {
//       log("Notification Data:${notificationData}");
//       log("Notification Data:${notificationData["notification_type"]}");

//       await _flutterLocalNotificationsPlugin.show(
//         localNotificationId ?? 0,
//         notificationData["notification_title"] ?? "",
//         notificationData["notification_body"] ?? "",
//         _androidNotificationDetails,
//         payload: jsonEncode(notificationData),
//       );
//     }
//   }

//   void onTapLocalNotification(String? payload) async {
//     Map<String, dynamic> _notificationData = {};
//     if (payload != null) {
//       _notificationData = jsonDecode(payload);

//       if (SharedPreference().getUser() != null) {
//         if (_notificationData != null) {
//           log("Local Message Data:${payload}");
//           _notificationNavigationClass.notificationMethod(
//             context: StaticData.navigatorKey.currentContext!,
//             notificationData: _notificationData,
//             pushNotificationType: AppString.FOREGROUND_NOTIFICATION,
//           );
//         } else {
//           _notificationNavigationClass.checkUserSessionMethod(
//             context: StaticData.navigatorKey.currentContext!,
//           );
//         }
//       } else {
//         _notificationNavigationClass.checkUserSessionMethod(
//           context: StaticData.navigatorKey.currentContext!,
//         );
//       }
//     } else {
//       _notificationNavigationClass.checkUserSessionMethod(
//         context: StaticData.navigatorKey.currentContext!,
//       );
//     }
//   }

//   void onCloseAppTapLocalNotification(String? payload) async {
//     Map<String, dynamic> _notificationData = {};
//     if (payload != null) {
//       _notificationData = jsonDecode(payload);

//       if (SharedPreference().getUser() != null) {
//         if (_notificationData != null) {
//           log("Local Message Data:${payload}");
//           _notificationNavigationClass.notificationMethod(
//             context: StaticData.navigatorKey.currentContext!,
//             notificationData: _notificationData,
//             pushNotificationType: AppString.KILLED_NOTIFICATION,
//           );
//         } else {
//           _notificationNavigationClass.checkUserSessionMethod(
//             context: StaticData.navigatorKey.currentContext!,
//           );
//         }
//       } else {
//         _notificationNavigationClass.checkUserSessionMethod(
//           context: StaticData.navigatorKey.currentContext!,
//         );
//       }
//     } else {
//       _notificationNavigationClass.checkUserSessionMethod(
//         context: StaticData.navigatorKey.currentContext!,
//       );
//     }
//   }
// }

// class StaticData {
//   static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   static bool notificationForegroundListenerEnable = false;
//   static bool notificationBackgroundListenerEnable = false;
// }




import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:menu_minder/services/network/connectivity_manager.dart';
import 'package:menu_minder/services/network/notification_navigation.dart';
import 'package:menu_minder/services/network/shared_preference.dart';
import 'package:menu_minder/utils/strings.dart';

class FirebaseMessagingService {
  static ConnectivityManager? _connectivityManager;
  static FirebaseMessagingService? _messagingService;
  static FirebaseMessaging? _firebaseMessaging;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  DarwinInitializationSettings? _initializationSettingsIOS;
  AndroidInitializationSettings? _initializationSettingsAndroid;
  AndroidNotificationDetails? _androidLocalNotificationDetails;
  AndroidNotificationChannel? androidNotificationchannel;
  NotificationDetails? _androidNotificationDetails;
  InitializationSettings? _initializationSettings;
  NotificationNavigationClass _notificationNavigationClass =
  NotificationNavigationClass();
  NotificationAppLaunchDetails? _notificationAppLaunchDetails;
  bool? _didNotificationLaunchApp;
  StreamSubscription? _deepLinkSubscription, _intentDataStreamSubscription;

  FirebaseMessagingService._createInstance() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  factory FirebaseMessagingService() {
    if (_messagingService == null) {
      _messagingService = FirebaseMessagingService._createInstance();
      _firebaseMessaging = _getMessagingService();
      _connectivityManager = ConnectivityManager();
    }
    return _messagingService!;
  }

  static FirebaseMessaging _getMessagingService() {
    return _firebaseMessaging ??= FirebaseMessaging.instance;
  }

  Future<String?> getToken() async {
    String? deviceToken = "123";
    try {
      if (await _connectivityManager!.isInternetConnected()) {
        deviceToken = await _firebaseMessaging?.getToken();
        return deviceToken;
      }
    } catch (error) {}
    return deviceToken;
  }

  Future initializeNotificationSettings() async {
    NotificationSettings? settings = await _firebaseMessaging
        ?.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
    _firebaseMessaging?.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings?.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    androidNotificationchannel = AndroidNotificationChannel(
      AppString.NOTIFICATION_ID, // id
      AppString.NOTIFICATION_TITLE, // title
      description: AppString.NOTIFICATION_DESCRIPTION,
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationchannel!);

    await _backgroundTapLocalNotification();

    if (Platform.isIOS) {
      await _initializeIosLocalNotificationSettings();
    } else {
      await _initializeAndroidLocalNotificationSettings();
    }
  }

  Future<void> _initializeIosLocalNotificationSettings() async {
    _initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // onDidReceiveLocalNotification: (id, title, body, payload) async {
      //   onTapLocalNotification(payload);
      // },
    );
    _initializationSettings = InitializationSettings(
      iOS: _initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings!,
      onDidReceiveNotificationResponse: (details) {
        onTapLocalNotification(details.payload);
      },
    );
  }

  Future<void> _initializeAndroidLocalNotificationSettings() async {
    _initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    _initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
    );
    _androidLocalNotificationDetails = AndroidNotificationDetails(
      AppString.LOCAL_NOTIFICATION_ID,
      AppString.LOCAL_NOTIFICATION_TITLE,
      channelDescription: AppString.LOCAL_NOTIFICATION_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
    );
    _androidNotificationDetails = NotificationDetails(
      android: _androidLocalNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings!,
      onDidReceiveNotificationResponse: (details) {
        onTapLocalNotification(details.payload);
      },
    );
  }

  Future<void> _backgroundTapLocalNotification() async {
    _notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    _didNotificationLaunchApp =
        _notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    if (_didNotificationLaunchApp ?? false) {
      onCloseAppTapLocalNotification(
        _notificationAppLaunchDetails?.notificationResponse?.payload,
      );
    } else {
      await terminateTapNotification();
    }
  }

  void foregroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      log("Message data :${message?.data}");
      log("Message notification:${message?.notification}");

      try {
        _showLocalNotification(
          localNotificationId:
              DateTime.now().hour +
              DateTime.now().minute +
              DateTime.now().second,
          notificationData: message?.data,
        );
      } catch (error) {
        log("error");
      }
    });
  }

  void backgroundTapNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      try {
        RemoteMessage? terminatedMessage =
            await _firebaseMessaging?.getInitialMessage();
        SharedPreference().setNotificationMessageId(
          messageId: message?.messageId,
        );

        log("Message Notification:${message?.notification?.android?.priority}");

        if (SharedPreference().getUser() != null) {
          if (message != null) {
            _notificationNavigationClass.notificationMethod(
              context: StaticData.navigatorKey.currentContext!,
              notificationData: message.data,
              pushNotificationType: AppString.BACKGROUND_NOTIFICATION,
            );
          } else {
            print("Check user session else method");
            _notificationNavigationClass.checkUserSessionMethod(
              context: StaticData.navigatorKey.currentContext!,
            );
          }
        } else {
          print("Check user session else 2 method");
          _notificationNavigationClass.checkUserSessionMethod(
            context: StaticData.navigatorKey.currentContext!,
          );
        }
        //   if (message != null && message.data != null) {
        //     // _notificationNavigationClass.notificationMethod(
        //     //     context: StaticData.navigatorKey.currentContext!,
        //     //     notificationData: message.data,
        //     //     pushNotificationType: AppStrings.BACKGROUND_NOTIFICATION);
        //   } else {
        //     // _notificationNavigationClass.checkUserSessionMethod(
        //     //     context: StaticData.navigatorKey.currentContext!);
        //   }
        // } else {
        //   // _notificationNavigationClass.checkUserSessionMethod(
        //   //     context: StaticData.navigatorKey.currentContext!);
        // }
      } catch (error) {
        log("error");
      }
    });
  }

  Future<void> terminateTapNotification() async {
    RemoteMessage? _terminatedMessage =
        await _firebaseMessaging?.getInitialMessage();

         if (SharedPreference().getUser() != null) {
      if (SharedPreference().getNotificationMessageId() !=
          _terminatedMessage?.messageId) {
        if (_terminatedMessage != null) {
          _notificationNavigationClass.notificationMethod(
            context: StaticData.navigatorKey.currentContext!,
            notificationData: _terminatedMessage.data,
            pushNotificationType: AppString.KILLED_NOTIFICATION,
          );
        } else {
          _notificationNavigationClass.checkUserSessionMethod(
            context: StaticData.navigatorKey.currentContext!,
          );
        }
      } else {
        _notificationNavigationClass.checkUserSessionMethod(
          context: StaticData.navigatorKey.currentContext!,
        );
      }
    } else {
      _notificationNavigationClass.checkUserSessionMethod(
        context: StaticData.navigatorKey.currentContext!,
      );
    }
    // if (SharedPreference().getUser() != null) {
    //   if (SharedPreference().getNotificationMessageId() !=
    //       _terminatedMessage?.messageId) {
    //     if (_terminatedMessage != null && _terminatedMessage.data != null) {
    //       // _notificationNavigationClass.notificationMethod(
    //       //     context: StaticData.navigatorKey.currentContext!,
    //       //     notificationData: _terminatedMessage.data,
    //       //     pushNotificationType: AppStrings.KILLED_NOTIFICATION);
    //     } else {
    //       // _notificationNavigationClass.checkUserSessionMethod(
    //       //     context: StaticData.navigatorKey.currentContext!);
    //     }
    //   } else {
    //     // _notificationNavigationClass.checkUserSessionMethod(
    //     //     context: StaticData.navigatorKey.currentContext!);
    //   }
    // } else {
    //   // _notificationNavigationClass.checkUserSessionMethod(
    //   //     context: StaticData.navigatorKey.currentContext!);
    // }
  }

  Future<void> _showLocalNotification({
    int? localNotificationId,
    Map<String, dynamic>? notificationData,
  }) async {
    // log("jhfhjfhgjdfjghfjhgfhjgfg");
    // print("heeeeeee");
    // await incrementBadgeCount();
    if (notificationData != null) {
      log("Notification Data:${notificationData}");
      // if (notificationData["route"] == "chat-messages" &&
      //     Constants.chatRouting == AppRouteName.chatDetailScreenRoute) {
      //} else {
      print('object');
      log("messageghdhgjdfjhgfhj");
      await _flutterLocalNotificationsPlugin.show(
        localNotificationId ?? 0,
        notificationData["title"] ?? "",
        notificationData["body"] ?? "",
        _androidNotificationDetails,
        payload: jsonEncode(notificationData),
      );
      //}
    }
  }

  void onTapLocalNotification(String? payload) async {
    Map<String, dynamic> _notificationData = {};
      if (payload != null) {
      _notificationData = jsonDecode(payload);

      if (SharedPreference().getUser() != null) {
        if (_notificationData != null) {
          log("Local Message Data:${payload}");
          _notificationNavigationClass.notificationMethod(
            context: StaticData.navigatorKey.currentContext!,
            notificationData: _notificationData,
            pushNotificationType: AppString.FOREGROUND_NOTIFICATION,
          );
        } else {
          _notificationNavigationClass.checkUserSessionMethod(
            context: StaticData.navigatorKey.currentContext!,
          );
        }
      } else {
        _notificationNavigationClass.checkUserSessionMethod(
          context: StaticData.navigatorKey.currentContext!,
        );
      }
    } else {
      _notificationNavigationClass.checkUserSessionMethod(
        context: StaticData.navigatorKey.currentContext!,
      );
    }
  }

  void onCloseAppTapLocalNotification(String? payload) async {
    Map<String, dynamic> _notificationData = {};
       if (payload != null) {
      _notificationData = jsonDecode(payload);

      if (SharedPreference().getUser() != null) {
        if (_notificationData != null) {
          log("Local Message Data:${payload}");
          _notificationNavigationClass.notificationMethod(
            context: StaticData.navigatorKey.currentContext!,
            notificationData: _notificationData,
            pushNotificationType: AppString.KILLED_NOTIFICATION,
          );
        } else {
          _notificationNavigationClass.checkUserSessionMethod(
            context: StaticData.navigatorKey.currentContext!,
          );
        }
      } else {
        _notificationNavigationClass.checkUserSessionMethod(
          context: StaticData.navigatorKey.currentContext!,
        );
      }
    } else {
      _notificationNavigationClass.checkUserSessionMethod(
        context: StaticData.navigatorKey.currentContext!,
      );
    }
  }
  }


class StaticData {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool notificationForegroundListenerEnable = false;
  static bool notificationBackgroundListenerEnable = false;
}


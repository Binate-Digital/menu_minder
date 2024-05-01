// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'app_notification_data.dart';

// class FirebaseMessagingService {
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   AppNotificationData? appNotificationData;
//   AndroidNotificationChannel? androidNotificationchannel;
//   static FirebaseMessagingService? _messagingService;

//   static FirebaseMessaging? _firebaseMessaging;

//   FirebaseMessagingService._createInstance();

//   factory FirebaseMessagingService() {
//     // factory with constructor, return some value
//     if (_messagingService == null) {
//       _messagingService = FirebaseMessagingService
//           ._createInstance(); // This is executed only once, singleton object

//       _firebaseMessaging = _getMessagingService();
//     }
//     return _messagingService!;
//   }

//   static FirebaseMessaging _getMessagingService() {
//     return _firebaseMessaging ??= FirebaseMessaging.instance;
//   }

//   Future<String?> getToken() {
//     return _firebaseMessaging!.getToken();
//   }

//   Future initializeNotificationSettings() async {
//     NotificationSettings settings = await _firebaseMessaging!.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'chat', // id
//         'High Importance Notifications', // title

//         // description
//         importance: Importance.max,
//         description: 'This channel is used for important notifications.');
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//     //
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   //This will execute when the app is open and in foreground
//   void foregroundNotification() {
//     print('Got a message whilst in the foreground!');
//     //
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//       // print('Message request id: ${message.data["request_id"]}');
//       //AppDialogs.showToast(message: "Data on foreground");
//       appNotificationData = AppNotificationData();
//       appNotificationData!.foregroundNotificationData(
//           context: StaticData.navigatorKey.currentContext,
//           notificationData: message.data);
//     });
//     // StaticData.notificationForegroundListenerEnable = true;
//   }

//   //This will execute when the app is in background but not killed and tap on that notification
//   void backgroundTapNotification() {
//     print('Got a message whilst in the foreground!');
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       RemoteMessage? terminatedMessage =
//           await _firebaseMessaging!.getInitialMessage();
//       // print('Got a message whilst in the background but not terminated!');
//       // print('Message data: ${message.data}');
//       // print("Current Data Time:${DateTime.now()}");
//       // AppDialogs.showToast(
//       //     message: "Data on background but not killed:${message.sentTime}");
//       appNotificationData = AppNotificationData();
//       appNotificationData!.backgroundNotificationData(
//           context: StaticData.navigatorKey.currentContext,
//           notificationData: message.data);
//     });
//   }

//   //This will work when the app is killed and notification comes and tap on that notification
//   void terminateTapNotification() async {
//     RemoteMessage? terminatedMessage =
//         await _firebaseMessaging!.getInitialMessage();

//     //print("Terminated message notification:"+terminatedMessage.notification.title.toString());
//     // AppDialogs.showToast(
//     //     message: "Data on terminated background");

//     if (terminatedMessage != null) {
//       //When there is no notification error is beacuse of firebase messaging plugin
//       if (terminatedMessage.notification != null) {
//         //print("Terminated message:${terminatedMessage.data.toString()}");
//         // AppDialogs.showToast(
//         //     message: "Data on terminated background when notification tap${terminatedMessage
//         //         .data} Notification Time${terminatedMessage.notification}");

//         appNotificationData = AppNotificationData();
//         appNotificationData!.terminateNotificationData(
//           context: StaticData.navigatorKey.currentContext,
//           notificationData: terminatedMessage.data,
//         );
//       }
//     }
//   }

// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //     print("data available ha");
// // }
// }

// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FirebaseMessagingService {
//   static FirebaseMessagingService? _messagingService;
//
//   static FirebaseMessaging? _firebaseMessaging;
//
//   FirebaseMessagingService._createInstance();
//
//   factory FirebaseMessagingService() {
//     // factory with constructor, return some value
//     if (_messagingService == null) {
//       _messagingService = FirebaseMessagingService
//           ._createInstance(); // This is executed only once, singleton object
//
//       _firebaseMessaging = _getMessagingService();
//     }
//     return _messagingService!;
//   }
//
//   static FirebaseMessaging _getMessagingService() {
//     return _firebaseMessaging ??= FirebaseMessaging.instance;
//   }
//
//   Future<String?> getToken() async {
//     try {
//       return await _firebaseMessaging!.getToken();
//     } catch (error) {
//       return null;
//     }
//   }
//
//   initialize() async
//   {
//     NotificationSettings settings = await _firebaseMessaging!.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'app_notification_data.dart';

// class FirebaseMessagingService {
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   AppNotificationData? appNotificationData;
//   AndroidNotificationChannel? androidNotificationchannel;
//   static FirebaseMessagingService? _messagingService;

//   static FirebaseMessaging? _firebaseMessaging;

//   FirebaseMessagingService._createInstance();

//   factory FirebaseMessagingService() {
//     // factory with constructor, return some value
//     if (_messagingService == null) {
//       _messagingService = FirebaseMessagingService
//           ._createInstance(); // This is executed only once, singleton object

//       _firebaseMessaging = _getMessagingService();
//     }
//     return _messagingService!;
//   }

//   static FirebaseMessaging _getMessagingService() {
//     return _firebaseMessaging ??= FirebaseMessaging.instance;
//   }

//   Future<String?> getToken() {
//     return _firebaseMessaging!.getToken();
//   }

//   Future initializeNotificationSettings() async {
//     NotificationSettings settings = await _firebaseMessaging!.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'chat',
//       'High Importance Notifications',
//       importance: Importance.max,
//     );
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     _flutterLocalNotificationsPlugin.initialize(
//       InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         iOS: DarwinInitializationSettings(),

//       ),

//     );
//   }

//   NotificationDetails? _androidNotificationDetails;

//   void _showLocalNotification(
//       {int? localNotificationId,
//       Map<String, dynamic>? notificationData}) async {
//     if (notificationData != null) {
//       //log("Notification Data:${notificationData}");
//       // log("Notification Data:${notificationData["notification_type"]}");
//       // log("Other Id:${notificationData["other_id"] is int}");
//       await _flutterLocalNotificationsPlugin.show(
//           localNotificationId ?? 0,
//           notificationData["title"] ?? "",
//           notificationData["body"] ?? "",
//           _androidNotificationDetails,
//           payload: jsonEncode(notificationData));
//     }
//   }

//   foregroundNotification(BuildContext context) {
//     print('Got a message whilst in the foreground!');
//     //
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       try {
//         _showLocalNotification(
//             localNotificationId: DateTime.now().hour +
//                 DateTime.now().minute +
//                 DateTime.now().second,
//             notificationData: message.data);
//       } catch (error) {
//         log("error");
//       }

//       // print('Message request id: ${message.data["request_id"]}');
//       //AppDialogs.showToast(message: "Data on foreground");
//       // appNotificationData = AppNotificationData();
//       // appNotificationData!.foregroundNotificationData(
//       //     context: StaticData.navigatorKey.currentContext,
//       //     //  StaticData.navigatorKey.currentContext,
//       //     notificationData: message.data);
//     });
//     // StaticData.notificationForegroundListenerEnable = true;
//   }

//   //This will execute when the app is in background but not killed and tap on that notification
//   backgroundTapNotification(BuildContext context) {
//     print("THIS IS TAPPED");
//     print('Got a message whilst in the foreground!');
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       print('Message data: ${message.data}');
//       RemoteMessage? terminatedMessage =
//           await _firebaseMessaging!.getInitialMessage();
//       print('Got a message whilst in the background but not terminated!');
//       print('Message data: ${message.data}');
//       print("Current Data Time:${DateTime.now()}");
//       // Utils.s(
//       appNotificationData = AppNotificationData();
//       appNotificationData!.backgroundNotificationData(
//           context: StaticData.navigatorKey.currentContext,
//           notificationData: message.data);
//     });
//   }

//   //This will work when the app is killed and notification comes and tap on that notification
//   void terminateTapNotification() async {
//     RemoteMessage? terminatedMessage =
//         await _firebaseMessaging!.getInitialMessage();

//     //print("Terminated message notification:"+terminatedMessage.notification.title.toString());
//     // AppDialogs.showToast(
//     //     message: "Data on terminated background");

//     if (terminatedMessage != null) {
//       //When there is no notification error is beacuse of firebase messaging plugin
//       if (terminatedMessage.notification != null) {
//         //print("Terminated message:${terminatedMessage.data.toString()}");
//         // AppDialogs.showToast(
//         //     message: "Data on terminated background when notification tap${terminatedMessage
//         //         .data} Notification Time${terminatedMessage.notification}");

//         appNotificationData = AppNotificationData();
//         appNotificationData!.terminateNotificationData(
//           context: StaticData.navigatorKey.currentContext,
//           notificationData: terminatedMessage.data,
//         );
//       }
//     }
//   }

// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //     print("data available ha");
// // }
// }

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:menu_minder/utils/strings.dart';

import 'connectivity_manager.dart';
import 'notification_navigation.dart';
import 'shared_preference.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'connectivity_manager.dart';

class FirebaseMessagingService {
  static ConnectivityManager? _connectivityManager;
  static FirebaseMessagingService? _messagingService;
  static FirebaseMessaging? _firebaseMessaging;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  IOSInitializationSettings? _initializationSettingsIOS;
  AndroidInitializationSettings? _initializationSettingsAndroid;
  AndroidNotificationDetails? _androidLocalNotificationDetails;
  AndroidNotificationChannel? androidNotificationChannel;
  NotificationDetails? _androidNotificationDetails;
  InitializationSettings? _initializationSettings;
  NotificationAppLaunchDetails? _notificationAppLaunchDetails;
  bool? _didNotificationLaunchApp;
  NotificationNavigationClass _notificationNavigationClass =
      NotificationNavigationClass();

  FirebaseMessagingService._createInstance();

  factory FirebaseMessagingService() {
    // factory with constructor, return some value
    if (_messagingService == null) {
      _messagingService = FirebaseMessagingService
          ._createInstance(); // This is executed only once, singleton object
      _firebaseMessaging = _getMessagingService();
      _connectivityManager = ConnectivityManager();
    }
    return _messagingService!;
  }

  static FirebaseMessaging _getMessagingService() {
    return _firebaseMessaging ??= FirebaseMessaging.instance;
  }

  Future<String?> getToken() async {
    if (await _connectivityManager!.isInternetConnected()) {
      return _firebaseMessaging!.getToken();
    } else {
      // AppDialogs.showToast(message: NetworkStrings.NO_INTERNET_CONNECTION);
      return null;
    }
  }

  Future initializeNotificationSettings() async {
    NotificationSettings? settings =
        await _firebaseMessaging?.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
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
    androidNotificationChannel = AndroidNotificationChannel(
      AppString.NOTIFICATION_ID, // id
      AppString.NOTIFICATION_TITLE, // title
      description: AppString.NOTIFICATION_DESCRIPTION,
      // description
      importance: Importance.max,
    );
    //
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel!);
    // await _backgroundTapLocalNotification();
    await terminateTapNotification();
    if (Platform.isIOS) {
      await _initializeIosLocalNotificationSettings();
    } else {
      await _initializeAndroidLocalNotificationSettings();
    }
  }

  Future<void> _initializeIosLocalNotificationSettings() async {
    _initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);
    _initializationSettings =
        InitializationSettings(iOS: _initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings!,
        onSelectNotification: onTapLocalNotification);
  }

  Future<void> _initializeAndroidLocalNotificationSettings() async {
    _initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    _initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
    );
    _androidLocalNotificationDetails = AndroidNotificationDetails(
        AppString.LOCAL_NOTIFICATION_ID, AppString.LOCAL_NOTIFICATION_TITLE,
        channelDescription: AppString.LOCAL_NOTIFICATION_DESCRIPTION,
        importance: Importance.max,
        priority: Priority.high);
    _androidNotificationDetails =
        NotificationDetails(android: _androidLocalNotificationDetails);

    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings!,
        onSelectNotification: onTapLocalNotification);
  }

  //app yaha sa start hogi
  Future<void> _backgroundTapLocalNotification() async {
    // ya uswaqt aiga jb hum local notification pr tab krega jb app close hogi.
    _notificationAppLaunchDetails = await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    _didNotificationLaunchApp =
        _notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    if (_didNotificationLaunchApp ?? false) {
      // AppDialogs.showToast(message: _notificationAppLaunchDetails?.payload.toString());

      onCloseAppTapLocalNotification(
          _notificationAppLaunchDetails?.payload ?? null);
    } else {
      await terminateTapNotification();
    }
  }

  /// This will execute when the app is open and in foreground
  void foregroundNotification() {
    //To registered firebase messaging listener only once
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      try {
        print("foreground message data is " + message!.data.toString());
        _showLocalNotification(
            localNotificationId: DateTime.now().hour +
                DateTime.now().minute +
                DateTime.now().second,
            notificationData: message.data);
      } catch (error) {
        log("error");
      }
    });
  }

  /// This will execute when the app is in background but not killed and tap on that notification
  void backgroundTapNotification() {
    print("Background notification click");
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      try {
        RemoteMessage? terminatedMessage =
            await _firebaseMessaging?.getInitialMessage();
        SharedPreference()
            .setNotificationMessageId(messageId: message?.messageId);
        print("Background Message:${message?.data}");
        print("Message Notification:${message?.notification?.toString()}");
        if (SharedPreference().getUser() != null) {
          print("Shared User not null");
          if (message != null) {
            _notificationNavigationClass.notificationMethod(
                context: StaticData.navigatorKey.currentContext!,
                notificationData: message.data,
                pushNotificationType: AppString.BACKGROUND_NOTIFICATION);
          } else {
            print("Check user session else method");
            _notificationNavigationClass.checkUserSessionMethod(
                context: StaticData.navigatorKey.currentContext!);
          }
        } else {
          print("Check user session else 2 method");
          _notificationNavigationClass.checkUserSessionMethod(
              context: StaticData.navigatorKey.currentContext!);
        }
      } catch (error) {
        log("error");
        print(error);
      }
    });
  }

  /// This will work when the app is killed and notification comes and tap on that notification
  Future<void> terminateTapNotification() async {
    print("Terminate method");
    RemoteMessage? _terminatedMessage =
        await _firebaseMessaging?.getInitialMessage();

    if (SharedPreference().getUser() != null) {
      if (SharedPreference().getNotificationMessageId() !=
          _terminatedMessage?.messageId) {
        if (_terminatedMessage != null) {
          _notificationNavigationClass.notificationMethod(
              context: StaticData.navigatorKey.currentContext!,
              notificationData: _terminatedMessage.data,
              pushNotificationType: AppString.KILLED_NOTIFICATION);
        } else {
          _notificationNavigationClass.checkUserSessionMethod(
              context: StaticData.navigatorKey.currentContext!);
        }
      } else {
        _notificationNavigationClass.checkUserSessionMethod(
            context: StaticData.navigatorKey.currentContext!);
      }
    } else {
      _notificationNavigationClass.checkUserSessionMethod(
          context: StaticData.navigatorKey.currentContext!);
    }
  }

  void _showLocalNotification(
      {int? localNotificationId,
      Map<String, dynamic>? notificationData}) async {
    if (notificationData != null) {
      log("Notification Data:${notificationData}");
      log("Notification Data:${notificationData["notification_type"]}");
      // log("Other Id:${notificationData["other_id"] is int}");

      await _flutterLocalNotificationsPlugin.show(
          localNotificationId ?? 0,
          notificationData["notification_title"] ?? "",
          notificationData["notification_body"] ?? "",
          _androidNotificationDetails,
          payload: jsonEncode(notificationData));
    }
  }

  //on tap local notification
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
              pushNotificationType: AppString.FOREGROUND_NOTIFICATION);
        } else {
          _notificationNavigationClass.checkUserSessionMethod(
              context: StaticData.navigatorKey.currentContext!);
        }
      } else {
        _notificationNavigationClass.checkUserSessionMethod(
            context: StaticData.navigatorKey.currentContext!);
      }
    } else {
      _notificationNavigationClass.checkUserSessionMethod(
          context: StaticData.navigatorKey.currentContext!);
    }
  }

  //on tap local notification
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
              pushNotificationType: AppString.KILLED_NOTIFICATION);
        } else {
          _notificationNavigationClass.checkUserSessionMethod(
              context: StaticData.navigatorKey.currentContext!);
        }
      } else {
        _notificationNavigationClass.checkUserSessionMethod(
            context: StaticData.navigatorKey.currentContext!);
      }
    } else {
      _notificationNavigationClass.checkUserSessionMethod(
          context: StaticData.navigatorKey.currentContext!);
    }
  }
}

class StaticData {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool notificationForegroundListenerEnable = false;
  static bool notificationBackgroundListenerEnable = false;
}

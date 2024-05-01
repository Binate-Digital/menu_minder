import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/services/network/firebase_messaging_service.dart';
import 'package:menu_minder/services/network/shared_preference.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_navigator.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/network_strings.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/auth/bloc/repository/auth_repo.dart';
import 'package:menu_minder/view/notifications/data/get_notification_model.dart';
import 'package:provider/provider.dart';
import '../repo/implementation/i_core.dart';

class NotificationProvider extends ChangeNotifier {
  final ICoreModule _coreRepo;
  final AuthRepo _authRepo;

  NotificationProvider(this._authRepo, this._coreRepo);

  //------------Notification On/OFF States ---------------//
  States _notificationState = States.init;
  States get notificationState => _notificationState;

  ///--------------DELETE NOTIFICATION STATES--------------\\\\\\\
  States _deleteNotificationState = States.init;
  States get deleteNotificationState => _deleteNotificationState;

  ///------------------Change NotificationStatus----------------\\\
  changeNotificaionsStatus({
    required bool isEnabled,
    required BuildContext context,
  }) async {
    try {
      setProgressBar();
      // _notificationChangeState(States.loading); //--- (STEP 5) ---//
      Response? response = await _authRepo.changeNotificationStatus({});
      if (response?.data['data'] != null) {
        SharedPreference().setUser(user: jsonEncode(response?.data));
      }

      cancelProgressBar();
      context.read<AuthProvider>().setUserWithState(response?.data);

      Utils.showToast(message: response?.data['message'] ?? '');
      // }
    } on DioException catch (_) {
      cancelProgressBar();
    }
  }

  //------------ Load  NOTIFICATIONS States --------\\\\
  States _notificationsState = States.init;
  States get getNotificationsState => _notificationsState;

  initState() {
    _notificationState = States.init;
    _deleteNotificationState = States.init;
  }

  _getNotificationsState(States state) {
    _notificationsState = state;
    notifyListeners();
  }

  GetNotification? _getNotificationData;

  GetNotification? get notificationData => _getNotificationData;

  ///-----------Load All Notifications-------------\\\\\\\
  ///
  /// // NOTIFICATIONS
  getNotifications({
    bool isRfresh = false,
    Function()? onSuccess,
  }) async {
    try {
      if (!isRfresh) {
        _getNotificationsState(States.loading); //--- (STEP 5) ---//
      }
      Response? response = await _coreRepo.loaddAllNotifcations({});

      try {
        _getNotificationData = GetNotification.fromJson(response?.data);
        _getNotificationsState(States.success);
        // refreshController?.refreshCompleted();
      } catch (e) {
        _getNotificationsState(States.failure);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        initState();
      }
    } on DioException catch (_) {
      _getNotificationsState(States.failure);
      initState();
    }
  }

  ///DELETE NOTIFICATIONS
  deleteNotification({required NotificationModel notificationModel}) async {
    try {
      // _deleteNotificationChangeState(States.loading); //--- (STEP 1) ---//
      setProgressBar();
      Response? response =
          await _coreRepo.deleteNotificaion(notificationModel.sId!);

      try {
        _getNotificationData?.data?.remove(notificationModel);
        _deleteNotificationChangeState(States.success);
        cancelProgressBar();
      } catch (e) {
        _deleteNotificationChangeState(States.failure);
        initState();
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar();
      }
    } on DioException catch (e) {
      _deleteNotificationChangeState(States.failure);
      initState();
      AppMessage.showMessage(e.message.toString());
      cancelProgressBar();
    }
  }

  ////-------------CHANGE NOTIFICATION STATUS--------------\\\\\\\
  _deleteNotificationChangeState(States state) {
    _deleteNotificationState = state;
    notifyListeners();
  }

  void setProgressBar() {
    AppDialog.showPorgressBar(StaticData.navigatorKey.currentState!.context);
  }

  void cancelProgressBar() {
    AppNavigator.pop(StaticData.navigatorKey.currentState!.context);
  }
}

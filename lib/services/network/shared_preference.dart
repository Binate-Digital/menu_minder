import 'dart:convert';

import 'package:menu_minder/utils/network_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/strings.dart';
import '../../view/auth/bloc/models/user_model.dart';

class SharedPreference {
  static SharedPreference? _sharedPreferenceHelper;
  static SharedPreferences? _sharedPreferences;

  SharedPreference._createInstance();

  factory SharedPreference() {
    // factory with constructor, return some value
    _sharedPreferenceHelper ??= SharedPreference._createInstance();
    return _sharedPreferenceHelper!;
  }

  Future<SharedPreferences> get sharedPreference async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  ////////////////////// Clear Preference ///////////////////////////
  void clear() {
    _sharedPreferences!.clear();
  }

  ////////////////////// Bearer Token ///////////////////////////

  void setBearerToken({String? token}) {
    _sharedPreferences!.setString(NetworkStrings.BEARER_TOKEN_KEY, token ?? "");
  }

  String? getBearerToken() {
    return _sharedPreferences!.getString(NetworkStrings.BEARER_TOKEN_KEY);
  }

  ////////////////////// User ///////////////////////////
  void setUser({String? user}) {
    _sharedPreferences!
        .setString(NetworkStrings.CURRENT_USER_DATA_KEY, user ?? "");
  }

  String? getUser() {
    return _sharedPreferences!.getString(NetworkStrings.CURRENT_USER_DATA_KEY);
  }

  UserModel? getParcedUser() {
    if (_sharedPreferences?.getString(NetworkStrings.CURRENT_USER_DATA_KEY) ==
        null) {
      return null;
    } else {
      var jsonResponse = jsonDecode((_sharedPreferences!
              .getString(NetworkStrings.CURRENT_USER_DATA_KEY) ??
          ''));
      print(jsonResponse);
      var user = UserModel.fromJson(jsonResponse);
      return user;
    }
  }

  ////////////////////// Notification Message Id ///////////////////////////
  void setNotificationMessageId({String? messageId}) {
    _sharedPreferences!
        .setString(AppString.NOTIFICATION_MESSAGE_ID_KEY, messageId ?? "");
  }

  String? getNotificationMessageId() {
    return _sharedPreferences!.getString(AppString.NOTIFICATION_MESSAGE_ID_KEY);
  }
}

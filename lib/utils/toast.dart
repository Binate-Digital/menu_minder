import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static CustomToast? _customToastHelper;
  static Fluttertoast? _toastObject;

  CustomToast._createInstance();

  factory CustomToast() {
    // factory with constructor, return some value
    _customToastHelper ??= CustomToast._createInstance();
    return _customToastHelper!;
  }

  Future<Fluttertoast> get sharedPreference async {
    _toastObject ??= Fluttertoast();
    return _toastObject!;
  }

  showToast({required String message}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      timeInSecForIosWeb: 1,
    );
  }
}

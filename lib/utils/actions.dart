import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:menu_minder/utils/styles.dart';

import 'app_constants.dart';

class AppMessage {
  static void showMessage(String? message, {Toast length = Toast.LENGTH_LONG}) {
    Fluttertoast.showToast(
      msg: message ?? "",
      toastLength: length,
    );
  }

  static void handleException(dynamic ex) {
    print("new exception: $ex");
    showMessage(ex.toString());
  }
}

class AppNavigator {
  ///-------------------- Anonymous -------------------- ///
  static void push(BuildContext context, Widget widget) {
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => Navigator.push(
            context,
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) {
                  return widget;
                })));
  }

  static checkCurrentRoute(
      {required String routeName, required BuildContext context}) {
    bool isNewRouteSameAsCurrent = false;
    Navigator.popUntil(context, (route) {
      if (route.settings.name == routeName) {
        isNewRouteSameAsCurrent = true;
        // return true;
      }
      return true;
    });

    return isNewRouteSameAsCurrent;
  }

  static void pushReplacement(BuildContext context, Widget widget) {
    Future.delayed(const Duration(milliseconds: 50))
        .then((value) => Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => widget),
            ));
  }

  static void pushAndRemoveUntil(BuildContext context, Widget widget) {
    Future.delayed(const Duration(milliseconds: 50)).then((value) =>
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => widget),
            (Route<dynamic> route) => false));
  }

  static Future<dynamic> pushAndReturn(
      BuildContext context, Widget widget) async {
    var data =
        await Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return widget;
    }));

    return data;
  }

  static Future<dynamic> pushReplacementAndReturn(
      BuildContext context, Widget widget) async {
    var data =
        await Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return widget;
    }));

    return data;
  }

  ///-------------------- Named -------------------- ///
  static void pushNamed(BuildContext context, String route,
      [Object? arguments]) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  static void pushReplacementNamed(BuildContext context, String route,
      [Object? arguments]) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  static void pushNamedAndRemoveUntil(BuildContext context, String route,
      [Object? arguments]) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        route, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  static void popWithData(BuildContext context, dynamic data) {
    Navigator.of(context).maybePop(data);
  }

  static void popUntil(BuildContext context, String route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }

  static Future<void> pop(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 50))
        .then((value) => Navigator.of(context).pop());
  }
}

// class AppNavigator{

//   static void navigateTo(Widget widget,{Transition transition=Transition.native,
//     int duration=AppInteger.STANDARD_DURATION_MILLI}){
//     Get.to(widget,transition: transition,duration: Duration(milliseconds: duration));
//   }

//   static void navigateToReplace(Widget Function() navigate,{Transition transition=Transition.native,
//     int duration=AppInteger.STANDARD_DURATION_MILLI}){
//     Get.off(navigate,transition: transition,duration: Duration(milliseconds: duration));
//   }
//   static void navigateToReplaceAll(Widget Function() navigate,{Transition transition=Transition.native,
//     int duration=AppInteger.STANDARD_DURATION_MILLI}){
//     Get.offAll(navigate,transition: transition,duration: Duration(milliseconds: duration));
//   }

//   static void pop(){
//     Get.back();
//   }

// }

// /*class AppLoader{
//   static void showLoader({Widget loader=const ProcessLoading()}){
//     Get.dialog(loader,barrierDismissible: false,);
//   }

//   static void dismissLoader(){
//     AppNavigator.pop(context);
//   }
// }*/

class AppDialog {
  static Future<T?> showDialogs<T>(
      Widget widget, String heading, BuildContext context,
      {bool disable_back = true,
      bool barrierDismissible = false,
      bool scrollable = true,
      bool backDrop = true,
      double topmargin = 16,
      bool? hasBack = false,
      VoidCallback? onClose}) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,

      barrierColor: backDrop == true
          ? Colors.white.withOpacity(0.95)
          : AppColor.COLOR_TRANSPARENT,
      // transitionDuration: const Duration(milliseconds: AppInteger.STANDARD_DURATION_MILLI),

      builder: (context) {
        return AlertDialog(
          scrollable: scrollable,

          // backgroundColor: AppColor.COLOR_TRANSPARENT,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //useMaterialBorderRadius: true,
          //  title: Center(child: VariableText(text:"Payment",weight: FontWeight.bold,),),
          content: Container(
              padding: const EdgeInsets.all(2),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: AppStyles.dialogLinearGradient(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 60,
                    child: Stack(
                      children: [
                        if (hasBack!)
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () =>
                                    onClose ?? AppNavigator.pop(context),
                                child: const CircleAvatar(
                                  backgroundColor: AppColor.COLOR_RED1,
                                  radius: 10,
                                  child: Icon(Icons.close_rounded,
                                      size: 16, color: AppColor.COLOR_WHITE),
                                )),
                          ),
                        Center(
                          child: Text(
                            heading,
                            style: const TextStyle(
                                color: AppColor.COLOR_WHITE, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget,
                  ),
                ],
              )),
        );
      },
    );

    // Get.dialog(widget)
  }

  static showPorgressBar(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(.5),
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColor.COLOR_WHITE,
              color: AppColor.THEME_COLOR_PRIMARY1,
            ),
          );
        });
  }

  static Future<T?> showPlainDialog<T>(
    Widget widget,
    BuildContext context, {
    bool disable_back = false,
    bool backDrop = true,
  }) {
    return showDialog(
        context: context,
        barrierColor: backDrop
            ? const Color(
                0x88000000,
              )
            : AppColor.COLOR_TRANSPARENT,
        /* transitionDuration:
            const Duration(milliseconds: AppInteger.STANDARD_DURATION_MILLI),
        pageBuilder: (context, anim1, anim2) {
          return Center(
            child: Material(color: AppColor.COLOR_TRANSPARENT, child: widget),
          );
        }, */
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: SizedBox(
                width: MediaQuery.of(context).size.width, child: widget),
          );
        });
    // Get.dialog(widget)
  }

  static Future<T?> showMenu<T>(
    Widget widget,
    BuildContext context, {
    bool backDrop = true,
  }) {
    const double menuHeight = AppDimen.MENU_HEIGHT;
    const double bottomBar = AppDimen.DASHBOARD_NAVIGATION_BAR_HEIGHT;
    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "",
        barrierColor: backDrop
            ? const Color(
                0x88000000,
              )
            : AppColor.COLOR_TRANSPARENT,
        /*   transitionDuration:
            const Duration(milliseconds: AppInteger.STANDARD_DURATION_MILLI),
        pageBuilder: (context, anim1, anim2) {
          return widget;
        }, */
        builder: (context) {
          return Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  alignment: Alignment.bottomRight,
                  height: menuHeight * 2,
                  padding: const EdgeInsets.only(bottom: bottomBar),
                  child: widget));
/*      return ScaleTransition(
        scale: anim1, child: Opacity(
        opacity: anim1.value,
        child: WillPopScope(
          onWillPop: () async {
            return enable_back;
          },
          child: SafeArea(
            child: child,
          ),
        ),
      ),);*/
        });
    // Get.dialog(widget)
  }

  static Future<T?> showBottomPanel<T>(
    BuildContext context,
    Widget widget,
  ) {
    return showModalBottomSheet<T>(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: AppColor.BG_COLOR,
        enableDrag: false,
        isScrollControlled: true,
        builder: (con) {
          return widget;
        });
  }

  static void modalBottomSheet(
          {required BuildContext context,
          required Widget child,
          Color? color,
          bool? hasBackIcon = true,
          bool? isDismissible = true}) =>
      showModalBottomSheet(
        isDismissible: isDismissible!,
        backgroundColor: color ?? Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
        ),
        context: context,
        builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppStyles.height4SizedBox(),
                Center(
                  child: Container(
                    width: 80,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColor.THEME_COLOR_SECONDARY),
                  ),
                ),
                AppStyles.height20SizedBox(),
                child,
                AppStyles.height16SizedBox(),
              ],
            ),
          ),
        ),
        isScrollControlled: true,
      );
  static plainDialog(BuildContext context, Widget widget) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => AppNavigator.pop(context),
                      child: const Icon(
                        Icons.cancel,
                        color: AppColor.COLOR_RED1,
                      ),
                    ),
                  ),
                  AppStyles.height16SizedBox(),
                  widget
                ],
              ),
            ),
          ));
}


/* 
class FormValidator {
  static bool validateCustomForm(
    GlobalKey<CustomFormState> key,
  ) {
    bool value = key.currentState!.validate();
    return value;
  }

  static bool validateForm(
    GlobalKey<FormState> key,
  ) {
    bool value = key.currentState!.validate();
    return value;
  }

  static String? validateEmail(
    String value,
  ) {
    if (value.length > 35) {
      return AppString.TEXT_EMAIL_TOO_LONG_ERROR;
    }
    if (value.isEmpty) {
      return AppString.TEXT_EMAIL_EMPTY_ERROR;
    } else if (!RegExp(ValidationRegex.EMAIL_VALIDATION).hasMatch(value)) {
      return AppString.TEXT_EMAIL_INVALID_ERROR;
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.length > 30) {
      return AppString.TEXT_PASSWORD_TOO_LONG_ERROR;
    }
    if (value.isEmpty) {
      return AppString.TEXT_PASSWORD_EMPTY_ERROR;
    } else if (!RegExp(ValidationRegex.PASSWORD_VALIDATE).hasMatch(value)) {
      return AppString.TEXT_PASSWORD_INVALID_ERROR;
    }
    return null;
  }

  static String? validatePhone(String value) {
    if (value.isEmpty) {
      return AppString.TEXT_PHONE_EMPTY_ERROR;
    } else if (!RegExp(ValidationRegex.PHONE_VALIDATE).hasMatch(value)) {
      return AppString.TEXT_PHONE_INVALID_ERROR;
    }
    return null;
  }

  static String? validateEmpty(String value,
      {String message = AppString.TEXT_FIELD_EMPTY_ERROR}) {
    if (value.isEmpty) {
      return message;
    }
    if (value.length > 30) {
      return AppString.TEXT_FIELD_TOO_LONG_ERROR;
    }
    return null;
  }

  static String? validateOther(String text,
      {List<bool> conditions = const [], List<String> messages = const []}) {
    for (int i = 0; i < conditions.length; i++) {
      if (!conditions[i]) {
        return messages[i];
      }
    }
    return null;
  }

  static String? validateConfirmPassword(String value, String pass) {
    if (value.isEmpty) {
      return AppString.TEXT_CONFIRM_PASSWORD_EMPTY_ERROR;
    }
    if (value != pass) {
      return AppString.CONFIRM_PASSWORD_ERROR;
    }
    return null;
  }
}

class AppUrlLauncher {
  static void launchUrl(String ur) async {
    print("url to launch: $ur");
    final Uri uri = Uri.parse(ur);
    if (await url.canLaunchUrl(uri)) {
      // url.launchUrl(Uri.parse(ur,),mode: url.LaunchMode.externalNonBrowserApplication);
      url.launchUrl(
          Uri.parse(
            ur,
          ),
          mode: url.LaunchMode.externalApplication);
      //  url.launch(ur,forceWebView: false);
    } else {
      AppMessage.showMessage("Unable to show");
    }
  }
}

class NumberFormatter {
  static String decimalPlace(num currency, {int digits = 2}) {
    return currency.toStringAsFixed(digits);
  }
}
 */
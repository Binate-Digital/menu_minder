import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:menu_minder/utils/toast.dart';

// import '../core/network/shared_preference.dart';
import 'app_constants.dart';

class Utils {
  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  ///-------------------- Toast -------------------- ///
  static void showToast({String? message}) {
    CustomToast().showToast(
      message: message!,
    );
  }

  ///-------------------- Show Dialog -------------------- ///
  static void showDialogs(
      {BuildContext? context,
      Widget? widget,
      EdgeInsets? insetPadding,
      bool barrierDismissible = true}) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context!,
      builder: (BuildContext buildContext) => Dialog(
        elevation: 0.0,
        insetPadding:
            insetPadding ?? const EdgeInsets.symmetric(horizontal: 4.0),
        backgroundColor: AppColor.TRANSPARENT_COLOR,
        child: widget,
      ),
    );
  }

  ///-------------------- Image Picker Bottom Sheet (Image Picker and Cropper) -------------------- ///
  // static void showImageSourceSheet({
  //   BuildContext? context,
  //   Function(File)? setFile,
  // }) {
  //   showModalBottomSheet(
  //     context: context!,
  //     builder: (BuildContext context) {
  //       return ImagePickerBottomSheet(setFile: setFile);
  //     },
  //   );
  // }
  static void progressAlertDialog({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColor.THEME_COLOR_SECONDARY,
              ),
            ),
          );
        });
  }

  static String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  static String convertDateWithSlashes(DateTime dateTime) {
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    return formattedDate;
  }

  static Future<String> getAddressFromLatLng(
      double latitude, double longitude) async {
    /*  try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
        return address;
      }
    } catch (e) {
      print('Error: $e');
    } */
    return 'Address not found';
  }

  static String convertTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSS');
    final DateFormat serverFormater = DateFormat('HH:mm:ss');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  ///-------------------- Show Date Picker -------------------- ///
  static Future<DateTime?> displayDatePicker({
    DateTime? date,
    DateTime? lastDate,
    DateTime? firstDate,
    BuildContext? context,
  }) async {
    try {
      date = await showDatePicker(
            context: context!,
            initialDate: date ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(1900, 01, 01),
            lastDate: lastDate ?? DateTime(3000, 01, 01),
          ) ??
          (lastDate == null ? date : null);
    } catch (e) {
      print(e.toString());
    }
    return date;
  }

  ///-------------------- Show Time Picker -------------------- ///
  static Future<TimeOfDay?> displayTimePicker({
    TimeOfDay? time,
    BuildContext? context,
  }) async {
    try {
      time = await showTimePicker(
        initialTime: time ?? TimeOfDay.now(),
        context: context!,
      );
    } catch (e) {
      print(e.toString());
    }
    return time;
  }

  static Future openImagePicker(
      {ImageSource? source,
      BuildContext? context,
      Function(File)? setFile}) async {
    FocusScope.of(context!).unfocus();
    // Pop : To close Image Selection Dialog
    // Get.back();
    try {
      // XFile? image =
      //     await ImagePicker().pickImage(source: source!, imageQuality: 50);
      // if (image != null) {
      //   cropImage(image: image, setFile: setFile!, context: context);
      // }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future pickImage(
      {ImageSource? source,
      BuildContext? context,
      Function(File)? setFile}) async {
    FocusScope.of(context!).unfocus();
    // Pop : To close Image Selection Dialog
    // Get.back();
    try {
      XFile? image =
          await ImagePicker().pickImage(source: source!, imageQuality: 50);
      if (image != null) {
        setFile?.call(File(image.path));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static void cropImage(
      {XFile? images, Function(File)? setFile, BuildContext? context}) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: images!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Image",
            toolbarColor: AppColor.THEME_COLOR_PRIMARY1,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      File image = File(croppedFile!.path);
      setFile!(image);
    } catch (e) {
      print(e.toString());
    }
  }

  ///-------------------- Format Date -------------------- ///
  static String formatDate({String? pattern, DateTime? date}) {
    DateFormat dateFormat = DateFormat(pattern);
    return dateFormat.format(date ?? DateTime.now());
  }

  ///-------------------- Parse Date -------------------- ///
  static DateTime? parseDate({String? pattern, String? date, bool? isUtc}) {
    DateFormat dateFormat = DateFormat(pattern);
    if (date != null && date != "") {
      return dateFormat.parse(date, isUtc ?? false);
    }
    return null;
  }

  ///-------------------- Clear Preferences -------------------- ///
  static void clearPreferences() {
    // SharedPreference().clear();
  }

  ///-------------------- Image Picker Bottom Sheet (Image Picker and Cropper) -------------------- ///
  // static void showImageSourceSheet({
  //   BuildContext? context,
  //   Function(File)? setFile,
  // }) {
  //   showModalBottomSheet(
  //     context: context!,
  //     builder: (BuildContext context) {
  //       return ImagePickerBottomSheet(setFile: setFile);
  //     },
  //   );
  // }
//////////////////////////Mask Formatters///////////////////////////////
  static Future<TimeOfDay?> timePicker(
          {required BuildContext context, TimeOfDay? initialTime}) =>
      showTimePicker(
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColor.THEME_COLOR_PRIMARY1,
                  onSurface: AppColor.THEME_COLOR_PRIMARY1,
                ),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!,
              ),
            );
          },
          initialEntryMode: TimePickerEntryMode.dialOnly,
          
          context: context,
          initialTime: initialTime ?? TimeOfDay.now());
  var maskFormatter = MaskTextInputFormatter(
      mask: '+1(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/bottom_bar.dart';

import 'actions.dart';
import 'asset_paths.dart';

class AppStyles {
  static Widget appBarTitle(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColor.THEME_COLOR_PRIMARY1),
      );
  static appBar(String text, VoidCallback onleadingTap,
          {double? textSize, List<Widget>? action}) =>
      AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        leading: IconButton(
            onPressed: onleadingTap,
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.COLOR_WHITE,
            )),
        title: Text(
          text,
          style: TextStyle(
              color: AppColor.COLOR_WHITE,
              fontWeight: FontWeight.bold,
              fontSize: textSize ?? 17),
        ),
        centerTitle: true,
        actions: action,
      );
  static pinkAppBar(BuildContext context, String text,
          {VoidCallback? onleadingTap,
          Widget? trailing,
          Widget? leading,
          bool isRegistration = false,
          bool isFromCreateProfile = false,
          bool? hasBack = true,
          bool? isRounded = true}) =>
      PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: AppBar(
              systemOverlayStyle: isRegistration
                  ? null
                  : SystemUiOverlayStyle.light
                      .copyWith(statusBarColor: AppColor.THEME_COLOR_PRIMARY1),
              backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
              elevation: 0,
              centerTitle: true,
              toolbarHeight: kToolbarHeight + 30,
              title: Text(
                text,
                style:
                    const TextStyle(color: AppColor.COLOR_WHITE, fontSize: 18),
              ),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isRounded! ? 50 : 0),
                      bottomRight: Radius.circular(isRounded ? 50 : 0))),
              leading: hasBack!
                  ? InkWell(
                      onTap: onleadingTap ??
                          () {
                            isFromCreateProfile
                                ? AppNavigator.pushAndRemoveUntil(
                                    context, const BottomBar())
                                : AppNavigator.pop(context);
                          },
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColor.COLOR_WHITE,
                      ),
                    )
                  : leading ??
                      InkWell(
                        onTap: onleadingTap,
                        child: Image.asset(
                          AssetPath.MENU,
                          scale: 4,
                        ),
                      ),
              actions: trailing != null ? [trailing] : []));

  static Widget headingStyle(String text,
          {double? fontSize,
          FontWeight? fontWeight,
          Color? color,
          int? lines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      Text(
        text,
        style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w500,
            // height: lines ?? null,
            color: color ?? Colors.black,
            overflow: overflow),
        textAlign: textAlign,
      );

  static Widget subHeadingStyle(String text,
          {double? fontSize, FontWeight? fontWeight, Color? color}) =>
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color ?? Colors.black,
        ),
      );
  static Widget contentStyle(String text,
          {double? fontSize,
          FontWeight? fontWeight,
          Color? color,
          double? height,
          TextAlign? textAlign,
          int? maxLines,
          TextDecoration? textDecoration}) =>
      Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: fontSize ?? 12,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color ?? Colors.black,
            height: height ?? 0,
            decoration: textDecoration),
        maxLines: maxLines,
      );
  static SizedBox height4SizedBox({double? width, double? height}) => SizedBox(
        height: height ?? 4,
        width: width,
      );
  static SizedBox height8SizedBox({double? width, double? height}) => SizedBox(
        height: height ?? 8,
        width: width,
      );
  static SizedBox height12SizedBox({double? width, double? height}) => SizedBox(
        height: height ?? 12,
        width: width,
      );
  static SizedBox height16SizedBox({double? width, double? height}) => SizedBox(
        height: height ?? 16,
        width: width,
      );
  static SizedBox height18SizedBox({double? width, double? height}) => SizedBox(
        height: height ?? 18,
        width: width,
      );
  static SizedBox height20SizedBox({double? width, double? height}) => SizedBox(
        height: height ?? 20,
        width: width,
      );
  static VerticalDivider verticalDivider() {
    return VerticalDivider(
      color: Colors.grey.shade300,
      thickness: 1.2,
    );
  }

  static Divider horizontalDivider({Color? color}) {
    return Divider(
      color: color ?? Colors.grey.shade300,
      thickness: 1.2,
    );
  }

  static BoxDecoration countryPickerDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black, width: .5));

  static dialogLinearGradient() => const BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(8), topLeft: Radius.circular(8)),
      gradient: LinearGradient(colors: [
        AppColor.THEME_COLOR_SECONDARY,
        AppColor.COLOR_BLACK,
      ], begin: Alignment.topCenter, end: AlignmentDirectional.bottomCenter));
  static screenPadding() => const EdgeInsets.only(
      left: AppDimen.SCREEN_PADDING,
      right: AppDimen.SCREEN_PADDING,
      top: AppDimen.SCREEN_PADDING);
}

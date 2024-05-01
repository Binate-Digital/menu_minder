import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_minder/common/customize_international_country_code_picker/custom_phonenumber.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/strings.dart';

import '../../../common/customize_international_country_code_picker/custom_countries.dart';
import '../../../common/customize_international_country_code_picker/custom_intl_phone_field.dart';

class PhoneNumberTextField extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? curserColor;
  String? hintText, error_message;
  String? initialValue;
  String? label;
  String? initialCountryCode;
  final ValueChanged<PhoneNumber>? onChanged;
  Function(Country)? onCountryChanged;
  final bool? isBorder;
  final bool isReadOnly;
  final bool is_clickable;
  final Color? errorTextColor;
  final TextEditingController? controller;
  final Future<String?> Function(PhoneNumber?)? validator;
  final FocusNode _focusNode = FocusNode();

  bool hasInnerShadow;
  PhoneNumberTextField(
      {Key? key,
      this.controller,
      this.validator,
      this.backgroundColor,
      this.borderColor,
      this.hasInnerShadow = false,
      this.isBorder,
      this.initialCountryCode,
      this.hintText,
      this.initialValue,
      this.onCountryChanged,
      this.errorTextColor,
      this.curserColor,
      this.error_message,
      this.label,
      this.isReadOnly = false,
      this.is_clickable = true,
      this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
        cursorColor: curserColor,
        enabled: is_clickable,
        initialCountryCode: initialCountryCode,
        showCursor: is_clickable,
        readOnly: isReadOnly,
        initialValue: initialValue,
        showDropdownIcon: true,
        dropdownIconPosition: IconPosition.trailing,
        invalidNumberMessage: 'Invalid Phone Number',
        validator: validator,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        // autovalidateMode: AutovalidateMode.disabled
        // ,
        controller: controller,
        dropdownTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        dropdownDecoration: BoxDecoration(
            color: backgroundColor ?? AppColor.COLOR_WHITE,
            borderRadius: BorderRadius.circular(8)),
        decoration: InputDecoration(
          filled: true,
          fillColor: backgroundColor ?? AppColor.COLOR_WHITE,
          // contentPadding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
          //  filled: true,
          //  fillColor: Colors.white,
          // prefixIcon: const Icon(
          //   CupertinoIcons.phone_fill,
          //   color: AppColors.RED_COLOR_1,
          // ),

          // prefixIconConstraints: BoxConstraints(minHeight: 80, minWidth: 50),
          hintText: AppString.TEXT_PHONE_NUMBER,
          counter: const SizedBox.shrink(),
          // hintStyle:
          //     TextStyle(color: AppColors.TRANSPARENT_COLOR, fontSize: 14.sp),
          // label: Text(label!),
          // labelStyle: TextStyle(
          //     color: AppColors.BLUE_COLOR,
          //     fontSize: 14.sp,
          //     fontWeight: FontWeight.w500),
          errorMaxLines: 3,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,

          // enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(8),
          //     borderSide: BorderSide(width: 1, color: AppColors.WHITE_COLOR)),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(8),
          //     borderSide: BorderSide(color: AppColors.WHITE_COLOR)),
          // errorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(8),
          //     borderSide: BorderSide(color: AppColors.WHITE_COLOR)),
          // focusedErrorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(8),
          //     borderSide: const BorderSide(color: AppColors.RED_COLOR)),
          errorStyle: const TextStyle(
            color: Colors.red,
            height: 1,
          ),
        ),
        onChanged: onChanged,
        onCountryChanged: onCountryChanged);
  }
}

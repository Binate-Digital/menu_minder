// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_constants.dart';
import '../utils/asset_paths.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String? value)? onChanged;
  final bool? hasPrefix;
  final String? prefixIconPath;
  final int? maxLines;
  final Color? borderColor;
  final bool? hasTrailingWidget;
  final bool enabled;
  final String? trailingWidget;
  final Widget? trailingWidgetList;
  final bool? hasOutlined;
  final double? borderWidth;
  final double? horizontalPadding;
  final double? prefixHorizontalPadding;
  final double? verticalPadding;
  final String? Function(String? val)? validator;
  final TextInputType? inputType;
  final VoidCallback? onTap;
  final Function(String? value)? onEditingComplete;
  final bool? isReadOnly;
  List<TextInputFormatter>? inputFormatters;
  final BorderSide? borderSide;
  final TextInputAction? textInputAction;
  final Color? prefixColor;
  final Color? dividerColor;
  final double? height;
  final FocusNode? focusNode;
  final Color? errorColor;
  EdgeInsetsGeometry? contentPadding;
  Color? hintColor;
  Color? fillColor;
  double? fontSize;
  VoidCallback? onTrailingTap;
  PrimaryTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.fontSize,
    this.onChanged,
    this.textInputAction,
    this.hasPrefix = false,
    this.prefixIconPath,
    this.maxLines = 1,
    this.contentPadding,
    this.borderColor,
    this.hasTrailingWidget = false,
    this.trailingWidget,
    this.hasOutlined = false,
    this.enabled = true,
    this.borderWidth,
    this.horizontalPadding,
    this.prefixHorizontalPadding = 0.0,
    this.verticalPadding,
    this.validator,
    this.inputType,
    this.onTap,
    this.onEditingComplete,
    this.isReadOnly = false,
    this.inputFormatters,
    this.borderSide,
    this.prefixColor,
    this.dividerColor = AppColor.COLOR_BLACK,
    this.height,
    this.focusNode,
    this.errorColor,
    this.hintColor,
    this.fillColor,
    this.onTrailingTap,
    this.trailingWidgetList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: TextStyle(fontSize: fontSize),
          maxLines: maxLines ?? 1,
          enabled: enabled,
          validator: validator,
          textInputAction: textInputAction,
          keyboardType: inputType,
          readOnly: isReadOnly ?? false,
          onTap: onTap,
          onFieldSubmitted: onEditingComplete,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              hintText: hintText,
              errorStyle: TextStyle(
                color: errorColor ?? AppColor.COLOR_RED1,
              ),
              hintStyle: TextStyle(
                color: hintColor ?? AppColor.COLOR_BLACK,
                fontSize: fontSize ?? 14,
              ),
              fillColor: fillColor ?? Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: borderSide ??
                    BorderSide(color: borderColor ?? Colors.black, width: .5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: borderSide ??
                    BorderSide(color: borderColor ?? Colors.black, width: .5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: borderSide ??
                    BorderSide(color: borderColor ?? Colors.black, width: .5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: borderSide ??
                    BorderSide(color: borderColor ?? Colors.black, width: .5),
              ),
              contentPadding: contentPadding ??
                  EdgeInsets.symmetric(
                          horizontal: horizontalPadding ?? 16,
                          vertical: verticalPadding ?? 20)
                      .copyWith(),
              border: InputBorder.none,
              suffixIcon: hasTrailingWidget!
                  ? trailingWidgetList != null
                      ? trailingWidgetList as Widget
                      : InkWell(
                          onTap: onTrailingTap,
                          child: Image.asset(
                            trailingWidget!,
                            scale: 4,
                          ),
                        )
                  : const SizedBox.shrink(),
              prefixIcon: hasPrefix!
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        Image.asset(
                          prefixIconPath ?? AssetPath.EMAIL,
                          scale: 3.5,
                          color: prefixColor ?? AppColor.COLOR_BLACK,
                        ),
                      ],
                    )
                  : null),
        )),
      ],
    );
  }
}

class TextFieldItem extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String? value)? onChanged;
  final bool? hasPrefix;
  final String? prefixIconPath;
  final int? maxLines;
  final Color? borderColor;
  final bool? hasTrailingWidget;
  final bool enabled;
  final String? trailingWidget;
  final Widget? trailingWidgetList;
  final bool? hasOutlined;
  final double? borderWidth;
  final double? horizontalPadding;
  final double? prefixHorizontalPadding;
  final double? verticalPadding;
  final String? Function(String? val)? validator;
  final TextInputType? inputType;
  final VoidCallback? onTap;
  final Function(String? value)? onEditingComplete;
  final bool? isReadOnly;
  List<TextInputFormatter>? inputFormatters;
  final BorderSide? borderSide;
  final TextInputAction? textInputAction;
  final Color? prefixColor;
  final Color? dividerColor;
  final double? height;
  final FocusNode? focusNode;
  final Color? errorColor;
  EdgeInsetsGeometry? contentPadding;
  Color? hintColor;
  Color? fillColor;
  double? fontSize;
  VoidCallback? onTrailingTap;
  TextFieldItem({
    Key? key,
    required this.hintText,
    required this.controller,
    this.fontSize,
    this.onChanged,
    this.textInputAction,
    this.hasPrefix = false,
    this.prefixIconPath,
    this.maxLines = 1,
    this.contentPadding,
    this.borderColor,
    this.hasTrailingWidget = false,
    this.trailingWidget,
    this.hasOutlined = false,
    this.enabled = true,
    this.borderWidth,
    this.horizontalPadding,
    this.prefixHorizontalPadding = 0.0,
    this.verticalPadding,
    this.validator,
    this.inputType,
    this.onTap,
    this.onEditingComplete,
    this.isReadOnly = false,
    this.inputFormatters,
    this.borderSide,
    this.prefixColor,
    this.dividerColor = AppColor.COLOR_BLACK,
    this.height,
    this.focusNode,
    this.errorColor,
    this.hintColor,
    this.fillColor,
    this.onTrailingTap,
    this.trailingWidgetList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: fontSize,
      ),
      maxLines: maxLines ?? 1,
      enabled: enabled,
      validator: validator,
      textInputAction: textInputAction,
      keyboardType: inputType,
      readOnly: isReadOnly ?? false,
      onTap: onTap,
      onFieldSubmitted: onEditingComplete,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          hintText: hintText,
          errorStyle: TextStyle(
            color: errorColor ?? AppColor.COLOR_RED1,
          ),
          hintStyle: TextStyle(
            color: hintColor ?? AppColor.COLOR_BLACK,
            fontSize: fontSize ?? 14,
          ),
          fillColor: fillColor ?? Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: borderSide ??
                BorderSide(color: borderColor ?? Colors.black, width: .5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: borderSide ??
                BorderSide(color: borderColor ?? Colors.black, width: .5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: borderSide ??
                BorderSide(color: borderColor ?? Colors.black, width: .5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: borderSide ??
                BorderSide(color: borderColor ?? Colors.black, width: .5),
          ),
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                      horizontal: horizontalPadding ?? 16,
                      vertical: verticalPadding ?? 20)
                  .copyWith(),
          border: InputBorder.none,
          prefixIcon: hasPrefix!
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Image.asset(
                      prefixIconPath ?? AssetPath.EMAIL,
                      scale: 3.5,
                      color: prefixColor ?? AppColor.COLOR_BLACK,
                    ),
                  ],
                )
              : null),
    );
  }
}

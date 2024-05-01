// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_constants.dart';
import '../utils/styles.dart';
import 'primary_textfield.dart';

class HeadingTextField extends StatelessWidget {
  final String heading;
  final TextEditingController controller;
  List<TextInputFormatter>? inputFormat;
  TextInputType? textInputType;
  bool? isRead;
  final FocusNode? focusNode;
  VoidCallback? onTap;
  String Function(String? value)? onChange;
  Function(String? value)? onEditingCompleted;
  final String? Function(String? val)? validator;
  Color? headingColor;
  Color? borderColor;
  Color? bgColor;

  HeadingTextField({
    Key? key,
    required this.heading,
    required this.controller,
    this.inputFormat,
    this.textInputType,
    this.isRead,
    this.onTap,
    this.onChange,
    this.onEditingCompleted,
    this.headingColor,
    this.borderColor,
    this.bgColor,
    this.validator,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
              color: headingColor ?? AppColor.COLOR_WHITE, fontSize: 15),
        ),
        AppStyles.height8SizedBox(),
        PrimaryTextField(
          hintText: "",
          controller: controller,
          inputFormatters: inputFormat,
          inputType: textInputType,
          isReadOnly: isRead,
          onTap: onTap,
          onChanged: onChange,
          fillColor: bgColor,
          focusNode: focusNode,
          borderColor: borderColor,
          onEditingComplete: onEditingCompleted,
          validator: validator,
        ),
      ],
    );
  }
}

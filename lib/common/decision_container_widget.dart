// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class DecisionContainer extends StatelessWidget {
  final Widget child;
  EdgeInsets? customPadding;
  Color? containerColor;
  Function()? onTap;
  Color? bgColor;
  DecisionContainer({
    Key? key,
    required this.child,
    this.customPadding,
    this.containerColor,
    this.bgColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
              color: bgColor ?? Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: containerColor ??
                      AppColor.THEME_COLOR_SECONDARY.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]),
          padding: customPadding ?? const EdgeInsets.all(24),
          child: child),
    );
  }
}

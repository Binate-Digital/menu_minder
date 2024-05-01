import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final String? imagePath;
  final VoidCallback onTap;
  final double? buttonTextSize;
  final bool? isPadded;
  final double? radius;
  final double? height;
  final FontWeight? fontWeight;
  final bool? hasShadow;
  final Color? shadowColor;
  final Color? iconColor;
  final EdgeInsets? textPadding;

  const PrimaryButton(
      {Key? key,
      required this.text,
      this.buttonColor = AppColor.THEME_COLOR_PRIMARY1,
      this.textColor = AppColor.COLOR_WHITE,
      this.imagePath,
      required this.onTap,
      this.isPadded = true,
      this.buttonTextSize,
      this.radius,
      this.height = 50.0,
      this.fontWeight = FontWeight.w400,
      this.hasShadow = false,
      this.shadowColor = Colors.grey,
      this.iconColor,
      this.textPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        // width: MediaQuery.of(context).size.width * 0.85,
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: buttonColor ?? AppColor.THEME_COLOR_PRIMARY1,
            borderRadius: BorderRadius.circular(radius ?? 10),
            boxShadow: hasShadow!
                ? [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        color: shadowColor!.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 2)
                  ]
                : null),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            imagePath != null
                ? Row(
                    children: [
                      Image.asset(
                        imagePath!,
                        scale: 4,
                        color: iconColor,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            Flexible(
              child: Padding(
                padding: textPadding ?? const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: buttonTextSize ?? 14,
                    color: textColor ?? AppColor.COLOR_WHITE,
                    fontWeight: fontWeight,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

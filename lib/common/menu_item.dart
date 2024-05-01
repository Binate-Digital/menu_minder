import 'package:flutter/material.dart';
import 'package:menu_minder/utils/app_constants.dart';

import 'custom_text.dart';

class ReuabledrawerItems extends StatelessWidget {
  String? title, imgs;
  IconData? icons;
  VoidCallback? onpress;
  Color? textColor;
  Color? iconColor;
  bool? imagewant;
  FontWeight? fontWeight;

  ReuabledrawerItems(
      {super.key,
      this.title,
      this.icons,
      this.textColor,
      this.iconColor,
      this.onpress,
      this.imagewant = false,
      this.fontWeight = FontWeight.normal,
      this.imgs});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Row(
          children: <Widget>[
            imagewant == false
                ? Icon(icons, color: Colors.white, size: 25.0)
                : Image(
                    image: AssetImage(imgs.toString()),
                    height: 22,
                    width: 22,
                    color: iconColor ?? AppColor.COLOR_WHITE,
                  ),
            const SizedBox(
              width: 10,
            ),
            CustomText(
              text: "$title",
              fontColor: textColor ?? AppColor.COLOR_WHITE,
              fontSize: 15,
              // fontFamily: AppFonts.openSansMedium,
              weight: fontWeight ?? FontWeight.w600,
            )
          ],
        ),
      ),
    );
  }
}

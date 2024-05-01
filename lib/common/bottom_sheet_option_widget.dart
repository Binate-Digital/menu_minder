import 'package:flutter/material.dart';
import 'package:menu_minder/utils/app_constants.dart';

import '../utils/styles.dart';

class BottomSheetOptions extends StatelessWidget {
  bool? topDivider;
  bool? bottomDivider;
  final String heading;
  final String imagePath;
  final VoidCallback onTap;

  BottomSheetOptions({
    Key? key,
    this.topDivider = false,
    this.bottomDivider = true,
    required this.heading,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (topDivider!) AppStyles.horizontalDivider(),
          Row(
            children: [
              Image.asset(
                imagePath,
                scale: 4,
                width: 20,
                color: AppColor.THEME_COLOR_PRIMARY1,
              ),
              const SizedBox(
                width: 10,
              ),
              AppStyles.contentStyle(heading,
                  fontSize: 15, fontWeight: FontWeight.w400)
            ],
          ),
          if (bottomDivider!) AppStyles.horizontalDivider(),
        ],
      ),
    );
  }
}

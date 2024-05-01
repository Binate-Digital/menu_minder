import 'package:flutter/material.dart';
import 'package:menu_minder/utils/asset_paths.dart';

import '../../../utils/app_constants.dart';

class MealTypeWidget extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const MealTypeWidget({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.CONTAINER_GREY),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(color: Colors.black)),
            Image.asset(
              AssetPath.ARROW_FORWARD,
              color: AppColor.THEME_COLOR_PRIMARY1,
              scale: 4,
            )
          ],
        ),
      ),
    );
  }
}

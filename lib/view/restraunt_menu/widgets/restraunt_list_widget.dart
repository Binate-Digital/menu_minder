import 'package:flutter/material.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/dummy.dart';
import '../../../utils/styles.dart';

class RestrauntListWidget extends StatelessWidget {
  final int index;
  const RestrauntListWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(1, 1))
            ]),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
              radius: 30,
              child: Image.asset(
                index % 2 == 0 ? AssetPath.FOOD_ICON1 : AssetPath.FOOD_ICON2,
                scale: 4,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppStyles.subHeadingStyle("Lorem Ipsum"),
                      AppStyles.subHeadingStyle("\$10.00",
                          color: AppColor.THEME_COLOR_PRIMARY1)
                    ],
                  ),
                  AppStyles.height16SizedBox(),
                  AppStyles.contentStyle(LOREMSMALL)
                ],
              ),
            )
          ],
        ));
  }
}

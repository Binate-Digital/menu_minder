import 'package:flutter/material.dart';

import '../utils/app_constants.dart';
import '../utils/styles.dart';

class CustomProgressBarWidget extends StatelessWidget {
  final String heading;

  final double percentage;
  const CustomProgressBarWidget({
    super.key,
    required this.heading,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              heading,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "${(percentage).toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        AppStyles.height8SizedBox(),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 2,
                offset: const Offset(1, 2),
                blurRadius: 10)
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: percentage,
              color: AppColor.THEME_COLOR_SECONDARY,
              minHeight: 10,
              backgroundColor: Colors.grey.shade50,
            ),
          ),
        )
      ],
    );
  }
}

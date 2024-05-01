import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class AboveHeadingLinearWidget extends StatelessWidget {
  final String heading;
  final double percentage;
  const AboveHeadingLinearWidget({
    super.key,
    required this.heading,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 1,
                offset: const Offset(1, 4),
                blurRadius: 6)
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 50,
              color: AppColor.THEME_COLOR_SECONDARY,
              backgroundColor: Colors.grey.shade50,
              value: percentage,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                heading,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                "${(percentage).toInt()}%",
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
        )
      ],
    );
  }
}

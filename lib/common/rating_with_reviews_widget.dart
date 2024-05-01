import 'package:flutter/material.dart';
import 'package:menu_minder/common/rating_widget.dart';

import '../utils/styles.dart';

class RatingWithReviewsWidget extends StatelessWidget {
  final double? rating;
  final String? endText;
  final bool? isIgnoreGesture;
  const RatingWithReviewsWidget({
    super.key,
    this.rating,
    this.endText,
    this.isIgnoreGesture,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingWidget(
          isIgnoreGesture: isIgnoreGesture ?? false,
          initialRating: 3,
        ),
        const SizedBox(
          width: 4,
        ),
        AppStyles.contentStyle(
          "${rating!.toInt()}${endText ?? ""}",
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }
}

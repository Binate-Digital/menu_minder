import 'package:flutter/material.dart';
import 'package:menu_minder/utils/config.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/restraunt_info/data/single_place_detail.dart';

import '../../../common/dotted_image.dart';
import '../../../common/rating_widget.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dummy.dart';
import '../../../utils/styles.dart';

class ReviewWidget extends StatelessWidget {
  final bool? hasMore;
  final VoidCallback? onMoreTap;
  const ReviewWidget({
    super.key,
    this.hasMore = false,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AppStyles.horizontalDivider(),
        ),
        Row(
          children: [
            DottedImage(),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStyles.subHeadingStyle("David"),
                Row(
                  children: [
                    const RatingWidget(
                      initialRating: 4.5,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    AppStyles.contentStyle("4.5")
                  ],
                )
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasMore!)
                  InkWell(onTap: onMoreTap, child: const Icon(Icons.more_vert)),
                AppStyles.contentStyle("1 Min Ago",
                    color: AppColor.COLOR_GREY1),
              ],
            ),
          ],
        ),
        AppStyles.height8SizedBox(),
        AppStyles.contentStyle(longText, color: AppColor.COLOR_GREY1)
      ],
    );
  }
}

class ReviewsWidget extends StatelessWidget {
  final bool? hasMore;
  final VoidCallback? onMoreTap;
  final Reviews reviews;
  const ReviewsWidget({
    super.key,
    this.hasMore = false,
    required this.reviews,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(reviews.time! * 1000);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AppStyles.horizontalDivider(),
        ),
        Row(
          children: [
            DottedImage(
              fullUrl: reviews.profilePhotoUrl,
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStyles.subHeadingStyle(reviews.authorName ?? ''),
                Row(
                  children: [
                    RatingWidget(
                      initialRating: reviews.rating,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    AppStyles.contentStyle(reviews.rating.toString())
                  ],
                )
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasMore!)
                  InkWell(onTap: onMoreTap, child: const Icon(Icons.more_vert)),
                AppStyles.contentStyle(
                    Utils.formatDate(
                        pattern: AppConfig.DATE_FORMAT, date: time),
                    color: AppColor.COLOR_GREY1),
              ],
            ),
          ],
        ),
        AppStyles.height8SizedBox(),
        Align(
          alignment: Alignment.topLeft,
          child: AppStyles.contentStyle(
            reviews.text ?? '',
            color: AppColor.COLOR_GREY1,
          ),
        )
      ],
    );
  }
}

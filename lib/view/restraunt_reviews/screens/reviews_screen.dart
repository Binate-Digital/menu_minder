import 'package:flutter/material.dart';
import 'package:menu_minder/common/bottom_sheet_option_widget.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/rating_widget.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_validator.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/restraunt_info/data/single_place_detail.dart';

import '../../../common/primary_textfield.dart';
import '../../../utils/app_constants.dart';
import '../../restraunt_info/widgets/review_widget.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.place});
  final SinglePlaceDetail place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
      //   child: PrimaryButton(
      //       text: "Write a Review", onTap: () => reviewDialog(context, true)),
      // ),
      appBar: AppStyles.pinkAppBar(context, "Rating & Reviews"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppStyles.headingStyle("Overall Rating"),
              AppStyles.height8SizedBox(),
              AppStyles.headingStyle(place.result!.rating.toString(),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFCE6A36)),
              AppStyles.height8SizedBox(),
              const RatingWidget(
                itemSize: 30,
                isIgnoreGesture: true,
                initialRating: 4.5,
              ),
              AppStyles.height8SizedBox(),
              AppStyles.headingStyle(
                  "Based on ${place.result?.userRatingsTotal} Reviews"),
              AppStyles.height8SizedBox(),
              Flexible(
                child: ListView.builder(
                  itemCount: place.result?.reviews?.length ?? 0,
                  itemBuilder: (context, index) => ReviewsWidget(
                    hasMore: false,
                    onMoreTap: () {
                      AppDialog.modalBottomSheet(
                          context: context,
                          child: Column(
                            children: [
                              BottomSheetOptions(
                                  heading: "Edit Review",
                                  imagePath: AssetPath.EDIT,
                                  onTap: () {
                                    AppNavigator.pop(context);
                                    Future.delayed(
                                            const Duration(milliseconds: 200))
                                        .then((value) =>
                                            reviewDialog(context, false));
                                  }),
                              BottomSheetOptions(
                                  heading: "Delete Review",
                                  imagePath: AssetPath.DELETE,
                                  bottomDivider: false,
                                  onTap: () {
                                    AppNavigator.pop(context);
                                    Future.delayed(
                                            const Duration(milliseconds: 300))
                                        .then((value) => AppDialog.showDialogs(
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 48.0,
                                                      vertical: 12),
                                                  child: AppStyles.headingStyle(
                                                      "Are you sure you want to delete this review?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: PrimaryButton(
                                                            text: "Cancel",
                                                            buttonColor: Colors
                                                                .grey.shade600,
                                                            onTap: () {
                                                              AppNavigator.pop(
                                                                  context);
                                                            })),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: PrimaryButton(
                                                            text: "Yes",
                                                            // buttonColor: AppColor.COLOR_RED1,
                                                            onTap: () {
                                                              AppNavigator.pop(
                                                                  context);
                                                              AppNavigator.pop(
                                                                  context);
                                                            })),
                                                  ],
                                                )
                                              ],
                                            ),
                                            "Delete Review",
                                            context));
                                  }),
                            ],
                          ));
                    },
                    reviews: place.result!.reviews![index],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  reviewDialog(BuildContext context, bool isNew) {
    final key = GlobalKey<FormState>();
    final TextEditingController review =
        TextEditingController(text: isNew ? "" : LOREMSMALL);
    return AppDialog.showDialogs(
        Column(
          children: [
            AppStyles.height4SizedBox(),
            AppStyles.headingStyle("Rate Your Experience",
                fontWeight: FontWeight.bold),
            AppStyles.height12SizedBox(),
            RatingWidget(
              itemSize: 30,
              initialRating: isNew ? 1 : 4.5,
              isIgnoreGesture: false,
            ),
            AppStyles.height16SizedBox(),
            Form(
              key: key,
              child: PrimaryTextField(
                hintText: "",
                controller: review,
                hasOutlined: false,
                borderColor: AppColor.TRANSPARENT_COLOR,
                maxLines: 6,
                validator: (val) => AppValidator.validateField("Review", val!),
                fillColor: Colors.grey.shade100,
              ),
            ),
            AppStyles.height12SizedBox(),
            PrimaryButton(
                text: "Submit",
                onTap: () {
                  if (isNew) {
                    if (key.currentState!.validate()) {
                      AppNavigator.pop(context);
                    }
                  } else {
                    AppNavigator.pop(context);
                    AppNavigator.pop(context);
                  }
                })
          ],
        ),
        isNew ? "Give Feedback" : "Edit Feedback",
        context);
  }
}

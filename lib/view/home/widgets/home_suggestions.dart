import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/core_provider.dart';
import '../../../utils/styles.dart';
import '../../meal_plan/screens/data/get_all_meal_plan_model.dart';

class HomeSuggestions extends StatelessWidget {
  const HomeSuggestions(
      {super.key,
      this.onTap,
      required this.onDeclineTap,
      this.showDeclineButton = false});
  final Function(String recipieID)? onTap;
  final bool showDeclineButton;

  final Function()? onDeclineTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(builder: (context, val, _) {
      final List<RecipeModel>? shuffledRecipes = val.mutualRecipes?.data;
      shuffledRecipes?.shuffle();
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .8,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(

                  // shuffledRecipes?.length ?? 0,
                  (shuffledRecipes?.length ?? 0) > 2
                      ? 2
                      : shuffledRecipes!.length, (index) {
                final recipie = shuffledRecipes?[index];
                return GestureDetector(
                  onTap: () {
                    onTap?.call(recipie!.title ?? '');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,

                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: AppColor.COLOR_GREY1.withOpacity(.2))
                      ],
                      borderRadius: BorderRadius.circular(12),
                      color: AppColor.COLOR_WHITE,
                    ),
                    // style: ListTileStyle,
                    child: CustomText(
                      textAlign: TextAlign.start,
                      text: recipie?.title,
                      maxLines: 10,
                    ),
                  ),
                );
              }),
              AppStyles.height16SizedBox(),
              if (shuffledRecipes != null && shuffledRecipes.isEmpty)
                showDeclineButton
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PrimaryButton(
                            text: 'View Nearby Restaurants',
                            onTap: onDeclineTap!),
                      )
                    : SizedBox(),
              if (shuffledRecipes != null && shuffledRecipes.isNotEmpty)
                showDeclineButton
                    ? PrimaryButton(text: 'Decline', onTap: onDeclineTap!)
                    : SizedBox()
            ],
          ),
        ),
      );
    });
  }
}

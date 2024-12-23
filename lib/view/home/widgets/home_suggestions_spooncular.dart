import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/spooncular_provider.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/spooncular/data/spooncular_random_reciepies_model.dart';
import 'package:provider/provider.dart';

class HomeSuggestionsSpoonCular extends StatelessWidget {
  const HomeSuggestionsSpoonCular(
      {super.key,
      this.onTap,
      required this.onDeclineTap,
      this.showDeclineButton = false});
  final Function(Recipes recipie)? onTap;

  final Function()? onDeclineTap;
  final bool showDeclineButton;

  @override
  Widget build(BuildContext context) {
    return Consumer<SpoonCularProvider>(builder: (context, val, _) {
      if (val.getRandomRecipiesLoadState == States.loading) {
        return const CustomLoadingBarWidget();
      } else if (val.getRandomRecipiesLoadState == States.failure) {
        return Column(
          children: [
            const Center(
              child: CustomText(
                text: 'Something Went Wrong',
              ),
            ),
            PrimaryButton(text: 'Continue', onTap: () {})
          ],
        );
      }
      if (val.getRandomRecipiesLoadState == States.success) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .8,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(

                    // val.getRandomRecipies?.recipes?.length ?? 0,
                    (val.getRandomRecipies?.recipes?.length ?? 0) > 2
                        ? 2
                        : val.getRandomRecipies!.recipes!.length, (index) {
                  final recipie = val.getRandomRecipies?.recipes?[index];
                  return GestureDetector(
                    onTap: () {
                      // onTap?.call(val.getRandomRecipies?.recipes[index]);
                      onTap?.call(val.getRandomRecipies!.recipes![index]);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,

                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 2),
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
                AppStyles.height12SizedBox(),
                // PrimaryButton(text: 'Decline', onTap: onDeclineTap!)
              ],
            ),
          ),
        );
      }

      return const SizedBox();
    });
  }
}

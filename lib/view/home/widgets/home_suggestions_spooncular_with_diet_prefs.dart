import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/providers/spooncular_provider.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:provider/provider.dart';

import '../../spooncular/data/spooncular_random_reciepies_model.dart';

class HomeSuggestionsSpoonCularWithPrefs extends StatefulWidget {
  const HomeSuggestionsSpoonCularWithPrefs(
      {super.key, this.onTap, required this.onDeclineTap});
  final Function(Recipes recipieID)? onTap;
  final Function()? onDeclineTap;

  @override
  State<HomeSuggestionsSpoonCularWithPrefs> createState() => _HomeSuggestionsSpoonCularWithPrefsState();
}

class _HomeSuggestionsSpoonCularWithPrefsState extends State<HomeSuggestionsSpoonCularWithPrefs> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SpoonCularProvider>(builder: (context, val, _) {
      if (val.recipesWithDietState == States.loading) {
        return const CustomLoadingBarWidget();
      } else if (val.recipesWithDietState == States.failure) {
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
      if (val.recipesWithDietState == States.success) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .8,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                    // val.getSpooncularRecipesWithDiet?.results?.length ?? 0,
                    (val.getSpooncularRecipesWithDiet?.results?.length ?? 0) > 2
                        ? 2
                        : val.getSpooncularRecipesWithDiet!.results!.length,
                    (index) {
                  final recipie = val.getSpooncularRecipesWithDiet?.results?[index];
                  return GestureDetector(
                    onTap: () async{
                //      log("1st ${recipie?.toJson()}");
                      final String recipeId = val.getSpooncularRecipesWithDiet!.results![index].id.toString() ?? '';
                      log("id  ${recipeId}");
                      await context.read<SpoonCularProvider>().getSingleRecipeDetail(context, recipeId, () {
                        Recipes recipie =
                        context.read<SpoonCularProvider>().singleRecipieDetail!;
                        log("Success Called " + recipie.toJson().toString());
                        setState(() {});
                        widget.onTap!.call(recipie);
                      });

                     //  onTap?.call(val.getSpooncularRecipesWithDiet!.results![index]);

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,

                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 3),
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

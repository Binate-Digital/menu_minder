import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:menu_minder/common/bottom_sheet_option_widget.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/services/network/firebase_messaging_service.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/add_recipe/screens/add_recipe_screen.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/recipe_details/screens/recipe_details_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/food_container_widget.dart';
import '../../../providers/core_provider.dart';

class RecipesWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final BuildContext? outerContext;
  final TextEditingController? searchController;
  final RecipeModel? selectedRecipie;
  final bool isFromProfileDetails;
  // final bool? isSelected;
  final Function(RecipeModel recipieID)? onSelectedRecipie;
  const RecipesWidget({
    super.key,
    required this.receipies,
    this.outerContext,
    this.onTap,
    this.onSelectedRecipie,
    this.isFromProfileDetails = false,
    this.searchController,
    this.selectedRecipie,
  });

  final List<RecipeModel> receipies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        itemCount: receipies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (innerContext, index) => FoodContainer(
          isSelected: selectedRecipie != null &&
                  selectedRecipie?.reciepieId == receipies[index].reciepieId
              ? true
              : false,
          onTap: onSelectedRecipie != null
              ? () {
                  onSelectedRecipie?.call(receipies[index]);
                }
              : () {
                  AppNavigator.push(
                      context,
                      RecipeDetailsScreen(
                          isFromProfileDetails: isFromProfileDetails,
                          mealData: receipies[index],
                          action: [
                            Visibility(
                              visible: receipies[index].myRecipe == 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    AppDialog.modalBottomSheet(
                                        context: context,
                                        child: Column(
                                          children: [
                                            (receipies[index].is_spooncular ??
                                                        0) ==
                                                    1
                                                ? const SizedBox()
                                                : BottomSheetOptions(
                                                    heading: "Edit Recipe",
                                                    imagePath: AssetPath.EDIT,
                                                    onTap: () {
                                                      AppNavigator.pop(context);
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  200));
                                                      AppNavigator.push(
                                                          context,
                                                          AddRecipeScreen(
                                                            recipeModel:
                                                                receipies[
                                                                    index],
                                                            isEdit: true,
                                                            mealType: '',
                                                          ));
                                                    }),
                                            BottomSheetOptions(
                                                heading: "Delete Recipe",
                                                imagePath: AssetPath.DELETE,
                                                bottomDivider: false,
                                                onTap: () {
                                                  AppNavigator.pop(context);
                                                  Future.delayed(const Duration(
                                                          milliseconds: 300))
                                                      .then((value) =>
                                                          AppDialog.showDialogs(
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            48.0,
                                                                        vertical:
                                                                            12),
                                                                    child: AppStyles.headingStyle(
                                                                        "Are you sure you want to delete this recipe?",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: PrimaryButton(
                                                                              text: "Cancel",
                                                                              buttonColor: Colors.grey.shade600,
                                                                              onTap: () {
                                                                                AppNavigator.pop(context);
                                                                              })),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                          child: PrimaryButton(
                                                                              text: "Yes",
                                                                              // buttonColor: AppColor.COLOR_RED1,
                                                                              onTap: () {
                                                                                print("object  Delete Property Logic");
                                                                                context.read<CoreProvider>().deleteReiciepe(context, receipies[index], onSuccess: () {
                                                                                  log("On Success Called");
                                                                                  context.read<CoreProvider>().searchState(false);
                                                                                  Future.delayed(const Duration(milliseconds: 200), () {
                                                                                    searchController?.clear();
                                                                                    AppNavigator.pop(StaticData.navigatorKey.currentState!.context);
                                                                                    AppNavigator.pop(StaticData.navigatorKey.currentState!.context);
                                                                                    AppNavigator.pop(StaticData.navigatorKey.currentState!.context);
                                                                                  });
                                                                                  // receipies.remove(receipies[index]);
                                                                                });

                                                                                // AppNavigator
                                                                                //     .pop(
                                                                                //         context);
                                                                              })),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              "Delete Recipe",
                                                              context));
                                                }),
                                          ],
                                        ));
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ]));
                },
          index: index,
          recipeModel: receipies[index],
        ),
      ),
    );
  }
}

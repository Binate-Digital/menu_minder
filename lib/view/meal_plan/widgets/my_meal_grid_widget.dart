import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_minder/common/meal_plan_container.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/primary_textfield.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/network/firebase_messaging_service.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/view/add_recipe/screens/update_meal_plan.dart';
import 'package:menu_minder/view/meal_plan/screens/meal_plan_detail_screen.dart';
import 'package:menu_minder/view/meal_plan/screens/suggesstion_list_screen.dart';
import 'package:menu_minder/view/recipe_details/screens/recipe_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/bottom_sheet_option_widget.dart';
import '../../../utils/styles.dart';
import '../screens/data/get_all_meal_plan_model.dart';

// class MyMealGridWidget extends StatelessWidget {
//   final VoidCallback onTap;
//   final String mealType;
//   const MyMealGridWidget({
//     super.key,
//     this.mealSList = const <RecipeModel>[],
//     required this.onTap,
//     required this.mealType,
//   });

//   final List<RecipeModel> mealSList;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: mealSList.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//           crossAxisCount: 2,
//           childAspectRatio: 3 / 3.5),
//       itemBuilder: (context, index) => ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: FoodContainer(
//           onTap: () {
//             AppNavigator.push(
//                 context,
//                 RecipeDetailsScreen(
//                   mealData: mealSList[index],
//                   action: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: InkWell(
//                         onTap: () {
//                           AppDialog.modalBottomSheet(
//                               context: context,
//                               child: Column(
//                                 children: [
//                                   BottomSheetOptions(
//                                       heading: "Change Day",
//                                       imagePath: AssetPath.CALENDAR,
//                                       onTap: () {
//                                         AppNavigator.pop(context);
//                                         Future.delayed(const Duration(
//                                                 milliseconds: 200))
//                                             .then((value) => AppNavigator.push(
//                                                 context,
//                                                 const ChangeDayScreen()));
//                                       }),
//                                   BottomSheetOptions(
//                                       heading: "Edit Recipe",
//                                       imagePath: AssetPath.EDIT,
//                                       onTap: () {
//                                         AppNavigator.pop(context);
//                                         Future.delayed(
//                                             const Duration(milliseconds: 200));
//                                         AppNavigator.push(
//                                             context,
//                                             AddRecipeScreen(
//                                               isEdit: true,
//                                               mealType: mealType,
//                                               isMealPlan: true,
//                                               mealData: mealSList[index],
//                                             ));
//                                       }),
//                                   BottomSheetOptions(
//                                       heading: "Delete Recipe",
//                                       imagePath: AssetPath.DELETE,
//                                       bottomDivider: false,
//                                       onTap: () {
//                                         AppNavigator.pop(context);
//                                         Future.delayed(const Duration(
//                                                 milliseconds: 200))
//                                             .then(
//                                                 (value) =>
//                                                     AppDialog.showDialogs(
//                                                         Column(
//                                                           children: [
//                                                             Padding(
//                                                               padding: const EdgeInsets
//                                                                       .symmetric(
//                                                                   horizontal:
//                                                                       48.0,
//                                                                   vertical: 12),
//                                                               child: AppStyles.headingStyle(
//                                                                   "Are you sure you want to delete this recipe?",
//                                                                   textAlign:
//                                                                       TextAlign
//                                                                           .center,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400),
//                                                             ),
//                                                             Row(
//                                                               children: [
//                                                                 Expanded(
//                                                                     child: PrimaryButton(
//                                                                         text: "Cancel",
//                                                                         buttonColor: Colors.grey.shade600,
//                                                                         onTap: () {
//                                                                           AppNavigator.pop(
//                                                                               context);
//                                                                         })),
//                                                                 const SizedBox(
//                                                                   width: 10,
//                                                                 ),
//                                                                 Expanded(
//                                                                     child: PrimaryButton(
//                                                                         text: "Yes",
//                                                                         // buttonColor: AppColor.COLOR_RED1,
//                                                                         onTap: () {
//                                                                           context.read<CoreProvider>().deleteReiciepe(
//                                                                               context,
//                                                                               mealSList[index],
//                                                                               onSuccess: () {
//                                                                             log("On Success Called");
//                                                                             AppNavigator.pop(context);
//                                                                           });
//                                                                         })),
//                                                               ],
//                                                             )
//                                                           ],
//                                                         ),
//                                                         "Delete Recipe",
//                                                         context));
//                                       }),
//                                 ],
//                               ));
//                         },
//                         child: const Icon(
//                           Icons.more_vert,
//                           color: Colors.white,
//                         ),
//                       ),
//                     )
//                   ],
//                   bottomNavigationBar: Padding(
//                     padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
//                     child: PrimaryButton(
//                         text: "Give Suggestion",
//                         onTap: () {
//                           AppNavigator.push(
//                               context, const FamilySuggestionScreen());
//                         }),
//                   ),
//                 ));
//           },
//           index: index,
//           recipeModel: null,
//         ),
//       ),
//     );
//   }
// }

class MealPlansGridWidget extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onUserBlocked;
  final bool isSuggesstionns;
  final bool hideEditButton;
  final String currentDate;

  final String mealType;
  MealPlansGridWidget({
    super.key,
    this.mealSList = const <MealPlanModel>[],
    required this.onTap,
    required this.mealType,
    this.hideEditButton = false,
    this.isSuggesstionns = false,
    this.onUserBlocked,
    required this.currentDate,
  });

  final TextEditingController controller = TextEditingController();

  final List<MealPlanModel> mealSList;

  @override
  Widget build(BuildContext context) {
    // print(mealSList.first.familyMembers.toString());
    return GridView.builder(
        itemCount: mealSList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 3 / 3.5),
        itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MealPlanContainer(
                  hideEditButton: hideEditButton,
                  onEditTapped: () {
                    AppNavigator.push(
                        context,
                        UpdateMealPlanScreen(
                          date: currentDate,
                          isEdit: true,
                          mealType: mealType,
                          mealPlanModel: mealSList[index],
                        ));
                  },
                  onTap: () {
                    if (isSuggesstionns) {
                      print("Family Members ${mealSList[index].familyMembers}");

                      AppNavigator.push(
                          context,
                          RecipeDetailsScreen(
                            isFromProfileDetails: false,
                            mealData: mealSList[index].reciepieData,
                            viewSuggestionsButton: true,
                            mealPlanModel: mealSList[index],
                          ));
                      // AppNavigator.push(
                      //     context,
                      //     SuggesstionListScreen(
                      //         mealType: mealType,
                      //         mealPlanModel: mealSList[index]));
                    } else {
                      AppNavigator.push(
                          context,
                          MealPlanDetailScreen(
                            isMyPlan: mealSList[index].myMealPlan == 1,
                            mealData: mealSList[index],
                            action: [
                              Visibility(
                                visible: mealSList[index].myMealPlan == 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      AppDialog.modalBottomSheet(
                                          context: StaticData
                                              .navigatorKey.currentContext!,
                                          child: Column(
                                            children: [
                                              // BottomSheetOptions(
                                              //     heading: "Change Day",
                                              //     imagePath: AssetPath.CALENDAR,
                                              //     onTap: () {
                                              //       AppNavigator.pop(context);
                                              //       Future.delayed(
                                              //               const Duration(
                                              //                   milliseconds:
                                              //                       200))
                                              //           .then((value) =>
                                              //               AppNavigator.push(
                                              //                   context,
                                              //                   const ChangeDayScreen()));
                                              //     }),
                                              // BottomSheetOptions(
                                              //     heading: "Edit Recipe",
                                              //     imagePath: AssetPath.EDIT,
                                              //     onTap: () {
                                              //       AppNavigator.pop(context);
                                              //       Future.delayed(
                                              //           const Duration(
                                              //               milliseconds: 200));
                                              //       AppNavigator.push(
                                              //           context,
                                              //           AddRecipeScreen(
                                              //               isEdit: true,
                                              //               mealType: mealType,
                                              //               isMealPlan: true,
                                              //               recipeModel: mealSList[
                                              //                       index]
                                              //                   .reciepieData));
                                              //     }),
                                              BottomSheetOptions(
                                                  heading: "Delete Meal Plan",
                                                  imagePath: AssetPath.DELETE,
                                                  bottomDivider: false,
                                                  onTap: () {
                                                    AppNavigator.pop(context);
                                                    Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    200))
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
                                                                          "Are you sure you want to delete this Meal Plan?",
                                                                          textAlign: TextAlign
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
                                                                                  context.read<CoreProvider>().deleteMealPlan(
                                                                                    context,
                                                                                    mealSList[index],
                                                                                    onSuccess: () {
                                                                                      AppNavigator.pop(context);
                                                                                      AppNavigator.pop(context);
                                                                                    },
                                                                                  );
                                                                                  // context.read<CoreProvider>().deleteReiciepe(context, mealSList[index], onSuccess: () {
                                                                                  //   log("On Success Called");
                                                                                  //   AppNavigator.pop(context);
                                                                                  // });
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
                            ],
                            bottomNavigationBar: Visibility(
                              visible: mealSList[index].myMealPlan == 0,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    AppDimen.SCREEN_PADDING),
                                child: PrimaryButton(
                                    text: "Give Suggestion",
                                    onTap: () {
                                      // AppNavigator.push(context,
                                      //     const FamilySuggestionScreen());

                                      AppDialog.showDialogs(
                                          Column(
                                            children: [
                                              PrimaryTextField(
                                                  maxLines: 3,
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        275)
                                                  ],
                                                  hintText: "Suggesstion",
                                                  controller: controller),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              PrimaryButton(
                                                  text: "Submit",
                                                  onTap: () {
                                                    if (controller
                                                        .text.isEmpty) {
                                                      AppMessage.showMessage(
                                                          'Please Enter Suggesstion');
                                                    } else {
                                                      context
                                                          .read<CoreProvider>()
                                                          .postSuggesstion(
                                                              mealPlanModel:
                                                                  mealSList[
                                                                      index],
                                                              onSuccess: () {
                                                                controller
                                                                    .clear();

                                                                AppNavigator.pop(
                                                                    context);
                                                              },
                                                              context: context,
                                                              text: controller
                                                                  .text,
                                                              mealPlanID: mealSList[
                                                                      index]
                                                                  .mealPlanID!);
                                                    }
                                                  })
                                            ],
                                          ),
                                          "Suggesstion",
                                          context,
                                          hasBack: true);
                                    }),
                              ),
                            ),
                          ));
                    }
                  },
                  index: index,
                  recipeModel: mealSList[index]),
            ));
  }
}

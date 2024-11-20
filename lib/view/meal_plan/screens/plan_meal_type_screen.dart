import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/add_recipe/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_tabbar.dart';
import '../widgets/my_meal_grid_widget.dart';
import 'meal_plan_suggesstion.dart';

class PlanMealTypeScreen extends StatefulWidget {
  final String mealType;
  final String currentDate;
  const PlanMealTypeScreen(
      {super.key, required this.mealType, required this.currentDate});

  @override
  State<PlanMealTypeScreen> createState() => _PlanMealTypeScreenState();
}

class _PlanMealTypeScreenState extends State<PlanMealTypeScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _getAllReciepies();
    super.initState();
  }

  _getAllReciepies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<CoreProvider>()
          .getAllMealPalnsByType(context, widget.mealType, widget.currentDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, widget.mealType, hasBack: true,
          onleadingTap: () {
        AppNavigator.pop(context);
        print("object");
      }, isRounded: true),
      body: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () async {
            if (_tabController?.index == 0) {
              await context.read<CoreProvider>().getAllMealPalnsByType(
                  context, widget.mealType, widget.currentDate);
              // print("Getting Meal Plans By Type");
            } else {
              await context.read<CoreProvider>().getFamilySuggestions(
                  context, widget.mealType,
                  currentDate: widget.currentDate);
              print("Getting Family Suggestions");
            }
          },
          // controller: controller,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: constraints.maxHeight,
              // constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppDimen.SCREEN_PADDING,
                  top: AppDimen.SCREEN_PADDING,
                  right: AppDimen.SCREEN_PADDING,
                ),
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: CustomTabbar(
                        onTabTapped: (i) {
                          print(i);
                          if (i == 0) {
                            context.read<CoreProvider>().getAllMealPalnsByType(
                                context, widget.mealType, widget.currentDate);
                            print('uf');
                          } else {
                            context.read<CoreProvider>().getFamilySuggestions(
                                context, widget.mealType,
                                currentDate: widget.currentDate);
                            print('else');
                          }
                        },
                        tabController: _tabController,
                        tabNames: const ["My Meal Plans", "Family Members"],
                      ),
                    ),
                    AppStyles.height16SizedBox(),
                    Expanded(
                      child: TabBarView(controller: _tabController!, children: [
                        Consumer<CoreProvider>(builder: (context, val, _) {
                          if (val.getAllReceipeState == States.loading) {
                            return const CustomLoadingBarWidget();
                          } else if (val.getAllReceipeState == States.failure) {
                            return const Center(
                              child: CustomText(
                                text: 'No Meal Plans Found',
                                fontSize: 18,
                              ),
                            );
                          } else if (val.getAllReceipeState == States.success) {
                            // print("Suucess PLan");
                            return Column(
                              children: [
                                Flexible(
                                    child: val.getAllMealPlans?.data != null &&
                                            val.getAllMealPlans!.data!.isEmpty
                                        ? const Center(
                                            child: CustomText(
                                              text: 'No Data yet.',
                                            ),
                                          )
                                        : MealPlansGridWidget(
                                            currentDate: widget.currentDate,
                                            mealType: widget.mealType,
                                            mealSList:
                                                val.getAllMealPlans?.data ?? [],
                                            onTap: () {
                                              // AppNavigator.push(
                                              //     context,
                                              //     RecipeDetailsScreen(

                                              //       action: [
                                              //         Padding(
                                              //           padding: const EdgeInsets.all(8.0),
                                              //           child: InkWell(
                                              //             onTap: () {
                                              //               AppDialog.modalBottomSheet(
                                              //                   context: context,
                                              //                   child: Column(
                                              //                     children: [
                                              //                       BottomSheetOptions(
                                              //                           heading: "Change Day",
                                              //                           imagePath:
                                              //                               AssetPath.CALENDAR,
                                              //                           onTap: () {
                                              //                             AppNavigator.pop(
                                              //                                 context);
                                              //                             Future.delayed(
                                              //                                     const Duration(
                                              //                                         milliseconds:
                                              //                                             200))
                                              //                                 .then((value) =>
                                              //                                     AppNavigator.push(
                                              //                                         context,
                                              //                                         const ChangeDayScreen()));
                                              //                           }),
                                              //                       BottomSheetOptions(
                                              //                           heading: "Edit Recipe",
                                              //                           imagePath: AssetPath.EDIT,
                                              //                           onTap: () {
                                              //                             AppNavigator.pop(
                                              //                                 context);
                                              //                             Future.delayed(
                                              //                                 const Duration(
                                              //                                     milliseconds:
                                              //                                         200));
                                              //                             AppNavigator.push(
                                              //                                 context,
                                              //                                 const AddRecipeScreen(
                                              //                                   isEdit: true,
                                              //                                 ));
                                              //                           }),
                                              //                       BottomSheetOptions(
                                              //                           heading: "Delete Recipe",
                                              //                           imagePath:
                                              //                               AssetPath.DELETE,
                                              //                           bottomDivider: false,
                                              //                           onTap: () {
                                              //                             AppNavigator.pop(
                                              //                                 context);
                                              //                             Future.delayed(
                                              //                                     const Duration(
                                              //                                         milliseconds:
                                              //                                             200))
                                              //                                 .then((value) =>
                                              //                                     AppDialog.showDialogs(
                                              //                                         Column(
                                              //                                           children: [
                                              //                                             Padding(
                                              //                                               padding: const EdgeInsets.symmetric(
                                              //                                                   horizontal: 48.0,
                                              //                                                   vertical: 12),
                                              //                                               child: AppStyles.headingStyle(
                                              //                                                   "Are you sure you want to delete this recipe?",
                                              //                                                   textAlign: TextAlign.center,
                                              //                                                   fontWeight: FontWeight.w400),
                                              //                                             ),
                                              //                                             Row(
                                              //                                               children: [
                                              //                                                 Expanded(
                                              //                                                     child: PrimaryButton(
                                              //                                                         text: "Cancel",
                                              //                                                         buttonColor: Colors.grey.shade600,
                                              //                                                         onTap: () {
                                              //                                                           AppNavigator.pop(context);
                                              //                                                         })),
                                              //                                                 const SizedBox(
                                              //                                                   width: 10,
                                              //                                                 ),
                                              //                                                 Expanded(
                                              //                                                     child: PrimaryButton(
                                              //                                                         text: "Yes",
                                              //                                                         // buttonColor: AppColor.COLOR_RED1,
                                              //                                                         onTap: () {
                                              //                                                           AppNavigator.pop(context);
                                              //                                                           AppNavigator.pop(context);
                                              //                                                         })),
                                              //                                               ],
                                              //                                             )
                                              //                                           ],
                                              //                                         ),
                                              //                                         "Delete Recipe",
                                              //                                         context));
                                              //                           }),
                                              //                     ],
                                              //                   ));
                                              //             },
                                              //             child: const Icon(
                                              //               Icons.more_vert,
                                              //               color: Colors.white,
                                              //             ),
                                              //           ),
                                              //         )

                                              //       ],
                                              //       bottomNavigationBar: Padding(
                                              //         padding: const EdgeInsets.all(
                                              //             AppDimen.SCREEN_PADDING),
                                              //         child: PrimaryButton(
                                              //             text: "Give Suggestion",
                                              //             onTap: () {
                                              //               AppNavigator.push(context,
                                              //                   const FamilySuggestionScreen());
                                              //             }),
                                              //       ),
                                              //     ));
                                            },
                                          )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppDimen.SCREEN_PADDING),
                                  child: PrimaryButton(
                                      text: "Add Meal Plan",
                                      onTap: () {
                                        print(
                                            "Adding New Meal Plan  date ${widget.currentDate}  mealType :${widget.mealType}  ");
                                        AppNavigator.push(
                                            context,
                                            AddRecipeScreen(
                                              title: 'Add Meal Plan',
                                              buttonText: "Share Meal Plan",
                                              date: widget.currentDate,
                                              isEdit: false,
                                              mealType: widget.mealType,
                                              isMealPlan: true,
                                            ));
                                      }),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),

                        ////FAMILY MEMBERS AND SUGGESTIONS

                        Consumer<CoreProvider>(builder: (context, val, p) {
                          if (val.getFamilySuggestionsState == States.loading) {
                            return const CustomLoadingBarWidget();
                          } else if (val.getFamilySuggestionsState ==
                              States.failure) {
                            return const Center(
                              child: CustomText(
                                text: 'No Receipes Found',
                                fontSize: 18,
                              ),
                            );
                          } else if (val.getFamilySuggestionsState ==
                              States.success) {
                            return val.familySuggesstionsRes?.data != null &&
                                    val.familySuggesstionsRes!.data!.isEmpty
                                ? const Center(
                                    child: CustomText(
                                      text: 'No Data yet.',
                                    ),
                                  )
                                : MealPlanSuggesstionGrid(
                                    currentDate: widget.currentDate,
                                    hideEditButton: true,
                                    mealType: widget.mealType,
                                    mealPlansModel:
                                        val.familySuggesstionsRes?.data ?? [],
                                  );
                          }
                          return const SizedBox();
                        }),

                        // SingleChildScrollView(
                        //   child: Column(
                        //     children: [
                        //       Column(
                        //         children: [
                        //           const SuggestionListWidget(),
                        //           ListView.builder(
                        //             itemCount: 2,
                        //             shrinkWrap: true,
                        //             physics: const NeverScrollableScrollPhysics(),
                        //             itemBuilder: (context, index) {
                        //               final suggestion = TextEditingController();
                        //               ValueNotifier<bool> showSuggestion =
                        //                   ValueNotifier(false);
                        //               return DecisionContainer(
                        //                 customPadding: const EdgeInsets.all(16),
                        //                 child: Column(
                        //                   children: [
                        //                     Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.spaceBetween,
                        //                       children: [
                        //                         const ProfileBanner(),
                        //                         InkWell(
                        //                           onTap: () {
                        //                             showSuggestion.value = true;
                        //                           },
                        //                           child: AppStyles.contentStyle(
                        //                               "Ask Suggestion",
                        //                               color:
                        //                                   AppColor.THEME_COLOR_PRIMARY1,
                        //                               textDecoration:
                        //                                   TextDecoration.underline,
                        //                               fontSize: 13),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     ValueListenableBuilder(
                        //                         valueListenable: showSuggestion,
                        //                         builder: (context, val, _) {
                        //                           return Column(
                        //                             children: [
                        //                               AppStyles.height4SizedBox(),
                        //                               if (val)
                        //                                 PrimaryTextField(
                        //                                     hintText: "Suggestion",
                        //                                     borderColor: AppColor
                        //                                         .TRANSPARENT_COLOR,
                        //                                     hasTrailingWidget: true,
                        //                                     trailingWidget:
                        //                                         AssetPath.SEND_MESSAGE,
                        //                                     onTrailingTap: () {
                        //                                       showSuggestion.value =
                        //                                           false;
                        //                                       suggestion.clear();
                        //                                     },
                        //                                     fillColor:
                        //                                         Colors.grey.shade100,
                        //                                     controller: suggestion)
                        //                             ],
                        //                           );
                        //                         }),
                        //                   ],
                        //                 ),
                        //               );
                        //             },
                        //           )

                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:menu_minder/common/custom_extended_image_with_loading.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/profile_banner_widget.dart';
import 'package:menu_minder/providers/spooncular_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/recipe_details/widgets/instructions_tab_widget.dart';
import 'package:menu_minder/view/spooncular/data/admin_recipes.dart';
import 'package:menu_minder/view/spooncular/data/spooncular_random_reciepies_model.dart';
import 'package:menu_minder/view/user_profile/screens/friends_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_tabbar.dart';
import '../../../providers/core_provider.dart';
import '../../add_recipe/data/create_reciepe_model.dart';
import '../../auth/bloc/provider/auth_provider.dart';
import '../../recipe_details/widgets/custom_carosal_indicator.dart';
import 'select_fiter_dialog.dart';

class SpoonCularRecipieDetailsScreen extends StatefulWidget {
  Widget? bottomNavigationBar;
  List<Widget>? action;
  Recipes? mealData;
  AdminRecipe? adminRecipeData;
  final String? recipieByID;
  SpoonCularRecipieDetailsScreen(
      {Key? key,
      this.bottomNavigationBar,
      this.action,
      this.mealData,
      this.recipieByID,
      this.adminRecipeData})
      : super(key: key);

  @override
  State<SpoonCularRecipieDetailsScreen> createState() =>
      _SpoonCularRecipieDetailsScreenState();
}

class _SpoonCularRecipieDetailsScreenState
    extends State<SpoonCularRecipieDetailsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late SpoonCularProvider _sp;
  List<String> adminRecipeInsts = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _sp = context.read<SpoonCularProvider>();

    if (_sp.getRecipeType == 0) {
      if (widget.mealData == null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          // context
          //     .read<SpoonCularProvider>()
          _sp.getSingleRecipeDetail(context, widget.recipieByID!, () {
            widget.mealData =
                context.read<SpoonCularProvider>().singleRecipieDetail;

            print("Success Called " + widget.mealData!.id.toString());

            setState(() {});
          });
        });
      }
    } else {
      widget.adminRecipeData!.instruction.split(":").forEach((element) {
        adminRecipeInsts.add(element.split("Step")[0]);
      });
      adminRecipeInsts.removeAt(0);
      print("inst list :: ${adminRecipeInsts}");
    }
    super.initState();
  }

  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("recipe title :: ${widget.adminRecipeData?.title}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: AppStyles.appBar("Recipe Details", () {
        AppNavigator.pop(context);
      }, textSize: 18, action: widget.action),
      body: _sp.getRecipeType == 0
          ? Consumer<SpoonCularProvider>(builder: (context, val, _) {
              if (val.getRecipeDetailsState == States.loading) {
                return const Center(child: CustomLoadingBarWidget());
              } else if (val.getRecipeDetailsState == States.success) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        widget.mealData != null &&
                                widget.mealData?.image != null &&
                                widget.mealData!.image!.isNotEmpty
                            ? MyCustomExtendedImage(
                                imageUrl: widget.mealData!.image!)
                            // Center(
                            //     child: ExtendedImage.network(
                            //       dotenv.get('IMAGE_URL') +
                            //           widget.mealData!.recipeImages!.first,
                            //       height: 280,
                            //     ),
                            //   )

                            : Center(
                                child: Image.asset(
                                  AssetPath.PHOTO_PLACE_HOLDER,
                                  height:
                                      MediaQuery.of(context).size.height / 3.5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Container(
                          height: MediaQuery.of(context).size.height * .12,
                          decoration: BoxDecoration(
                              color: AppColor.COLOR_BLACK.withOpacity(.3)),
                        ),
                        // Positioned(
                        //   bottom: 20,
                        //   left: 0,
                        //   right: 0,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: List.generate(
                        //       widget.mealData!.image?.length ?? 0,
                        //       (index) => buildDotIndicator(index),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: AppDimen.SCREEN_PADDING,
                              left: AppDimen.SCREEN_PADDING,
                              right: AppDimen.SCREEN_PADDING),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppStyles.headingStyle(
                                        widget.mealData?.title ?? '',
                                        // 'sdmskmdjskdskdskdsdsdksdksdk',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  PrimaryButton(
                                      text: 'Add to Profile',
                                      onTap: () {
                                        // AppNavigator
                                        AppDialog.showDialogs(
                                          SelectFilterDialog(
                                            selectedPrefrence: (selectedPref) {
                                              // AppNavigator.pop(context);

                                              final List<Map<String, String>>
                                                  ingredients = [];

                                              ///ADDING TO MY PROFILE
                                              ///
                                              if (widget.mealData
                                                          ?.extendedIngredients !=
                                                      null &&
                                                  widget
                                                      .mealData!
                                                      .extendedIngredients!
                                                      .isNotEmpty) {
                                                for (var e in widget.mealData!
                                                    .extendedIngredients!) {
                                                  final item =
                                                      e.name.toString();
                                                  final value =
                                                      '${e.measures?.metric?.amount!}  ${e.measures!.metric!.unitLong}';

                                                  final Map<String, String>
                                                      map = {item: value};

                                                  ingredients.add(map);
                                                }
                                              }

                                              List<String> networkImages = [];

                                              if (widget.mealData?.image !=
                                                  null) {
                                                networkImages.add(
                                                    widget.mealData!.image!);
                                              }

                                              Map<String, String> mergedMap =
                                                  {};

                                              for (var map in ingredients) {
                                                mergedMap.addAll(map);
                                              }

                                              StringBuffer instructions =
                                                  StringBuffer();

                                              if (widget.mealData!
                                                          .analyzedInstructions !=
                                                      null &&
                                                  widget
                                                      .mealData!
                                                      .analyzedInstructions!
                                                      .isNotEmpty) {
                                                for (var e in widget.mealData!
                                                    .analyzedInstructions!) {
                                                  e.steps?.asMap().forEach(
                                                      (index, element) {
                                                    // Add each step to the StringBuffer with a new line, including the step index
                                                    instructions.writeln(
                                                        "Step ${index + 1}: ${e.name} \n ${element.step}");
                                                  });
                                                }
                                              }

                                              print(
                                                  "MODEL TO SEND \n $instructions");

                                              final model = CreateReceipeModel(
                                                  preference: selectedPref,
                                                  servingSize: widget.mealData
                                                              ?.servings !=
                                                          null
                                                      ? widget
                                                          .mealData!.servings
                                                      : null,
                                                  title:
                                                      widget.mealData?.title ??
                                                          '',
                                                  images: [],
                                                  descriptions: widget
                                                          .mealData?.summary ??
                                                      'No Description',
                                                  instructions:
                                                      instructions.toString(),
                                                  networkImages:
                                                      networkImages.isNotEmpty
                                                          ? jsonEncode(
                                                              networkImages)
                                                          : jsonEncode(
                                                              networkImages),
                                                  is_spooncular: 1,
                                                  ingredients: mergedMap,
                                                  type: 'Reciepe');

                                              print(networkImages);
                                              context
                                                  .read<CoreProvider>()
                                                  .addRecipieToProfile(
                                                    context,
                                                    () async {
                                                      AppNavigator.pop(context);
                                                      AppNavigator.pop(context);
                                                    },
                                                    model,
                                                    ingredients,
                                                    onFailure: () {
                                                      AppNavigator.pop(context);
                                                    },
                                                    type: '',
                                                    showLoader: true,
                                                  );
                                            },
                                          ),
                                          'Select Recipe Preference',
                                          context,
                                          hasBack: true,
                                        );

                                        return;
                                      }),
                                ],
                              ),
                              AppStyles.height20SizedBox(),

                              AppStyles.headingStyle('Ingredients',
                                  fontSize: 20, fontWeight: FontWeight.bold),

                              AppStyles.height8SizedBox(),
                              ...List.generate(
                                  widget.mealData?.extendedIngredients
                                          ?.length ??
                                      0, (index) {
                                final ingrenet = widget
                                    .mealData?.extendedIngredients?[index];

                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 8,
                                        width: 8,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                AppColor.THEME_COLOR_PRIMARY1),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          textAlign: TextAlign.start,
                                          text: ingrenet?.name ?? '',
                                          fontSize: 16,
                                          // maxLines: 1,
                                          weight: FontWeight.w400,
                                        ),
                                      ),
                                      AppStyles.height12SizedBox(width: 20),
                                      CustomText(
                                        // maxLines: 1,
                                        text:
                                            '${ingrenet?.measures?.metric?.amount} ${ingrenet?.measures?.metric?.unitShort.toString()}',
                                        fontSize: 16,
                                        weight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              AppStyles.height20SizedBox(),

                              AppStyles.headingStyle('Instructions',
                                  fontSize: 20, fontWeight: FontWeight.bold),

                              ...List.generate(
                                  widget.mealData?.analyzedInstructions
                                          ?.length ??
                                      0, (index) {
                                final instruction = widget
                                    .mealData?.analyzedInstructions?[index];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   '${index + 1}: ${instruction?.name}',
                                    //   style: TextStyle(fontWeight: FontWeight.bold),
                                    // ),

                                    // SizedBox(height: 8.0),
                                    // if (instruction?.steps != null)
                                    //   for (final step in instruction!.steps!)
                                    //     Text('Step' + step.step ?? ''),

                                    ...List.generate(
                                        instruction?.steps?.length ?? 0,
                                        (index) {
                                      final step = instruction?.steps?[index];

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppStyles.headingStyle(
                                              'Step ${index + 1}',
                                              color: AppColor
                                                  .THEME_COLOR_SECONDARY,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            Text(
                                              // 'Step ${index + 1}: \n${step?.step ?? ''}',
                                              step?.step ?? '',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    // Divider(),
                                  ],
                                );
                              }),

                              AppStyles.height8SizedBox(),
                              // HtmlWidget(
                              //   widget.mealData?.instructions ?? 'No Instructions',
                              // ),

                              // InkWell(
                              //     onTap: () {
                              //       // if (widget.mealData?.myRecipe == 0) {
                              //       //   AppNavigator.push(
                              //       //       context,
                              //       //       FriendsProfileScreen(
                              //       //         userID: widget.mealData!.userData!.Id!,
                              //       //       ));
                              //       // }
                              //     },
                              //     child: ProfileBanner(
                              //       userModelData: widget.mealData?.userData,
                              //     )),
                              AppStyles.height16SizedBox(),
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   padding: const EdgeInsets.all(16),
                              //   decoration: BoxDecoration(
                              //       color: AppColor.CONTAINER_GREY,
                              //       borderRadius: BorderRadius.circular(10)),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       AppStyles.subHeadingStyle("Description",
                              //           fontWeight: FontWeight.normal),
                              //       AppStyles.height4SizedBox(),

                              //       ExpandableText(
                              //         widget.mealData?.instructions ?? '',
                              //         expandText: 'show more',
                              //         collapseText: 'show less',
                              //         maxLines: 2,
                              //         linkColor: AppColor.THEME_COLOR_PRIMARY1,
                              //         style: const TextStyle(fontSize: 13),
                              //       ),
                              //       // AppStyles.contentStyle(
                              //       //     widget.mealData?.discription ?? ''),
                              //     ],
                              //   ),
                              // ),
                              AppStyles.height16SizedBox(),

                              // DefaultTabController(
                              //   length: 2,
                              //   child: CustomTabbar(
                              //     tabController: _tabController,
                              //     tabNames: const ["Ingredients", "Instructions"],
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height / 1.7,
                              //   child: TabBarView(
                              //       controller: _tabController,
                              //       physics: const NeverScrollableScrollPhysics(),
                              //       children: [
                              //         Container(),
                              //         SingleChildScrollView(
                              //           child: Container(
                              //               child: ),
                              //         ),
                              //         // IngredientsTab(
                              //         //   ingredients: widget.mealData?.ingredients,
                              //         // ),
                              //         // InstructionsTab(
                              //         //   instructions: widget.mealData?.instruction,
                              //         // )
                              //       ]),
                              // )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return const SizedBox();
              }
            })
          : Column(
              children: [
                Stack(
                  children: [
                    widget.adminRecipeData != null &&
                            widget.adminRecipeData!.recipeImages.isNotEmpty
                        ? MyCustomExtendedImage(
                            imageUrl:
                                "https://webservices.menuminderusa.com:3000/${widget.adminRecipeData!.recipeImages.first}")
                        // Center(
                        //     child: ExtendedImage.network(
                        //       dotenv.get('IMAGE_URL') +
                        //           widget.mealData!.recipeImages!.first,
                        //       height: 280,
                        //     ),
                        //   )

                        : Center(
                            child: Image.asset(
                              AssetPath.PHOTO_PLACE_HOLDER,
                              height: MediaQuery.of(context).size.height / 3.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Container(
                      height: MediaQuery.of(context).size.height * .12,
                      decoration: BoxDecoration(
                          color: AppColor.COLOR_BLACK.withOpacity(.3)),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimen.SCREEN_PADDING,
                          left: AppDimen.SCREEN_PADDING,
                          right: AppDimen.SCREEN_PADDING),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppStyles.headingStyle(
                                    widget.adminRecipeData?.title ?? '',
                                    // 'sdmskmdjskdskdskdsdsdksdksdk',
                                    fontWeight: FontWeight.bold),
                              ),
                              PrimaryButton(
                                  text: 'Add to Profile',
                                  onTap: () {
                                    // AppNavigator
                                    AppDialog.showDialogs(
                                      SelectFilterDialog(
                                        selectedPrefrence: (selectedPref) {
                                          // AppNavigator.pop(context);

                                          final List<Map<String, String>>
                                              ingredients = [];

                                          ///ADDING TO MY PROFILE
                                          ///
                                          // if (widget.adminRecipeData!.ingredients.isNotEmpty) {
                                          //   for (var e in widget.adminRecipeData!
                                          //       .ingredients!) {
                                          //     final item = e.toString();
                                          //     final value =
                                          //         '${e.measures?.metric?.amount!}  ${e.measures!.metric!.unitLong}';

                                          //     final Map<String, String> map = {
                                          //       item: value
                                          //     };

                                          //     ingredients.add(map);
                                          //   }
                                          // }

                                          for (var r in widget
                                              .adminRecipeData!.ingredients) {
                                            ingredients.add(r);
                                          }

                                          List<String> networkImages = [];

                                          if (widget.adminRecipeData!
                                              .recipeImages.isNotEmpty) {
                                            widget.adminRecipeData!.recipeImages
                                                .forEach((element) {
                                              networkImages.add(element);
                                            });
                                          }

                                          Map<String, String> mergedMap = {};

                                          for (var map in ingredients) {
                                            mergedMap.addAll(map);
                                          }

                                          // StringBuffer instructions =
                                          //     StringBuffer();

                                          // if (adminRecipeInsts.isNotEmpty) {
                                          //   for (var e in widget.mealData!
                                          //       .analyzedInstructions!) {
                                          //     e.steps
                                          //         ?.asMap()
                                          //         .forEach((index, element) {
                                          //       // Add each step to the StringBuffer with a new line, including the step index
                                          //       instructions.writeln(
                                          //           "Step ${index + 1}: ${e.name} \n ${element.step}");
                                          //     });
                                          //   }
                                          // }

                                          print(
                                              "MODEL TO SEND \n ${widget.adminRecipeData!.instruction}");

                                          final model = CreateReceipeModel(
                                              preference: selectedPref,
                                              servingSize:
                                                  widget.mealData?.servings !=
                                                          null
                                                      ? widget.adminRecipeData!
                                                              .servingSize ??
                                                          0
                                                      : null,
                                              title: widget
                                                      .adminRecipeData?.title ??
                                                  '',
                                              images: [],
                                              descriptions: widget
                                                      .adminRecipeData
                                                      ?.description ??
                                                  'No Description',
                                              instructions: widget
                                                  .adminRecipeData!.instruction,
                                              networkImages: networkImages
                                                      .isNotEmpty
                                                  ? jsonEncode(networkImages)
                                                  : jsonEncode(networkImages),
                                              is_spooncular: 0,
                                              ingredients: mergedMap,
                                              type: 'Reciepe');

                                          print(networkImages);
                                          context
                                              .read<CoreProvider>()
                                              .addRecipieToProfile(
                                                context,
                                                () async {
                                                  AppNavigator.pop(context);
                                                  AppNavigator.pop(context);
                                                },
                                                model,
                                                ingredients,
                                                onFailure: () {
                                                  AppNavigator.pop(context);
                                                },
                                                type: '',
                                                showLoader: true,
                                              );
                                        },
                                      ),
                                      'Select Recipe Preference',
                                      context,
                                      hasBack: true,
                                    );

                                    return;
                                  }),
                            ],
                          ),
                          AppStyles.height20SizedBox(),

                          AppStyles.headingStyle('Ingredients',
                              fontSize: 20, fontWeight: FontWeight.bold),

                          AppStyles.height8SizedBox(),
                          ...List.generate(
                              widget.adminRecipeData?.ingredients.length ?? 0,
                              (index) {
                            final ingredient = widget
                                .adminRecipeData?.ingredients[index]
                                .toString()
                                .replaceAll("}", "")
                                .replaceAll("{", "");
                            var name = ingredient!.split(":")[0];
                            var quantity = ingredient.split(":")[1];

                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.THEME_COLOR_PRIMARY1),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: CustomText(
                                      textAlign: TextAlign.start,
                                      text: name ?? '',
                                      fontSize: 16,
                                      // maxLines: 1,
                                      weight: FontWeight.w400,
                                    ),
                                  ),
                                  AppStyles.height12SizedBox(width: 20),
                                  CustomText(
                                    // maxLines: 1,
                                    text: quantity,
                                    fontSize: 16,
                                    weight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            );
                          }),

                          AppStyles.height20SizedBox(),

                          AppStyles.headingStyle('Instructions',
                              fontSize: 20, fontWeight: FontWeight.bold),

                          ...List.generate(1 ?? 0, (index) {
                            // final instruction =
                            //     widget.mealData?.analyzedInstructions?[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(adminRecipeInsts.length ?? 0,
                                    (index) {
                                  final step = adminRecipeInsts[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppStyles.headingStyle(
                                          'Step ${index + 1}',
                                          color: AppColor.THEME_COLOR_SECONDARY,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        Text(
                                          // 'Step ${index + 1}: \n${step?.step ?? ''}',
                                          step ?? '',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                // Divider(),
                              ],
                            );
                          }),

                          AppStyles.height8SizedBox(),
                          // HtmlWidget(
                          //   widget.mealData?.instructions ?? 'No Instructions',
                          // ),

                          // InkWell(
                          //     onTap: () {
                          //       // if (widget.mealData?.myRecipe == 0) {
                          //       //   AppNavigator.push(
                          //       //       context,
                          //       //       FriendsProfileScreen(
                          //       //         userID: widget.mealData!.userData!.Id!,
                          //       //       ));
                          //       // }
                          //     },
                          //     child: ProfileBanner(
                          //       userModelData: widget.mealData?.userData,
                          //     )),
                          AppStyles.height16SizedBox(),
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   padding: const EdgeInsets.all(16),
                          //   decoration: BoxDecoration(
                          //       color: AppColor.CONTAINER_GREY,
                          //       borderRadius: BorderRadius.circular(10)),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       AppStyles.subHeadingStyle("Description",
                          //           fontWeight: FontWeight.normal),
                          //       AppStyles.height4SizedBox(),

                          //       ExpandableText(
                          //         widget.mealData?.instructions ?? '',
                          //         expandText: 'show more',
                          //         collapseText: 'show less',
                          //         maxLines: 2,
                          //         linkColor: AppColor.THEME_COLOR_PRIMARY1,
                          //         style: const TextStyle(fontSize: 13),
                          //       ),
                          //       // AppStyles.contentStyle(
                          //       //     widget.mealData?.discription ?? ''),
                          //     ],
                          //   ),
                          // ),
                          AppStyles.height16SizedBox(),

                          // DefaultTabController(
                          //   length: 2,
                          //   child: CustomTabbar(
                          //     tabController: _tabController,
                          //     tabNames: const ["Ingredients", "Instructions"],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height / 1.7,
                          //   child: TabBarView(
                          //       controller: _tabController,
                          //       physics: const NeverScrollableScrollPhysics(),
                          //       children: [
                          //         Container(),
                          //         SingleChildScrollView(
                          //           child: Container(
                          //               child: ),
                          //         ),
                          //         // IngredientsTab(
                          //         //   ingredients: widget.mealData?.ingredients,
                          //         // ),
                          //         // InstructionsTab(
                          //         //   instructions: widget.mealData?.instruction,
                          //         // )
                          //       ]),
                          // )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildStepWidget(Map<String, dynamic> step) {
    final ingredients = step['ingredients'] as List<Map<String, dynamic>>;
    final equipment = step['equipment'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '  ${step['number']}. ${step['step']}',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        if (ingredients.isNotEmpty) _buildIngredientsWidget(ingredients),
        if (equipment.isNotEmpty) _buildEquipmentWidget(equipment),
        if (step['length'] != null)
          Text(
            '  Duration: ${step['length']['number']} ${step['length']['unit']}',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildIngredientsWidget(List<Map<String, dynamic>> ingredients) {
    return Wrap(
      spacing: 8.0,
      children: ingredients
          .map((ingredient) => Chip(
                label: Text(ingredient['name']),
                avatar: ingredient['image'] != null
                    ? Image.network(
                        'https://example.com/${ingredient['image']}',
                        width: 20,
                        height: 20,
                      )
                    : null,
              ))
          .toList(),
    );
  }

  Widget _buildEquipmentWidget(List<Map<String, dynamic>> equipment) {
    return Wrap(
      spacing: 8.0,
      children: equipment
          .map((item) => Chip(
                label: Text(item['name']),
                avatar: item['image'] != null
                    ? Image.network(
                        'https://example.com/${item['image']}',
                        width: 20,
                        height: 20,
                      )
                    : null,
              ))
          .toList(),
    );
  }
}

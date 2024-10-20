// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/profile_banner_widget.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/family_suggestion/screens/share_family_members_screen.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/recipe_details/widgets/instructions_tab_widget.dart';
import 'package:menu_minder/view/user_profile/screens/friends_profile_screen.dart';
import '../../../common/custom_tabbar.dart';
import '../../meal_plan/screens/suggesstion_list_screen.dart';
import '../widgets/custom_carosal_indicator.dart';
import '../widgets/ingredients_tab_widget.dart';
import 'package:menu_minder/utils/uppercase_string_extension.dart';

class RecipeDetailsScreen extends StatefulWidget {
  Widget? bottomNavigationBar;
  List<Widget>? action;
  final RecipeModel? mealData;
  final MealPlanModel? mealPlanModel;
  final bool viewSuggestionsButton;
  final bool isFromProfileDetails;
  RecipeDetailsScreen(
      {Key? key,
      this.bottomNavigationBar,
      this.mealPlanModel,
      this.action,
      this.mealData,
      this.viewSuggestionsButton = false,
      this.isFromProfileDetails = false})
      : super(key: key);

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    print("RECIPIESSS DETAIL SCEREEN ${widget.isFromProfileDetails}");
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: widget.bottomNavigationBar,
      // appBar: AppStyles.appBar(
      //   "Recipe Details",
      //   () {
      //     AppNavigator.pop(context);
      //   },
      //   textSize: 18,
      //   action: widget.action,

      // ),
      appBar: AppStyles.appBar(
        // context,
        "Recipe Details",
        () {
          AppNavigator.pop(context);
        },
        action: widget.action,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              // widget.mealData != null &&
              //         widget.mealData!.recipeImages != null &&
              //         widget.mealData!.recipeImages!.isNotEmpty
              //     ? CustomCarouselSlider(
              //         onPageChanged: (index) {
              //           setState(() {
              //             currentImageIndex = index;
              //           });
              //         },
              //         imageUrls: widget.mealData!.recipeImages!,
              //       )
              //     // Center(
              //     //     child: ExtendedImage.network(
              //     //       dotenv.get('IMAGE_URL') +
              //     //           widget.mealData!.recipeImages!.first,
              //     //       height: 280,
              //     //     ),
              //     //   )

              //     : Center(
              //         child: Image.asset(
              //           AssetPath.PHOTO_PLACE_HOLDER,
              //           height: MediaQuery.of(context).size.height / 3.2,
              //           fit: BoxFit.cover,
              //         ),
              //       ),

              // Positioned(
              //   bottom: 20,
              //   left: 0,
              //   right: 0,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: List.generate(
              //       widget.mealData!.recipeImages?.length ?? 0,
              //       (index) => buildDotIndicator(index),
              //     ),
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      widget.mealData != null &&
                              widget.mealData!.recipeImages != null &&
                              widget.mealData!.recipeImages!.isNotEmpty
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CustomCarouselSlider(
                                onPageChanged: (index) {
                                  setState(() {
                                    currentImageIndex = index;
                                  });
                                },
                                imageUrls: widget.mealData!.recipeImages!,
                              ),
                            )
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
                                    MediaQuery.of(context).size.height / 3.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Container(
                        height: MediaQuery.of(context).size.height / 3.2,
                        decoration: BoxDecoration(
                            color: AppColor.COLOR_BLACK.withOpacity(.3)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Positioned(
                  //   bottom: 10,
                  //   left: 0,
                  //   right: 0,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: List.generate(
                  //       widget.mealData!.recipeImages?.length ?? 0,
                  //       (index) => buildDotIndicator(index),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.mealData!.recipeImages?.length ?? 0,
                      (index) => buildDotIndicator(index),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        // top: AppDimen.SCREEN_PADDING,
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
                                  fontWeight: FontWeight.bold),
                            ),
                            widget.viewSuggestionsButton
                                ? GestureDetector(
                                    onTap: () {
                                      AppNavigator.push(
                                          context,
                                          SuggesstionListScreen(
                                              mealType: widget.mealData?.type ??
                                                  "breakfast",
                                              mealPlanModel:
                                                  widget.mealPlanModel!));
                                    },
                                    child: Container(
                                      // height: 50,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 15),
                                      // margin: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: AppColor.THEME_COLOR_PRIMARY1,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const CustomText(
                                        text: "View Suggestions",
                                        fontSize: 12,
                                        fontColor: AppColor.COLOR_WHITE,
                                      ),
                                    ),
                                  )
                                : widget.mealData?.myRecipe == 1
                                    ? PrimaryButton(
                                        textPadding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        height: 35,
                                        buttonTextSize: 12,
                                        text: 'Share',
                                        onTap: () {
                                          AppNavigator.push(
                                              context,
                                              ShareFamilyScreen(
                                                recipeModel: widget.mealData!,
                                              ));
                                        })
                                    : const SizedBox()
                          ],
                        ),
                        AppStyles.height20SizedBox(),
                        InkWell(
                            onTap: () {
                              if (widget.mealData?.myRecipe == 0) {
                                if (widget.isFromProfileDetails) {
                                  print(
                                      "object ${widget.isFromProfileDetails}");
                                  AppNavigator.pop(context);
                                } else {
                                  AppNavigator.push(
                                      context,
                                      FriendsProfileScreen(
                                        userID: widget.mealData!.userData!.Id!,
                                      ));
                                }
                              } else {
                                AppMessage.showMessage(
                                    'Please go to my profile to visit your profile');
                              }
                            },
                            child: ProfileBanner(
                              userModelData: widget.mealData?.userData,
                            )),
                        AppStyles.height16SizedBox(),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppColor.CONTAINER_GREY,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppStyles.subHeadingStyle(
                                  widget.mealData?.discription != null &&
                                          widget.mealData?.discription == " "
                                      ? "No Description"
                                      : 'Description',
                                  fontWeight: FontWeight.normal),
                              AppStyles.height4SizedBox(),
                              widget.mealData?.is_spooncular == 1
                                  ? HtmlWidget(widget.mealData?.discription ??
                                      'No Description')
                                  : AppStyles.contentStyle(
                                      widget.mealData?.discription ?? ''),
                              const SizedBox(
                                height: 10,
                              ),
                              widget.mealData?.servingSize != null
                                  ? AppStyles.contentStyle(
                                      'Serving Size: ${widget.mealData?.servingSize} Persons',
                                      fontSize: 15)
                                  : const SizedBox(),
                              widget.mealData?.prefrence != null
                                  ? AppStyles.contentStyle(
                                      'Recipe Prefrence: ${widget.mealData?.prefrence?.capitalizeFirstLetter()}',
                                      fontSize: 15)
                                  : const SizedBox()
                            ],
                          ),
                        ),
                        AppStyles.height16SizedBox(),
                        DefaultTabController(
                          length: 2,
                          child: CustomTabbar(
                            tabController: _tabController,
                            tabNames: const ["Ingredients", "Instructions"],
                          ),
                        ),
                        AppStyles.height8SizedBox(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.7,
                          child: TabBarView(
                              controller: _tabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                IngredientsTab(
                                  ingredients: widget.mealData?.ingredients,
                                ),
                                InstructionsTab(
                                  instructions: widget.mealData?.instruction,
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDotIndicator(int index) {
    return Container(
      width: currentImageIndex == index ? 12 : 8.0,
      height: currentImageIndex == index ? 12.0 : 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentImageIndex == index
            ? AppColor.BG_COLOR
            : AppColor.THEME_COLOR_SECONDARY,
      ),
    );
  }
}

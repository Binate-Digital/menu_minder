// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/common/profile_banner_widget.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/recipe_details/widgets/instructions_tab_widget.dart';
import 'package:menu_minder/view/user_profile/screens/friends_profile_screen.dart';
import '../../../common/custom_tabbar.dart';
import '../../recipe_details/widgets/custom_carosal_indicator.dart';
import '../../recipe_details/widgets/ingredients_tab_widget.dart';
import 'package:menu_minder/utils/uppercase_string_extension.dart';

class MealPlanDetailScreen extends StatefulWidget {
  Widget? bottomNavigationBar;
  List<Widget>? action;
  final bool isMyPlan;
  final MealPlanModel? mealData;
  MealPlanDetailScreen(
      {Key? key,
      this.bottomNavigationBar,
      this.isMyPlan = false,
      this.action,
      this.mealData})
      : super(key: key);

  @override
  State<MealPlanDetailScreen> createState() => _MealPlanDetailScreenState();
}

class _MealPlanDetailScreenState extends State<MealPlanDetailScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // resizeToAvoidBottomInset: false,
      floatingActionButton: widget.bottomNavigationBar,
      appBar: AppStyles.appBar("Meal Plan Details", () {
        AppNavigator.pop(context);
      }, textSize: 18, action: widget.action),
      body: Column(
        children: [
          Stack(
            children: [
              widget.mealData?.reciepieData?.recipeImages != null &&
                      widget.mealData!.reciepieData!.recipeImages!.isNotEmpty
                  ? CustomCarouselSlider(
                      onPageChanged: (index) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                      imageUrls: widget.mealData!.reciepieData!.recipeImages!,
                    )
                  // Center(
                  //     child: ExtendedImage.network(
                  //       dotenv.get('IMAGE_URL') +
                  //           widget.mealData!.reciepieData!.recipeImages!.first,
                  //       height: 280,
                  //     ),
                  //   )
                  : Image.asset(
                      AssetPath.PHOTO_PLACE_HOLDER,
                      height: MediaQuery.of(context).size.height / 3.2,
                      fit: BoxFit.cover,
                    ),
              Container(
                height: MediaQuery.of(context).size.height / 3.2,
                decoration:
                    BoxDecoration(color: AppColor.COLOR_BLACK.withOpacity(.3)),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.mealData!.reciepieData?.recipeImages?.length ?? 0,
                    (index) => buildDotIndicator(index),
                  ),
                ),
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
                  AppStyles.headingStyle(
                      widget.mealData?.reciepieData?.title ?? '',
                      fontWeight: FontWeight.bold),
                  AppStyles.height8SizedBox(),
                  AppStyles.headingStyle('Date: ${widget.mealData?.date}' ?? '',
                      fontWeight: FontWeight.normal),
                  AppStyles.height20SizedBox(),
                  InkWell(
                      onTap: () {
                        if (widget.mealData?.myMealPlan == 0) {
                          AppNavigator.push(
                              context,
                              FriendsProfileScreen(
                                userID: widget
                                    .mealData!.reciepieData!.userData!.Id!,
                              ));
                        } else {
                          AppMessage.showMessage(AppString.MY_PROFILE_MESSAGE);
                        }
                      },
                      child: ProfileBanner(
                        userModelData: widget.mealData?.reciepieData?.userData,
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
                            widget.mealData?.reciepieData?.discription !=
                                        null &&
                                    widget.mealData?.reciepieData
                                            ?.discription ==
                                        ""
                                ? "No Description"
                                : 'Description',
                            fontWeight: FontWeight.normal),
                        AppStyles.height4SizedBox(),
                        // AppStyles.contentStyle(
                        //     widget.mealData?.reciepieData?.discription ??
                        //         longText),

                        ExpandableText(
                          widget.mealData?.reciepieData?.discription ?? '',
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 2,
                          linkColor: AppColor.THEME_COLOR_PRIMARY1,
                          style: const TextStyle(fontSize: 13),
                        ),
                        AppStyles.height12SizedBox(),

                        widget.mealData?.reciepieData?.servingSize != null
                            ? AppStyles.contentStyle(
                                'Serving Size: ${widget.mealData?.reciepieData?.servingSize} Persons',
                                fontSize: 14)
                            : const SizedBox(),
                        widget.mealData?.reciepieData?.prefrence != null
                            ? AppStyles.contentStyle(
                                'Recipe Prefrence: ${widget.mealData?.type}',
                                fontSize: 14)
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
                            ingredients:
                                widget.mealData?.reciepieData?.ingredients,
                          ),
                          InstructionsTab(
                            instructions:
                                widget.mealData?.reciepieData?.instruction,
                          )
                        ]),
                  )
                ],
              ),
            )),
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
            ? AppColor.THEME_COLOR_SECONDARY
            : AppColor.BG_COLOR,
      ),
    );
  }
}

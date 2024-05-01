import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/spooncular_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/spooncular/spooncular_views/spooncular_details_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/dropdown_widget.dart';
import '../../../common/primary_button.dart';
import '../../../common/primary_textfield.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/config.dart';
import '../../nearby_restraunt/screens/nearby_screen.dart';

class SpecificRecipesWithDiet extends StatefulWidget {
  const SpecificRecipesWithDiet({super.key, this.hideButton = false});
  final bool hideButton;

  @override
  State<SpecificRecipesWithDiet> createState() =>
      _SpecificRecipesWithDietState();
}

class _SpecificRecipesWithDietState extends State<SpecificRecipesWithDiet> {
  @override
  void initState() {
    selectedPrefrence = AppConfig.recipePrefrnces.first;
    context.read<SpoonCularProvider>().initSearching();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SpoonCularProvider>().recipiesWithDiet(context,
          prefrenceList:
              context.read<AuthProvider>().userdata?.data?.breakfastPrerence);
    });

    searchController.addListener(() {
      context
          .read<SpoonCularProvider>()
          .updateSearchPrefRecipies(searchController.text);
    });
    super.initState();
  }

  String? selectedPrefrence;

  Widget _foodPrefrenceDropdown() {
    return DropDownField(
      backgroundColor: Colors.grey.shade100,
      hint: 'Recipe Preference',
      iconSize: 24,
      selected_value: selectedPrefrence,
      items: AppConfig.recipePrefrnces,
      onValueChanged: (type) {
        setState(() {
          selectedPrefrence = type;
        });

        searchController.clear();
        if (type != null) {
          _loadRecipeType(type.toLowerCase());
        }
      },
    );
  }

  _loadRecipeType(String type) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (type == "breakfast") {
        _spoonCularProvider?.recipiesWithDiet(context,
            prefrenceList: _authProvider!.userdata?.data?.breakfastPrerence);
      } else if (type == "lunch") {
        _spoonCularProvider?.recipiesWithDiet(context,
            prefrenceList: _authProvider!.userdata?.data?.lunchPrerence);
      } else {
        _spoonCularProvider?.recipiesWithDiet(context,
            prefrenceList: _authProvider?.userdata?.data?.dinnerPrerence);
      }
    });
  }

  SpoonCularProvider? _spoonCularProvider;
  AuthProvider? _authProvider;

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _spoonCularProvider = context.read<SpoonCularProvider>();
    _authProvider = context.read<AuthProvider>();
    return Scaffold(
      // extendBody: true,
      bottomNavigationBar: widget.hideButton
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: PrimaryButton(
                  text: 'View Nearby Restaurant',
                  onTap: () {
                    AppNavigator.push(context, const NearbyRestrauntScreen());
                  }),
            ),
      appBar: AppStyles.pinkAppBar(
        context,
        "Preferred Recipes",
      ),
      body: Consumer<SpoonCularProvider>(builder: (context, val, _) {
        if (val.recipesWithDietState == States.success) {
          return LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleChildScrollView(
                  child: SizedBox(
                height: constraints.maxHeight,
                child: val.getSpooncularRecipesWithDiet?.results != null &&
                        val.getSpooncularRecipesWithDiet!.results!.isEmpty
                    ? Column(
                        children: [
                          _foodPrefrenceDropdown(),
                          const Center(
                            child: CustomText(
                              text:
                                  'No Data Found \n Please Change Food Prefrences\n from my profile.',
                              lineSpacing: 2,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: AppColor.THEME_COLOR_PRIMARY1
                                      .withOpacity(0.2),
                                  offset: const Offset(1, 2),
                                  blurRadius: 10)
                            ]),
                            child: PrimaryTextField(
                                borderColor: Colors.grey.shade300,
                                hintText: "Search here...",
                                hasPrefix: true,
                                prefixIconPath: AssetPath.SEARCH,
                                prefixColor: Colors.grey.shade600,
                                hintColor: Colors.grey.shade600,
                                controller: searchController),
                          ),
                          AppStyles.height12SizedBox(),
                          _foodPrefrenceDropdown(),
                          AppStyles.height12SizedBox(),
                          val.isSearching
                              ? val.isSearching &&
                                      val.filteredRecipiesPref.isEmpty
                                  ? const Expanded(
                                      child: Center(
                                        child: CustomText(
                                          text: 'No Results Found',
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: GridView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 50),
                                          itemCount:
                                              val.filteredRecipiesPref.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 2.2,
                                                  crossAxisCount: 2,
                                                  mainAxisExtent: 200,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 20),
                                          itemBuilder: (context, index) {
                                            final recipie =
                                                val.filteredRecipiesPref[index];
                                            return GestureDetector(
                                              onTap: () {
                                                AppNavigator.push(
                                                    context,
                                                    SpoonCularRecipieDetailsScreen(
                                                      recipieByID: recipie?.id
                                                          .toString(),
                                                    ));
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                        vertical: 2),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                    color: AppColor.COLOR_WHITE,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset:
                                                            const Offset(2, 2),
                                                        color: AppColor
                                                            .COLOR_GREEN1
                                                            .withOpacity(.2),
                                                      )
                                                    ]),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              image: recipie?.image != null
                                                                  ? DecorationImage(
                                                                      fit: BoxFit.cover,
                                                                      image: ExtendedNetworkImageProvider(
                                                                        recipie!
                                                                            .image!,
                                                                      ))
                                                                  : null),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    CustomText(
                                                      textAlign:
                                                          TextAlign.start,
                                                      text: recipie?.title,
                                                      weight: FontWeight.bold,
                                                      maxLines: 1,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                              : Expanded(
                                  child: GridView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      itemCount: val
                                              .getSpooncularRecipesWithDiet
                                              ?.results
                                              ?.length ??
                                          0,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 2.2,
                                              crossAxisCount: 2,
                                              mainAxisExtent: 200,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 20),
                                      itemBuilder: (context, index) {
                                        final recipie = val
                                            .getSpooncularRecipesWithDiet
                                            ?.results?[index];
                                        return GestureDetector(
                                          onTap: () {
                                            AppNavigator.push(
                                                context,
                                                SpoonCularRecipieDetailsScreen(
                                                  recipieByID:
                                                      recipie?.id.toString(),
                                                ));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 2),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: AppColor.COLOR_WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(2, 2),
                                                    color: AppColor.COLOR_GREEN1
                                                        .withOpacity(.2),
                                                  )
                                                ]),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          image: recipie
                                                                      ?.image !=
                                                                  null
                                                              ? DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      ExtendedNetworkImageProvider(
                                                                    recipie!
                                                                        .image!,
                                                                  ))
                                                              : null),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                CustomText(
                                                  textAlign: TextAlign.start,
                                                  text: recipie?.title,
                                                  weight: FontWeight.bold,
                                                  maxLines: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                        ],
                      ),
              )),
            );
          });
        } else if (val.recipesWithDietState == States.loading) {
          return const CustomLoadingBarWidget();
        } else if (val.recipesWithDietState == States.failure) {
          return const Center(
            child: CustomText(
              text: 'No Data Found',
              fontColor: AppColor.COLOR_BLACK,
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }
}

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
  // int _groupValue = -1;
  @override
  void initState() {
    selectedPrefrence = AppConfig.recipePrefrnces.first;

    context.read<SpoonCularProvider>().initSearching();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // context.read<SpoonCularProvider>().recipiesWithDiet(
    //     StaticData.navigatorKey.currentContext!,
    //     prefrenceList:
    //         context.read<AuthProvider>().userdata?.data?.breakfastPrerence);

    _loadRecipeType("breakfast");
    print("RECIPE TYPE" +
        context.read<SpoonCularProvider>().getRecipeType.toString());

    // });

    searchController.addListener(() {
      if (_spoonCularProvider!.getRecipeType == 0) {
        _spoonCularProvider!.updateSearchPrefRecipies(searchController.text);
      } else {
        _spoonCularProvider!.updateSearchAdminRecipies(searchController.text);
      }
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

        if (_spoonCularProvider!.recipeType == 0) {
          if (type != null) {
            _loadRecipeType(type.toLowerCase());
          }
        } else {
          _spoonCularProvider!.getAdminRecipe(context,
              showLoader: true, prefsType: selectedPrefrence ?? "Breakfast");
        }
      },
    );
  }

  // Widget _foodPrefrenceDropdown() {
  //   return CustomDropDown2(
  //     dropDownData: AppConfig.recipePrefrnces,
  //     hintText: "Qualifications",
  //     dropdownValue: selectedPrefrence,
  //     contentPadding: EdgeInsets.symmetric(vertical: 16),
  //     prefix: SizedBox(width: 5),
  //     dropDownWidth: 0.914,
  //     offset: const Offset(-5, -25),
  //     horizontalPadding: 0,
  //     buttonPadding: 7,
  //     borderColor: AppColor.TRANSPARENT_COLOR,
  //     validator: (value) => (value == null || value.isEmpty)
  //         ? '${"Qualifications"} can\'t be empty.'
  //         : null,
  //     onChanged: (type) {
  //       // setState(() {
  //       // authController.selectedStyle1Value = value;
  //       // });
  //       setState(() {
  //         selectedPrefrence = type;
  //       });

  //       searchController.clear();

  //       if (_spoonCularProvider!.recipeType == 0) {
  //         if (type != null) {
  //           _loadRecipeType(type.toLowerCase());
  //         }
  //       } else {
  //         _spoonCularProvider!.getAdminRecipe(context,
  //             showLoader: true, prefsType: selectedPrefrence ?? "Breakfast");
  //       }
  //     },
  //   );
  // }

  _loadRecipeType(String type) {
    print("TYPE " + type);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (type == "breakfast") {
        print('SPOONCULAR LOAD KRO');
        _spoonCularProvider?.recipiesWithDiet(context,
            prefrenceList: _authProvider!.userdata?.data?.breakfastPrerence,
            showLoader: false);
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
    _authProvider = context.watch<AuthProvider>();
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
        // if (val.recipesWithDietState == States.success ||
        //     val.getAdminRecipiesLoadState == States.success) {

        // // else
        if (val.recipesWithDietState == States.loading) {
          return const CustomLoadingBarWidget();
        }

        // else

        // if (val.recipesWithDietState == States.failure) {
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     child: Column(
        //       children: [
        //         const SizedBox(
        //           height: 15,
        //         ),
        //         _textFiled(),
        //         const SizedBox(
        //           height: 8,
        //         ),
        //         _foodPrefrenceDropdown(),
        //         const SizedBox(
        //           height: 8,
        //         ),
        //         const Center(
        //           child: CustomText(
        //             text:
        //                 'No Data Found \n Please check Food Prefrences\n from my profile. ',
        //             fontColor: AppColor.COLOR_BLACK,
        //             lineSpacing: 2,
        //           ),
        //         ),
        //       ],
        //     ),
        //   );
        // }

        return LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: RefreshIndicator(
              onRefresh: () async {
                _loadRecipeType(selectedPrefrence!.toLowerCase());
                print(selectedPrefrence!.toLowerCase());
              },
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  _textFiled(),
                  AppStyles.height12SizedBox(),
                  SizedBox(
                    height: constraints.maxHeight,
                    child: val.getSpooncularRecipesWithDiet?.results != null &&
                            val.getSpooncularRecipesWithDiet!.results!
                                .isEmpty &&
                            val.recipeType == 0
                        ? Column(
                            children: [
                              _foodPrefrenceDropdown(),
                              const Center(
                                child: CustomText(
                                  text:
                                      'No Data Found \n Please check Food Prefrences\n from my profile.',
                                  lineSpacing: 2,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _foodPrefrenceDropdown(),
                              AppStyles.height12SizedBox(),
                              val.isSearching
                                  ? _spoonCularProvider!.getRecipeType == 0
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
                                                      const EdgeInsets.only(
                                                          bottom: 50),
                                                  itemCount: val
                                                      .filteredRecipiesPref
                                                      .length,
                                                  // itemCount: 2,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 2.2,
                                                          crossAxisCount: 2,
                                                          mainAxisExtent: 210,
                                                          mainAxisSpacing: 10,
                                                          crossAxisSpacing: 10),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final recipie =
                                                        val.filteredRecipiesPref[
                                                            index];
                                                    return val
                                                            .filteredRecipiesPref
                                                            .isNotEmpty
                                                        ? Column(
                                                            children: [
                                                              _foodPrefrenceDropdown(),
                                                              const Center(
                                                                child:
                                                                    CustomText(
                                                                  text:
                                                                      'No Data Found \n Please check Food Prefrences\n from my profile.',
                                                                  lineSpacing:
                                                                      2,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(
                                                            height: 100,
                                                            color: Colors.amber,
                                                          );
                                                    // GestureDetector(
                                                    //     onTap: () {
                                                    //       AppNavigator.push(
                                                    //           context,
                                                    //           SpoonCularRecipieDetailsScreen(
                                                    //             recipieByID: recipie
                                                    //                 ?.id
                                                    //                 .toString(),
                                                    //           ));
                                                    //     },
                                                    //     child: Container(
                                                    //       margin:
                                                    //           const EdgeInsets
                                                    //                   .symmetric(
                                                    //               horizontal: 2,
                                                    //               vertical: 2),
                                                    //       padding:
                                                    //           const EdgeInsets
                                                    //               .all(12),
                                                    //       decoration: BoxDecoration(
                                                    //           color: AppColor
                                                    //               .COLOR_WHITE,
                                                    //           borderRadius:
                                                    //               BorderRadius
                                                    //                   .circular(
                                                    //                       12),
                                                    //           boxShadow: [
                                                    //             BoxShadow(
                                                    //               offset:
                                                    //                   const Offset(
                                                    //                       2, 2),
                                                    //               color: AppColor
                                                    //                   .COLOR_GREEN1
                                                    //                   .withOpacity(
                                                    //                       .2),
                                                    //             )
                                                    //           ]),
                                                    //       child: Column(
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment
                                                    //                 .start,
                                                    //         children: [
                                                    //           Expanded(
                                                    //             child:
                                                    //                 ClipRRect(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(
                                                    //                           12),
                                                    //               child:
                                                    //                   Container(
                                                    //                 decoration: BoxDecoration(
                                                    //                     image: recipie?.image != null
                                                    //                         ? DecorationImage(
                                                    //                             fit: BoxFit.cover,
                                                    //                             image: ExtendedNetworkImageProvider(
                                                    //                               recipie!.image!,
                                                    //                             ))
                                                    //                         : null),
                                                    //               ),
                                                    //             ),
                                                    //           ),
                                                    //           const SizedBox(
                                                    //             height: 12,
                                                    //           ),
                                                    //           CustomText(
                                                    //             textAlign:
                                                    //                 TextAlign
                                                    //                     .start,
                                                    //             text:
                                                    //                 "${recipie?.title}",
                                                    //             weight:
                                                    //                 FontWeight
                                                    //                     .bold,
                                                    //             lineSpacing:
                                                    //                 1.2,
                                                    //             maxLines: 2,
                                                    //           )
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   );
                                                  }),
                                            )
                                      : val.filteredAdminRecipes.isEmpty
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
                                                      const EdgeInsets.only(
                                                    bottom: 50,
                                                  ),
                                                  itemCount: val
                                                      .filteredAdminRecipes
                                                      .length,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 2.2,
                                                          crossAxisCount: 2,
                                                          mainAxisExtent: 210,
                                                          mainAxisSpacing: 10,
                                                          crossAxisSpacing: 10),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final recipie =
                                                        val.filteredAdminRecipes[
                                                            index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        // AppNavigator.push(
                                                        //     context,
                                                        //     SpoonCularRecipieDetailsScreen(
                                                        //       recipieByID: recipie
                                                        //           ?.id
                                                        //           .toString(),
                                                        //     ));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 2,
                                                            vertical: 2),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        decoration: BoxDecoration(
                                                            color: AppColor
                                                                .COLOR_WHITE,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        2, 2),
                                                                color: AppColor
                                                                    .COLOR_GREEN1
                                                                    .withOpacity(
                                                                        .2),
                                                              )
                                                            ]),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      image: recipie.recipeImages.isNotEmpty
                                                                          ? DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: ExtendedNetworkImageProvider(
                                                                                "https://webservices.menuminderusa.com:3000/${recipie.recipeImages.first}",
                                                                              ))
                                                                          : const DecorationImage(
                                                                              image: AssetImage(
                                                                              AssetPath.PHOTO_PLACE_HOLDER,
                                                                            ))),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            CustomText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text:
                                                                  recipie.title,
                                                              weight: FontWeight
                                                                  .bold,
                                                              lineSpacing: 1.2,
                                                              maxLines: 2,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                    // return Container(
                                                    //   height: 100,
                                                    //   color: Colors.amber,
                                                    // );
                                                  }),
                                            )
                                  :
                                  //Spooncular (lunch & Dinner)
                                  _spoonCularProvider!.recipeType == 0
                                      ? Expanded(
                                          child: (val.getSpooncularRecipesWithDiet
                                                          ?.results?.length ??
                                                      0) ==
                                                  0
                                              ? const Center(
                                                  child: CustomText(
                                                    text:
                                                        'No Data Found \n Please check Food Prefrences\n from my profile.',
                                                    maxLines: 3,
                                                    lineSpacing: 2,
                                                  ),
                                                )
                                              : GridView.builder(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 50,
                                                  ),
                                                  itemCount: val
                                                          .getSpooncularRecipesWithDiet
                                                          ?.results
                                                          ?.length ??
                                                      0,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 2.2,
                                                          crossAxisCount: 2,
                                                          mainAxisExtent: 210,
                                                          mainAxisSpacing: 10,
                                                          crossAxisSpacing: 10),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final recipie = val
                                                        .getSpooncularRecipesWithDiet
                                                        ?.results?[index];

                                                    return GestureDetector(
                                                      onTap: () {
                                                        AppNavigator.push(
                                                            context,
                                                            SpoonCularRecipieDetailsScreen(
                                                              recipieByID: recipie
                                                                  ?.id
                                                                  .toString(),
                                                            ));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 2,
                                                            vertical: 2),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        decoration: BoxDecoration(
                                                            color: AppColor
                                                                .COLOR_WHITE,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        2, 2),
                                                                color: AppColor
                                                                    .COLOR_GREEN1
                                                                    .withOpacity(
                                                                        .2),
                                                              )
                                                            ]),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      image: recipie?.image != null
                                                                          ? DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: ExtendedNetworkImageProvider(
                                                                                recipie!.image!,
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
                                                                  TextAlign
                                                                      .start,
                                                              text: recipie
                                                                  ?.title,
                                                              weight: FontWeight
                                                                  .bold,
                                                              lineSpacing: 1.2,
                                                              maxLines: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                        )
                                      :
                                      //admin proper
                                      val.getAdminRecipiesLoadState ==
                                              States.loading
                                          ? const CustomLoadingBarWidget()
                                          : Expanded(
                                              child: GridView.builder(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 50),
                                                  itemCount: val.adminRecipes
                                                          .isNotEmpty
                                                      ? val.adminRecipes.length
                                                      : 0,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 2.2,
                                                          crossAxisCount: 2,
                                                          mainAxisExtent: 210,
                                                          mainAxisSpacing: 10,
                                                          crossAxisSpacing: 10),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final recipie =
                                                        val.adminRecipes[index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        AppNavigator.push(
                                                            context,
                                                            SpoonCularRecipieDetailsScreen(
                                                              adminRecipeData:
                                                                  recipie,
                                                            ));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 2,
                                                            vertical: 2),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        decoration: BoxDecoration(
                                                            color: AppColor
                                                                .COLOR_WHITE,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        2, 2),
                                                                color: AppColor
                                                                    .COLOR_GREEN1
                                                                    .withOpacity(
                                                                        .2),
                                                              )
                                                            ]),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      image: recipie.recipeImages.isNotEmpty
                                                                          ? DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: ExtendedNetworkImageProvider(
                                                                                "https://webservices.menuminderusa.com:3000/"
                                                                                "${recipie.recipeImages.first}",
                                                                              ))
                                                                          : const DecorationImage(
                                                                              image: AssetImage(
                                                                              AssetPath.PHOTO_PLACE_HOLDER,
                                                                            ))),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            CustomText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text:
                                                                  recipie.title,
                                                              weight: FontWeight
                                                                  .bold,
                                                              lineSpacing: 1.2,
                                                              maxLines: 2,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                              SizedBox(
                                height: 100,
                              )
                              // Column(
                              //   children: [
                              //     _foodPrefrenceDropdown(),
                              //     const Center(
                              //       child: CustomText(
                              //         text:
                              //             'No Data Found \n Please check Food Prefrences\n from my profile.',
                              //         lineSpacing: 2,
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                  ),
                ],
              )),
            ),
          );
        });
      }

          // // else
          //  if (val.recipesWithDietState == States.loading) {
          //   return const CustomLoadingBarWidget();
          // }

          // // else

          //  if (val.recipesWithDietState == States.failure) {
          //   return Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Column(
          //       children: [
          //         const SizedBox(
          //           height: 15,
          //         ),
          //         _foodPrefrenceDropdown(),
          //         const SizedBox(
          //           height: 8,
          //         ),
          //         const Center(
          //           child: CustomText(
          //             text:
          //                 'No Data Found \n Please check Food Prefrences\n from my profile. ',
          //             fontColor: AppColor.COLOR_BLACK,
          //             lineSpacing: 2,
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }
          // return Container(
          //   height: 100,
          //   color: Colors.amber,
          // );
          // }

          ),
    );
  }

  Container _textFiled() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: AppColor.THEME_COLOR_PRIMARY1.withOpacity(0.2),
            offset: const Offset(1, 2),
            blurRadius: 10)
      ]),
      child: PrimaryTextField(
        borderColor: Colors.grey.shade300,
        // fillColor: Colors.amber,
        hintText: "Search here...",
        hasPrefix: true,
        prefixIconPath: AssetPath.SEARCH,
        prefixColor: Colors.grey.shade600,
        hintColor: Colors.grey.shade600,
        controller: searchController,
        hasTrailingWidget: true,
        onTrailingTap: () async {
          print("tap on trail");
          await _modalBottomSheetMenu();
          // FocusScope.of(context).unfocus();
        },
        trailingWidget: AssetPath.FILTER_ICON,
      ),
    );
  }

  Future<void> _modalBottomSheetMenu() async {
    await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 150,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: <Widget>[
                    radioBtn("Recipes", 0, (val) async {
                      _spoonCularProvider!.recipeType = val;
                      // setState(() {
                      //   _groupValue = val!;
                      // });
                      Navigator.pop(context);
                      _loadRecipeType(
                          selectedPrefrence?.toLowerCase() ?? "breakfast");
                    }),
                    radioBtn("Premium Recipes By Chefs", 1, (val) async {
                      _spoonCularProvider!.recipeType = val;
                      // setState(() {
                      //   _groupValue = val!;
                      // });
                      Navigator.pop(context);
                      await context.read<SpoonCularProvider>().getAdminRecipe(
                          context,
                          showLoader: true,
                          prefsType:
                              selectedPrefrence?.toLowerCase() ?? "Breakfast");
                      // print(
                      //     "recipe type :: ${_spoonCularProvider!.getRecipeType}");
                    }),
                  ],
                )),
          );
        });
  }

  Widget radioBtn(String title, dynamic value, Function(dynamic) onChanged) {
    return RadioListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      groupValue: _spoonCularProvider!.getRecipeType,
      onChanged: onChanged,
      title: Text(title),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/food_container_widget.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/primary_textfield.dart';
import 'package:menu_minder/providers/spooncular_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/view/nearby_restraunt/screens/nearby_screen.dart';
import 'package:menu_minder/view/spooncular/spooncular_views/spooncular_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/styles.dart';

class RandomRecipiesScreen extends StatefulWidget {
  const RandomRecipiesScreen({super.key, this.hideButton = false});
  final bool hideButton;
  @override
  State<RandomRecipiesScreen> createState() => _RandomRecipiesScreenState();
}

class _RandomRecipiesScreenState extends State<RandomRecipiesScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    context.read<SpoonCularProvider>().initSearching();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SpoonCularProvider>().getAllRandomReceipes(context);
    });
    searchController.addListener(() {
      context.read<SpoonCularProvider>().updateSearch(searchController.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        searchController.clear();
        context.read<SpoonCularProvider>().initSearching();
        context.read<SpoonCularProvider>().filteredRecipies.clear();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColor.BG_COLOR,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: widget.hideButton
            ? const SizedBox()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: PrimaryButton(
                    text: 'View Nearby Restaurant',
                    onTap: () {
                      AppNavigator.push(context, const NearbyRestrauntScreen());
                    }),
              ),
        appBar: AppStyles.pinkAppBar(
          context,
          "Food Recipes",
          onleadingTap: () {
            searchController.clear();
            context.read<SpoonCularProvider>().initSearching();
            context.read<SpoonCularProvider>().filteredRecipies.clear();
            AppNavigator.pop(context);
          },
        ),
        body: Consumer<SpoonCularProvider>(builder: (context, val, _) {
          if (val.getRandomRecipiesLoadState == States.loading) {
            return const CustomLoadingBarWidget();
          } else if (val.getRandomRecipiesLoadState == States.failure) {
            return const Center(
                child: CustomText(
              text: 'No Data Found',
            ));
          }
          return SafeArea(
            child: Padding(
              padding: AppStyles.screenPadding(),
              child: Column(
                children: [
                  // TextField(),
                  // AppStyles.height20SizedBox(height: size.height * .02),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: AppColor.THEME_COLOR_PRIMARY1.withOpacity(0.2),
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
                  // Container(
                  //   height: 150,
                  //   color: Colors.red,
                  // ),
                  AppStyles.height20SizedBox(),

                  val.isSearching
                      ? Expanded(
                          child: val.isSearching && val.filteredRecipies.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: CustomText(
                                    text: 'No Recipes Found.',
                                  ),
                                )
                              : GridView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: val.filteredRecipies.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          crossAxisCount: 2,
                                          childAspectRatio: 3 / 3.5),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = val.filteredRecipies[index];
                                    return FoodContainerSpoonCular(
                                        recipeModel: item,
                                        onTap: () {
                                          AppNavigator.push(
                                              context,
                                              SpoonCularRecipieDetailsScreen(
                                                // mealData: item,
                                                recipieByID:
                                                    item!.id.toString(),

                                                // recipieByID:
                                                //     item!.id.toString(),
                                              ));
                                        },
                                        index: index);
                                  },
                                ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount:
                                val.getRandomRecipies?.recipes?.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 3.5),
                            itemBuilder: (BuildContext context, int index) {
                              final item =
                                  val.getRandomRecipies?.recipes?[index];
                              return FoodContainerSpoonCular(
                                  recipeModel: item,
                                  onTap: () {
                                    AppNavigator.push(
                                        context,
                                        SpoonCularRecipieDetailsScreen(
                                          // mealData: item,
                                          recipieByID: item!.id.toString(),
                                        ));
                                  },
                                  index: index);
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

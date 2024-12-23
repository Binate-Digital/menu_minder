import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:menu_minder/common/custom_extended_image_with_loading.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_tabbar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/decision_container_widget.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/home/widgets/home_suggestions.dart';
import 'package:menu_minder/view/nearby_restraunt/screens/nearby_screen.dart';
import 'package:menu_minder/view/poll_results/screens/data/poll_result_data.dart';
import 'package:menu_minder/view/recipe_details/widgets/ingredients_tab_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/profile_with_name_and_desc_widget.dart';
import '../../../services/network/firebase_messaging_service.dart';
import '../../spooncular/spooncular_views/random_recipies_view.dart';

class PollResultScreen extends StatefulWidget {
  const PollResultScreen({
    super.key,
    this.pollID,
  });
  final String? pollID;

  @override
  State<PollResultScreen> createState() => _PollResultScreenState();
}

class _PollResultScreenState extends State<PollResultScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  CoreProvider? _coreProvider;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.pollID != null) {
        context.read<CoreProvider>().getPoleResults(context, widget.pollID!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _coreProvider = context.watch<CoreProvider>();
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
        child: PrimaryButton(
            // text: "View Nearby Restaurant",
            text: "View Random Recipes",
            onTap: () {
              AppNavigator.push(context, const RandomRecipiesScreen());
              // AppNavigator.push(context, const NearbyRestrauntScreen());
            }),
      ),
      appBar: AppStyles.pinkAppBar(context, "Poll Results"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: SingleChildScrollView(
          child:
          Consumer<CoreProvider>(builder: (context, val, _) {
            if (val.getPollResultState == States.loading) {
              return const CustomLoadingBarWidget();
            } else if (val.getPollResultState == States.success) {
              return
               val.singlePoleResult!.data![0].button![0].voters!.isEmpty ?

                Column(
                children: [
                  ...List.generate(
                    val.singlePoleResult?.data?[0].button?.length ?? 0,
                    (index) => AgreedPolls(
                      heading:
                          val.singlePoleResult?.data?[0].button?[index].text ??
                              '',
                      quantity: val.singlePoleResult?.data?[0].button?[index]
                              .voters?.length ??
                          0,
                      button: val.singlePoleResult?.data?[0].button![index],
                    ),
                  ),
                ],
              )
                    :
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: val.singlePoleResult?.data?[0].button?[0].voters?[0].finalRecipe != null
                          ? GestureDetector(
                        onTap: (){
                          log('tap image ${val.singlePoleResult!.data?[0].button?[0].text}');
                        },
                            child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: MyCustomExtendedImage(
                              imageUrl: val.singlePoleResult!.data![0].button![0].voters![0].finalRecipe!.image
                              !.startsWith('http')
                                  ? val.singlePoleResult!.data![0].button![0].voters![0].finalRecipe!.image ?? ''
                                  : '${dotenv.get('IMAGE_URL')}${val.singlePoleResult!.data?[0].button![0].voters![0].finalRecipe!.image}'
                        ),
                      ),
                          )
                          : Center(
                        child: Image.asset(
                          AssetPath.PHOTO_PLACE_HOLDER,
                          fit: BoxFit.cover,
                          scale: 2,
                        ),
                      ),
                    ),
                    AppStyles.height12SizedBox(width: 10, height: 0),
                    Expanded(
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: val.singlePoleResult!.data?[0].button?[0].voters?[0].finalRecipe?.title ?? '',
                          maxLines: 3,
                          weight: FontWeight.w500,
                        ))
                  ],
                ),
                const SizedBox(height: 14),
                val.singlePoleResult!.data?[0].button?[0].text?.toLowerCase() == 'disagree'
                    ?
                _getCurrentSuggestionStatus(
                    context: context,
                    suggesstionStatus:
                    val.singlePoleResult!.data?[0].button?[0].voters?[0].suggestionStatus ?? '',
                    voters:  val.singlePoleResult!.data![0].button![0].voters![0] ,
                    recipe:  val.singlePoleResult!.data![0].button![0].voters![0].finalRecipe! ,
                )
                    : SizedBox(),
                const SizedBox(height: 14),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColor.CONTAINER_GREY,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppStyles.subHeadingStyle('Description',
                          fontWeight: FontWeight.normal),
                      AppStyles.height4SizedBox(),
                      HtmlWidget(  val.singlePoleResult?.data?[0].button![0].voters![0]
                          .finalRecipe!.summary ??
                          ''),
                      const SizedBox(
                        height: 10,
                      ),
                      // widget.mealData?.servingSize != null
                      //     ? AppStyles.contentStyle(
                      //     'Serving Size: ${widget.mealData?.servingSize} Persons',
                      //     fontSize: 15)
                      //     : const SizedBox(),
                      // widget.mealData?.prefrence != null
                      //     ? AppStyles.contentStyle(
                      //     'Recipe Prefrence: ${widget.mealData?.prefrence?.capitalizeFirstLetter()}',
                      //     fontSize: 15)
                      //     : const SizedBox()
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
                          ingredients:     val.singlePoleResult?.data?[0].button![0].voters![0].finalRecipe!.extendedIngredients,
                          isSuggestion: true,
                        ),
                        HtmlWidget(
                          //  instructions:
                          val.singlePoleResult?.data?[0].button![0].voters![0]
                              .finalRecipe!.instructions ??
                              "",
                        )
                      ]),
                ),

              ]);
            } else if (val.getPollResultState == States.failure) {
              return const Center(
                child: CustomText(
                  text: 'No Data Found',
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
        ),
      ),
    );
  }
  Widget _getCurrentSuggestionStatus({
    required BuildContext context,
    required String suggesstionStatus,
    required Voters voters,
    required FinalRecipe recipe,
  }) {
    switch (suggesstionStatus) {
      case 'pending':
        return
          // voters.suggestion != null
          //   ?
        InkWell(
          onTap: () {
            AppDialog.showDialogs(
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 48),
                      child: AppStyles.headingStyle(
                          recipe.title ?? '',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                              text: "Reject",
                              buttonColor: AppColor.THEME_COLOR_PRIMARY1,
                              onTap: () {
                                _loadMutualRecipies(context, voters);
                                // AppNavigator.pop(
                                //     context);
                              }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: PrimaryButton(
                              text: "Accept",
                              buttonColor: AppColor.THEME_COLOR_SECONDARY,
                              onTap: () {
                                context
                                    .read<CoreProvider>()
                                    .acceptRejectSuggestion(
                                  context,
                                  voters,
                                  suggestionStatus: "accept",
                                  onSuccess: () {
                                    AppNavigator.pop(context);
                                  },
                                );
                                // AppNavigator.pop(
                                //     context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                "Suggestion",
                context,
                hasBack: true);
          },
          child: const CustomText(
            fontSize: 12,
            underlined: true,
            text: 'View Suggestion',
            fontColor: AppColor.THEME_COLOR_PRIMARY1,
          ),
        );
         //   : SizedBox();
    // : SizedBox();

      case 'accept':
        return InkWell(
          onTap: () {
            AppDialog.showDialogs(
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 48),
                        child: Column(
                          children: [
                            AppStyles.headingStyle('User Suggestion',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                color: AppColor.THEME_COLOR_SECONDARY),
                            AppStyles.headingStyle(
                              voters.suggestion ?? '',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 20.0, horizontal: 48),
                    //     child: Column(
                    //       children: [
                    //         AppStyles.headingStyle('My Suggestion',
                    //             textAlign: TextAlign.center,
                    //             fontWeight: FontWeight.bod,
                    //             color: AppColor.THEME_COLOR_SECONDARY),
                    //         AppStyles.headingStyle(
                    //             voters.anotherSuggestion ?? '',
                    //             textAlign: TextAlign.center,
                    //             fontWeight: FontWeight.w400),
                    //       ],
                    //     )),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                              text: "Continue",
                              buttonColor: AppColor.THEME_COLOR_SECONDARY,
                              onTap: () {
                                AppNavigator.pop(context);
                                // AppNavigator.pop(
                                //     context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                "Ultimate Poll Recipe",
                context,
                hasBack: true);
          },
          child: const CustomText(
            fontSize: 12,
            underlined: true,
            text: 'View Suggestion',
            fontColor: AppColor.THEME_COLOR_PRIMARY1,
          ),
        );

      case 'reject':
        return InkWell(
          onTap: () {
            AppDialog.showDialogs(
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 48),
                        child: Column(
                          children: [
                            AppStyles.headingStyle('User Suggestion',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                color: AppColor.THEME_COLOR_SECONDARY),
                            AppStyles.headingStyle(
                              voters.suggestion ?? '',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 48),
                        child: Column(
                          children: [
                            AppStyles.headingStyle('My Suggestion',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                color: AppColor.THEME_COLOR_SECONDARY),
                            AppStyles.headingStyle(
                                voters.anotherSuggestion ?? '',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w400),
                          ],
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                              text: "Continue",
                              buttonColor: AppColor.THEME_COLOR_SECONDARY,
                              onTap: () {
                                AppNavigator.pop(context);
                                // AppNavigator.pop(
                                //     context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                "Ultimate Poll Recipe",
                context,
                hasBack: true);
          },
          child: const CustomText(
            fontSize: 12,
            underlined: true,
            text: 'View Suggestion',
            fontColor: AppColor.THEME_COLOR_PRIMARY1,
          ),
        );
    }

    return const SizedBox();
  }

  _loadMutualRecipies(BuildContext context, Voters voters) {
    context.read<CoreProvider>().loadMutualRecipes(
      StaticData.navigatorKey.currentContext!,
      voters.userId!,
      voters.poleId!,
      onSuccess: () async {
        await Future.delayed(const Duration(milliseconds: 400));

        if (_coreProvider?.mutualRecipes?.data != null &&
            _coreProvider!.mutualRecipes!.data!.isNotEmpty) {
          AppDialog.showDialogs(
              HomeSuggestions(
                onDeclineTap: () {
                  // context.read<CoreProvider>().giveVote(
                  //   context,
                  //   receipieName: null,
                  //   buttonID: polvote.button![index].sId!,
                  //   pollID: polvote.sId!,
                  //   buttonData: polvote.button![index],
                  //   onSuccess: () {
                  //     AppNavigator.pop(context);

                  //     Future.delayed(const Duration(milliseconds: 50), () {
                  //       AppNavigator.push(
                  //           context, const NearbyRestrauntScreen());
                  //     });

                  //     // if (e.text!
                  //     //         .toLowerCase() ==
                  //     //     'disagree') {
                  //     //   AppDialog.showDialogs(
                  //     //       SuggestionListWidget(),
                  //     //       'Suggestions',
                  //     //       context);
                  //   },
                  // );

                  AppNavigator.pop(context);
                },
                onTap: (recipieID) {
                  // context.read<CoreProvider>().giveVote(
                  //   StaticData.navigatorKey.currentContext!,
                  //   receipieName: recipieID,
                  //   buttonID: polvote.button![index].sId!,
                  //   pollID: polvote.sId!,
                  //   buttonData: polvote.button![index],
                  //   onSuccess: () {
                  //     AppNavigator.pop(context);
                  //     // if (e.text!
                  //     //         .toLowerCase() ==
                  //     //     'disagree') {
                  //     //   AppDialog.showDialogs(
                  //     //       SuggestionListWidget(),
                  //     //       'Suggestions',
                  //     //       context);
                  //   },
                  // );

                  print(recipieID);

                  // AppNavigator.pop(context);

                  _coreProvider!.acceptRejectSuggestion(
                    StaticData.navigatorKey.currentContext!,
                    voters,
                    suggestionStatus: "reject",
                    another_suggestion: recipieID,
                    onSuccess: () {
                      AppNavigator.pop(context);
                      AppNavigator.pop(context);
                    },
                  );
                },
              ),
              'Suggestions',
              StaticData.navigatorKey.currentContext!,
              hasBack: true);
        } else {
          Future.delayed(const Duration(milliseconds: 50), () async {
            final String? restaurantNAme =
            await AppNavigator.pushReplacementAndReturn(
                context,
                const NearbyRestrauntScreen(
                  showDoneButtom: true,
                ));

            if (restaurantNAme != null) {
              _coreProvider!.acceptRejectSuggestion(
                StaticData.navigatorKey.currentContext!,
                voters,
                suggestionStatus: "reject",
                another_suggestion: restaurantNAme,
                onSuccess: () {
                  AppNavigator.pop(context);
                },
              );
            }
          });

          /// AGAR KOII MUTUALLY SHARED NHII HAI
          ///
          // ignore: use_build_context_synchronously
          // context.read<SpoonCularProvider>().recipiesWithDiet(
          //   context,
          //   showLoader: true,
          //   onSuccess: () {
          //     // AppNavigator.pop(context);
          //     if (context
          //                 .read<SpoonCularProvider>()
          //                 .getSpooncularRecipesWithDiet !=
          //             null &&
          //         context
          //             .read<SpoonCularProvider>()
          //             .getSpooncularRecipesWithDiet!
          //             .results!
          //             .isNotEmpty) {
          //       AppDialog.showDialogs(
          //           HomeSuggestionsSpoonCularWithPrefs(
          //             onDeclineTap: () {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: null,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   Future.delayed(const Duration(milliseconds: 50),
          //                       () {
          //                     AppNavigator.push(
          //                         context, const NearbyRestrauntScreen());
          //                   });
          //                 },
          //               );
          //             },
          //             onTap: (recipieID) {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: recipieID,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   // if (e.text!
          //                   //         .toLowerCase() ==
          //                   //     'disagree') {
          //                   //   AppDialog.showDialogs(
          //                   //       SuggestionListWidget(),
          //                   //       'Suggestions',
          //                   //       context);
          //                 },
          //               );
          //             },
          //           ),
          //           'Suggestions',
          //           context,
          //           hasBack: true);
          //     } else {
          //       context
          //           .read<SpoonCularProvider>()
          //           .getAllRandomReceipes(context);

          //       AppDialog.showDialogs(
          //           HomeSuggestionsSpoonCular(
          //             onDeclineTap: () {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: null,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   Future.delayed(const Duration(milliseconds: 50),
          //                       () {
          //                     AppNavigator.push(
          //                         context, const NearbyRestrauntScreen());
          //                   });
          //                 },
          //               );
          //             },
          //             onTap: (recipieID) {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: recipieID,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   // if (e.text!
          //                   //         .toLowerCase() ==
          //                   //     'disagree') {
          //                   //   AppDialog.showDialogs(
          //                   //       SuggestionListWidget(),
          //                   //       'Suggestions',
          //                   //       context);
          //                 },
          //               );
          //             },
          //           ),
          //           'Suggestions',
          //           context,
          //           hasBack: true);
          //     }
          //   },
          // );
        }
      },
    );
  }
}

class AgreedPolls extends StatelessWidget {
  final String heading;
  final int quantity;
  final PollButton? button;

  AgreedPolls({
    super.key,
    required this.heading,
    required this.quantity,
    this.button,
  });

  CoreProvider? _coreProvider;

  @override
  Widget build(BuildContext context) {
    _coreProvider = context.watch<CoreProvider>();
    return DecisionContainer(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppStyles.subHeadingStyle(heading),
            Container(
              width: 80,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor.THEME_COLOR_PRIMARY1,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "$quantity votes",
                style: const TextStyle(color: AppColor.COLOR_WHITE),
              ),
            )
          ],
        ),
        AppStyles.horizontalDivider(),
        button!.voters!.isEmpty
            ? const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: CustomText(
                    text: 'No Voters ',
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: button?.voters?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    AppStyles.height8SizedBox(),
                itemBuilder: (context, index) {
                  final buttons = button!.voters![index];
                  // buttons.

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ProfileWithNameAndDescriptionWidget(
                              name: buttons.userData?.userName ?? 'No Name',
                              desc: "Family Member",
                              showDesc: false,
                            ),
                          ),

                          button?.text?.toLowerCase() == 'disagree'
                              ? _getCurrentSuggestionStatus(
                                  context: context,
                                  suggesstionStatus:
                                      buttons.suggestionStatus ?? '',
                                  voters: buttons)
                              : SizedBox(),

                          // buttons.suggestionStatus ==
                          //         SuggestionStatus.penxding.name
                          //     ? InkWell(
                          //         onTap: () {
                          //           AppDialog.showDialogs(
                          //               Column(
                          //                 children: [
                          //                   Padding(
                          //                     padding:
                          //                         const EdgeInsets.symmetric(
                          //                             vertical: 20.0,
                          //                             horizontal: 48),
                          //                     child: AppStyles.headingStyle(
                          //                         buttons.suggestion ?? '',
                          //                         textAlign: TextAlign.center,
                          //                         fontWeight: FontWeight.w400),
                          //                   ),
                          //                   Row(
                          //                     children: [
                          //                       Expanded(
                          //                         child: PrimaryButton(
                          //                             text: "Reject",
                          //                             buttonColor: AppColor
                          //                                 .THEME_COLOR_PRIMARY1,
                          //                             onTap: () {
                          //                               _loadMutualRecipies(
                          //                                   context, buttons);
                          //                               // AppNavigator.pop(
                          //                               //     context);
                          //                             }),
                          //                       ),
                          //                       const SizedBox(
                          //                         width: 10,
                          //                       ),
                          //                       Expanded(
                          //                         child: PrimaryButton(
                          //                             text: "Accept",
                          //                             buttonColor: AppColor
                          //                                 .THEME_COLOR_SECONDARY,
                          //                             onTap: () {
                          //                               context
                          //                                   .read<
                          //                                       CoreProvider>()
                          //                                   .acceptRejectSuggestion(
                          //                                 context,
                          //                                 buttons,
                          //                                 suggestionStatus:
                          //                                     "accept",
                          //                                 onSuccess: () {
                          //                                   AppNavigator.pop(
                          //                                       context);
                          //                                 },
                          //                               );
                          //                               // AppNavigator.pop(
                          //                               //     context);
                          //                             }),
                          //                       ),
                          //                     ],
                          //                   )
                          //                 ],
                          //               ),
                          //               "Suggestion",
                          //               context,
                          //               hasBack: true);
                          //         },
                          //         child: const CustomText(
                          //           fontSize: 12,
                          //           underlined: true,
                          //           text: 'View Suggestion',
                          //           fontColor: AppColor.THEME_COLOR_PRIMARY1,
                          //         ),
                          //       )
                          //     : SizedBox()

                          ////REJECT
                        ],
                      ),

                      // InkWell(
                      //   onTap: () {
                      //     AppDialog.showDialogs(
                      //         Column(
                      //           children: [
                      //             Column(
                      //               children: List.generate(
                      //                   3,
                      //                   (index) => InkWell(
                      //                         onTap: () {
                      //                           AppNavigator.pop(context);
                      //                         },
                      //                         child: Padding(
                      //                           padding:
                      //                               const EdgeInsets.only(bottom: 4.0),
                      //                           child: DecisionContainer(
                      //                               bgColor: Colors.grey.shade100,
                      //                               customPadding:
                      //                                   const EdgeInsets.symmetric(
                      //                                       vertical: 16,
                      //                                       horizontal: 8),
                      //                               containerColor: AppColor.COLOR_GREY1
                      //                                   .withOpacity(0.2),
                      //                               child: AppStyles.contentStyle(
                      //                                   LOREM_UTLRA_SMALL,
                      //                                   fontSize: 14)),
                      //                         ),
                      //                       )),
                      //             ),
                      //             AppStyles.height8SizedBox(),
                      //             PrimaryButton(
                      //                 text: "Continue",
                      //                 onTap: () {
                      //                   AppNavigator.pop(context);
                      //                 })
                      //           ],
                      //         ),
                      //         "Suggested Recipes",
                      //         context);
                      //   },
                      //   child: AppStyles.contentStyle("View Suggestion",
                      //       color: AppColor.THEME_COLOR_PRIMARY1,
                      //       textDecoration: TextDecoration.underline),
                      // )
                    ],
                  );
                })
      ],
    ));
  }

  Widget _getCurrentSuggestionStatus({
    required BuildContext context,
    required String suggesstionStatus,
    required Voters voters,
  }) {
    switch (suggesstionStatus) {
      case 'pending':
        return voters.suggestion != null
            ?
        InkWell(
                onTap: () {
                  AppDialog.showDialogs(
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 48),
                            child: AppStyles.headingStyle(
                                voters.suggestion ?? '',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w400),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                    text: "Reject",
                                    buttonColor: AppColor.THEME_COLOR_PRIMARY1,
                                    onTap: () {
                                      _loadMutualRecipies(context, voters);
                                      // AppNavigator.pop(
                                      //     context);
                                    }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: PrimaryButton(
                                    text: "Accept",
                                    buttonColor: AppColor.THEME_COLOR_SECONDARY,
                                    onTap: () {
                                      context
                                          .read<CoreProvider>()
                                          .acceptRejectSuggestion(
                                        context,
                                        voters,
                                        suggestionStatus: "accept",
                                        onSuccess: () {
                                          AppNavigator.pop(context);
                                        },
                                      );
                                      // AppNavigator.pop(
                                      //     context);
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                      "Suggestion",
                      context,
                      hasBack: true);
                },
                child: const CustomText(
                  fontSize: 12,
                  underlined: true,
                  text: 'View Suggestion',
                  fontColor: AppColor.THEME_COLOR_PRIMARY1,
                ),
              )
            : SizedBox();
      // : SizedBox();

      case 'accept':
        return InkWell(
          onTap: () {
            AppDialog.showDialogs(
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 48),
                        child: Column(
                          children: [
                            AppStyles.headingStyle('User Suggestion',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                color: AppColor.THEME_COLOR_SECONDARY),
                            AppStyles.headingStyle(
                              voters.suggestion ?? '',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )),
                    // Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 20.0, horizontal: 48),
                    //     child: Column(
                    //       children: [
                    //         AppStyles.headingStyle('My Suggestion',
                    //             textAlign: TextAlign.center,
                    //             fontWeight: FontWeight.bod,
                    //             color: AppColor.THEME_COLOR_SECONDARY),
                    //         AppStyles.headingStyle(
                    //             voters.anotherSuggestion ?? '',
                    //             textAlign: TextAlign.center,
                    //             fontWeight: FontWeight.w400),
                    //       ],
                    //     )),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                              text: "Continue",
                              buttonColor: AppColor.THEME_COLOR_SECONDARY,
                              onTap: () {
                                AppNavigator.pop(context);
                                // AppNavigator.pop(
                                //     context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                "Ultimate Poll Recipe",
                context,
                hasBack: true);
          },
          child: const CustomText(
            fontSize: 12,
            underlined: true,
            text: 'View Suggestion',
            fontColor: AppColor.THEME_COLOR_PRIMARY1,
          ),
        );

      case 'reject':
        return InkWell(
          onTap: () {
            AppDialog.showDialogs(
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 48),
                        child: Column(
                          children: [
                            AppStyles.headingStyle('User Suggestion',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                color: AppColor.THEME_COLOR_SECONDARY),
                            AppStyles.headingStyle(
                              voters.suggestion ?? '',
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 48),
                        child: Column(
                          children: [
                            AppStyles.headingStyle('My Suggestion',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                color: AppColor.THEME_COLOR_SECONDARY),
                            AppStyles.headingStyle(
                                voters.anotherSuggestion ?? '',
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w400),
                          ],
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                              text: "Continue",
                              buttonColor: AppColor.THEME_COLOR_SECONDARY,
                              onTap: () {
                                AppNavigator.pop(context);
                                // AppNavigator.pop(
                                //     context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
                "Ultimate Poll Recipe",
                context,
                hasBack: true);
          },
          child: const CustomText(
            fontSize: 12,
            underlined: true,
            text: 'View Suggestion',
            fontColor: AppColor.THEME_COLOR_PRIMARY1,
          ),
        );
    }

    return const SizedBox();
  }

  _loadMutualRecipies(BuildContext context, Voters voters) {
    context.read<CoreProvider>().loadMutualRecipes(
      StaticData.navigatorKey.currentContext!,
      voters.userId!,
      voters.poleId!,
      onSuccess: () async {
        await Future.delayed(const Duration(milliseconds: 400));

        if (_coreProvider?.mutualRecipes?.data != null &&
            _coreProvider!.mutualRecipes!.data!.isNotEmpty) {
          AppDialog.showDialogs(
              HomeSuggestions(
                onDeclineTap: () {
                  // context.read<CoreProvider>().giveVote(
                  //   context,
                  //   receipieName: null,
                  //   buttonID: polvote.button![index].sId!,
                  //   pollID: polvote.sId!,
                  //   buttonData: polvote.button![index],
                  //   onSuccess: () {
                  //     AppNavigator.pop(context);

                  //     Future.delayed(const Duration(milliseconds: 50), () {
                  //       AppNavigator.push(
                  //           context, const NearbyRestrauntScreen());
                  //     });

                  //     // if (e.text!
                  //     //         .toLowerCase() ==
                  //     //     'disagree') {
                  //     //   AppDialog.showDialogs(
                  //     //       SuggestionListWidget(),
                  //     //       'Suggestions',
                  //     //       context);
                  //   },
                  // );

                  AppNavigator.pop(context);
                },
                onTap: (recipieID) {
                  // context.read<CoreProvider>().giveVote(
                  //   StaticData.navigatorKey.currentContext!,
                  //   receipieName: recipieID,
                  //   buttonID: polvote.button![index].sId!,
                  //   pollID: polvote.sId!,
                  //   buttonData: polvote.button![index],
                  //   onSuccess: () {
                  //     AppNavigator.pop(context);
                  //     // if (e.text!
                  //     //         .toLowerCase() ==
                  //     //     'disagree') {
                  //     //   AppDialog.showDialogs(
                  //     //       SuggestionListWidget(),
                  //     //       'Suggestions',
                  //     //       context);
                  //   },
                  // );

                  print(recipieID);

                  // AppNavigator.pop(context);

                  _coreProvider!.acceptRejectSuggestion(
                    StaticData.navigatorKey.currentContext!,
                    voters,
                    suggestionStatus: "reject",
                    another_suggestion: recipieID,
                    onSuccess: () {
                      AppNavigator.pop(context);
                      AppNavigator.pop(context);
                    },
                  );
                },
              ),
              'Suggestions',
              StaticData.navigatorKey.currentContext!,
              hasBack: true);
        } else {
          Future.delayed(const Duration(milliseconds: 50), () async {
            final String? restaurantNAme =
                await AppNavigator.pushReplacementAndReturn(
                    context,
                    const NearbyRestrauntScreen(
                      showDoneButtom: true,
                    ));

            if (restaurantNAme != null) {
              _coreProvider!.acceptRejectSuggestion(
                StaticData.navigatorKey.currentContext!,
                voters,
                suggestionStatus: "reject",
                another_suggestion: restaurantNAme,
                onSuccess: () {
                  AppNavigator.pop(context);
                },
              );
            }
          });

          /// AGAR KOII MUTUALLY SHARED NHII HAI
          ///
          // ignore: use_build_context_synchronously
          // context.read<SpoonCularProvider>().recipiesWithDiet(
          //   context,
          //   showLoader: true,
          //   onSuccess: () {
          //     // AppNavigator.pop(context);
          //     if (context
          //                 .read<SpoonCularProvider>()
          //                 .getSpooncularRecipesWithDiet !=
          //             null &&
          //         context
          //             .read<SpoonCularProvider>()
          //             .getSpooncularRecipesWithDiet!
          //             .results!
          //             .isNotEmpty) {
          //       AppDialog.showDialogs(
          //           HomeSuggestionsSpoonCularWithPrefs(
          //             onDeclineTap: () {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: null,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   Future.delayed(const Duration(milliseconds: 50),
          //                       () {
          //                     AppNavigator.push(
          //                         context, const NearbyRestrauntScreen());
          //                   });
          //                 },
          //               );
          //             },
          //             onTap: (recipieID) {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: recipieID,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   // if (e.text!
          //                   //         .toLowerCase() ==
          //                   //     'disagree') {
          //                   //   AppDialog.showDialogs(
          //                   //       SuggestionListWidget(),
          //                   //       'Suggestions',
          //                   //       context);
          //                 },
          //               );
          //             },
          //           ),
          //           'Suggestions',
          //           context,
          //           hasBack: true);
          //     } else {
          //       context
          //           .read<SpoonCularProvider>()
          //           .getAllRandomReceipes(context);

          //       AppDialog.showDialogs(
          //           HomeSuggestionsSpoonCular(
          //             onDeclineTap: () {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: null,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   Future.delayed(const Duration(milliseconds: 50),
          //                       () {
          //                     AppNavigator.push(
          //                         context, const NearbyRestrauntScreen());
          //                   });
          //                 },
          //               );
          //             },
          //             onTap: (recipieID) {
          //               context.read<CoreProvider>().giveVote(
          //                 context,
          //                 receipieName: recipieID,
          //                 buttonID: polvote.button![index].sId!,
          //                 pollID: polvote.sId!,
          //                 buttonData: polvote.button![index],
          //                 onSuccess: () {
          //                   AppNavigator.pop(context);
          //                   // if (e.text!
          //                   //         .toLowerCase() ==
          //                   //     'disagree') {
          //                   //   AppDialog.showDialogs(
          //                   //       SuggestionListWidget(),
          //                   //       'Suggestions',
          //                   //       context);
          //                 },
          //               );
          //             },
          //           ),
          //           'Suggestions',
          //           context,
          //           hasBack: true);
          //     }
          //   },
          // );
        }
      },
    );
  }
}

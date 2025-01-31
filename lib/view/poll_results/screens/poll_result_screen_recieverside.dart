import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:menu_minder/common/custom_extended_image_with_loading.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_tabbar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/decision_container_widget.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/home/widgets/home_suggestions.dart';
import 'package:menu_minder/view/nearby_restraunt/screens/nearby_screen.dart';
import 'package:menu_minder/view/poll_results/screens/data/poll_result_data.dart';
import 'package:menu_minder/view/recipe_details/widgets/ingredients_tab_widget.dart';
import 'package:menu_minder/view/recipe_details/widgets/instructions_tab_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/profile_with_name_and_desc_widget.dart';
import '../../../services/network/firebase_messaging_service.dart';

class PollResultScreenRecieverSide extends StatefulWidget {
  const PollResultScreenRecieverSide({
    super.key,
    this.pollID,
  });
  final String? pollID;

  @override
  State<PollResultScreenRecieverSide> createState() =>
      _PollResultScreenRecieverSideState();
}

class _PollResultScreenRecieverSideState
    extends State<PollResultScreenRecieverSide> with TickerProviderStateMixin {
  TabController? _tabController;

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
    return Scaffold(
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
      //   child: PrimaryButton(
      //       // text: "View Nearby Restaurant",
      //       text: "View Random Recipes",
      //       onTap: () {
      //         AppNavigator.push(context, const RandomRecipiesScreen());
      //         // AppNavigator.push(context, const NearbyRestrauntScreen());
      //       }),
      // ),
      appBar: AppStyles.pinkAppBar(context, "Poll Results"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: SingleChildScrollView(
          child: Consumer<CoreProvider>(builder: (context, val, _) {
            if (val.getPollResultState == States.loading) {
              return const CustomLoadingBarWidget();
            } else if (val.getPollResultState == States.success) {
              final pollInfo = val.singlePoleResult?.data?[0];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: pollInfo?.button?[0].voters?[0].anotherSuggestion ==
                            null
                        ? 'Poll Info'
                        : "Poll Concluded",
                    weight: FontWeight.bold,
                  ),
                  AppStyles.height12SizedBox(),
                  pollInfo?.button?[0].voters?[0].finalRecipe == null
                      ? Row(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: pollInfo?.recipeModel?.recipeImages !=
                                          null &&
                                      pollInfo!
                                          .recipeModel!.recipeImages!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: MyCustomExtendedImage(
                                        imageUrl: pollInfo
                                                .recipeModel!.recipeImages![0]
                                                .startsWith('http')
                                            ? pollInfo
                                                .recipeModel!.recipeImages![0]
                                            : dotenv.get('IMAGE_URL') +
                                                pollInfo.recipeModel!
                                                    .recipeImages![0],
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
                              text: pollInfo?.recipeModel?.title ?? '',
                              maxLines: 3,
                              weight: FontWeight.w500,
                            ))
                          ],
                        )
                      : pollInfo?.button?[0].voters?[0].anotherSuggestion ==
                              null
                          ? Row(
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: pollInfo?.button![0].voters![0]
                                                  .finalRecipe!.image !=
                                              null &&
                                          pollInfo!.button![0].voters![0]
                                              .finalRecipe!.image!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: MyCustomExtendedImage(
                                              imageUrl: pollInfo
                                                      .button![0]
                                                      .voters![0]
                                                      .finalRecipe!
                                                      .image!
                                                      .startsWith('http')
                                                  ? pollInfo
                                                          .button![0]
                                                          .voters![0]
                                                          .finalRecipe!
                                                          .image ??
                                                      ''
                                                  : '${dotenv.get('IMAGE_URL')}${pollInfo.button![0].voters![0].finalRecipe!.image}'),
                                        )
                                      : Center(
                                          child: Image.asset(
                                            AssetPath.PHOTO_PLACE_HOLDER,
                                            fit: BoxFit.cover,
                                            scale: 2,
                                          ),
                                        ),
                                ),
                                AppStyles.height12SizedBox(
                                    width: 10, height: 0),
                                Expanded(
                                    child: CustomText(
                                  textAlign: TextAlign.start,
                                  text: pollInfo?.button?[0].voters?[0]
                                          .finalRecipe?.title ??
                                      '',
                                  maxLines: 3,
                                  weight: FontWeight.w500,
                                ))
                              ],
                            )
                          : Row(
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: pollInfo
                                              ?.button![0]
                                              .voters![0]
                                              .anotherSuggestion!
                                              .recipeImages !=
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: MyCustomExtendedImage(
                                              imageUrl:
                                                  '${dotenv.get('IMAGE_URL')}${pollInfo?.button![0].voters![0].anotherSuggestion!.recipeImages?.first}'),
                                        )
                                      : Center(
                                          child: Image.asset(
                                            AssetPath.PHOTO_PLACE_HOLDER,
                                            fit: BoxFit.cover,
                                            scale: 2,
                                          ),
                                        ),
                                ),
                                AppStyles.height12SizedBox(
                                    width: 10, height: 0),
                                pollInfo?.button?[0].voters?[0]
                                            .anotherSuggestion ==
                                        null
                                    ? Expanded(
                                        child: CustomText(
                                        textAlign: TextAlign.start,
                                        text: pollInfo?.button?[0].voters?[0]
                                                .finalRecipe?.title ??
                                            '',
                                        maxLines: 3,
                                        weight: FontWeight.w500,
                                      ))
                                    : Expanded(
                                        child: CustomText(
                                        textAlign: TextAlign.start,
                                        text: pollInfo?.button?[0].voters?[0]
                                                .anotherSuggestion?.title ??
                                            '',
                                        maxLines: 3,
                                        weight: FontWeight.w500,
                                      ))
                              ],
                            ),
                  (pollInfo?.button?[0].voters?[0].finalRecipe == null)
                      ? Wrap(
                          children: List.generate(
                            val.singlePoleResult?.data?[0].button?.length ?? 0,
                            (index) => PollVotesWidget(
                              heading: val.singlePoleResult?.data?[0]
                                      .button?[index].text ??
                                  '',
                              quantity: val.singlePoleResult?.data?[0]
                                      .button?[index].voters?.length ??
                                  0,
                              button:
                                  val.singlePoleResult?.data?[0].button![index],
                            ),
                          ),
                        )
                      : Column(
                          children: [
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
                                  pollInfo?.button?[0].voters?[0]
                                              .anotherSuggestion ==
                                          null
                                      ? HtmlWidget(pollInfo
                                              ?.button![0]
                                              .voters![0]
                                              .finalRecipe!
                                              .summary ??
                                          '')
                                      : HtmlWidget(val
                                              .singlePoleResult
                                              ?.data?[0]
                                              .button![0]
                                              .voters![0]
                                              .anotherSuggestion!
                                              .discription ??
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
                                    pollInfo?.button?[0].voters?[0]
                                                .anotherSuggestion ==
                                            null
                                        ? IngredientsTab(
                                            ingredients: pollInfo
                                                ?.button![0]
                                                .voters![0]
                                                .finalRecipe!
                                                .extendedIngredients,
                                            isSuggestion: true,
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //for (int i = 0; i < (val.singlePoleResult?.data?[0].button?[0].voters?[0].anotherSuggestion?.adminIngredients?.length ?? 0); i++)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Flexible(
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: val
                                                                    .singlePoleResult
                                                                    ?.data?[0]
                                                                    .button?[0]
                                                                    .voters?[0]
                                                                    .anotherSuggestion
                                                                    ?.adminIngredients
                                                                    ?.length ??
                                                                0,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final ingredient = val
                                                                  .singlePoleResult
                                                                  ?.data?[0]
                                                                  .button?[0]
                                                                  .voters?[0]
                                                                  .anotherSuggestion
                                                                  ?.adminIngredients?[index];
                                                              print(
                                                                  'before Building ingredient at index $index'); // Debug log
                                                              // if (ingredient is Map<String, dynamic>) {
                                                              print(
                                                                  'after Building ingredient at index $index');
                                                              final key =
                                                                  ingredient
                                                                      ?.keys
                                                                      .first;
                                                              final value =
                                                                  ingredient
                                                                      ?.values
                                                                      .first;
                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .circle,
                                                                      color: AppColor
                                                                          .THEME_COLOR_SECONDARY,
                                                                      size: 10,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            8),
                                                                    CustomText(
                                                                      lineSpacing:
                                                                          1.2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          "$key: $value",
                                                                      maxLines:
                                                                          3,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                              // }
                                                              return const SizedBox
                                                                  .shrink();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    pollInfo?.button?[0].voters?[0]
                                                .anotherSuggestion ==
                                            null
                                        ? HtmlWidget(
                                            //  instructions:
                                            pollInfo
                                                    ?.button![0]
                                                    .voters![0]
                                                    .finalRecipe!
                                                    .instructions ??
                                                "",
                                          )
                                        : HtmlWidget(
                                            //  instructions:
                                            pollInfo
                                                    ?.button![0]
                                                    .voters![0]
                                                    .anotherSuggestion!
                                                    .instruction ??
                                                "",
                                          )
                                  ]),
                            )
                          ],
                        ),
                  // Wrap(children:List.generate(
                  //     pollInfo?.button?[0].voters?[0].finalRecipe?.extendedIngredients?.length ?? 0,
                  //         (index) => Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 5),
                  //           child: CustomText(text:
                  //           'Step $index: ${pollInfo?.button?[0].voters?[0].finalRecipe?.extendedIngredients?[index].original} ' ,maxLines: 10,textAlign: TextAlign.start),
                  //         )
                  // ),) ,
                ],
              );
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
}

class PollVotesWidget extends StatelessWidget {
  final String heading;
  final int quantity;
  final PollButton? button;

  PollVotesWidget({
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          _getCurrentSuggestionStatus(
                              context: context,
                              suggesstionStatus:
                                  buttons.anotherSuggestion?.title ?? "",
                              voters: buttons),
                        ],
                      ),
                      AppStyles.height16SizedBox(),
                      buttons.userId ==
                                  context
                                      .read<AuthProvider>()
                                      .userdata
                                      ?.data
                                      ?.Id &&
                              button?.text?.toLowerCase() == 'disagree'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      text: 'My Suggested Recipe: ',
                                      weight: FontWeight.bold,
                                      fontColor: AppColor.THEME_COLOR_SECONDARY,
                                    ),
                                    AppStyles.height8SizedBox(),
                                    CustomText(
                                      text: '${buttons.suggestion ?? 'N\'A'}',
                                      weight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                                AppStyles.height16SizedBox(),
                                buttons.anotherSuggestion != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const CustomText(
                                            text: 'Poll Creator Suggested: ',
                                            weight: FontWeight.bold,
                                            fontColor:
                                                AppColor.THEME_COLOR_PRIMARY2,
                                          ),
                                          AppStyles.height8SizedBox(),
                                          CustomText(
                                            textAlign: TextAlign.start,
                                            lineSpacing: 1.2,
                                            text:
                                                '${buttons.anotherSuggestion}',
                                            maxLines: 3,
                                            weight: FontWeight.normal,
                                          ),
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            )
                          : const SizedBox()
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
                  AppNavigator.pop(context);
                },
                showDeclineButton: false,
                onTap: (recipeTitle) {
                  print(recipeTitle);

                  _coreProvider!.acceptRejectSuggestion(
                    StaticData.navigatorKey.currentContext!,
                    voters,
                    suggestionStatus: "reject",
                    another_suggestion: recipeTitle,
                    onSuccess: () {
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
            final dynamic restaurantNAme = await AppNavigator.pushAndReturn(
                context, const NearbyRestrauntScreen());

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

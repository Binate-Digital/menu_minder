import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/network/firebase_messaging_service.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/home/widgets/home_suggestions.dart';
import 'package:menu_minder/view/home/widgets/home_suggestions_spooncular.dart';
import 'package:menu_minder/view/home/widgets/home_suggestions_spooncular_with_diet_prefs.dart';
import 'package:menu_minder/view/nearby_restraunt/screens/nearby_screen.dart';
import 'package:menu_minder/view/recipe_details/screens/recipe_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/primary_textfield.dart';
import '../../../providers/spooncular_provider.dart';
import '../../../services/location_service.dart';
import '../../../utils/asset_paths.dart';
import '../../poll_results/screens/polls_result_screen.dart';
import '../widgets/home_banner.dart';
import '../widgets/location_widget.dart';
import '../widgets/meal_linear_voting_widget.dart';
import '../widgets/multiple_votings_container.dart';
import '../widgets/recipes_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.pollID});
  String? pollID;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  _loadHomeRecipies(
    BuildContext context, {
    bool isRefresh = false,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoreProvider>().getHomeRecipies(
        context,
        '',
        isRefresh: isRefresh,
        onPollLoaded: () {
          // scrollToPoll(widget.pollID);
        },
      );
    });
  }

  ScrollController? columnScroll;

  void scrollToPoll(String? pollId) {
    if (pollId != null) {
      final polls = context.read<CoreProvider>().allPoles?.data;

      polls?.forEach((element) {
        log("POLLS ID ${element.sId}");
      });

      if (polls != null) {
        int index = polls.indexWhere(
            (poll) => poll.sId?.toLowerCase() == pollId.toLowerCase());
        log("POLL ID FOUND ON INDEX $index    POLL ID: $pollId  POLLS LENGTH ${polls.length}");
        if (index != -1) {
          columnScroll?.jumpTo(
            index == 0
                ? MediaQuery.of(context).size.height / 2
                : (index * 450) + MediaQuery.of(context).size.height / 2,
          );

          widget.pollID = null;
        }
      }
    }
  }

  @override
  void initState() {
    columnScroll = ScrollController();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        context.read<CoreProvider>().searchState(true);
        context
            .read<CoreProvider>()
            .updateDate(searchController.text.toLowerCase());
      } else {
        context.read<CoreProvider>().searchState(false);
      }
    });
    // TODO: implement initState
    _loadHomeRecipies(context);

    LocationService().getCurrentPosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // context.watch<UrlSearchParams>();
    final currentUserData = context.read<AuthProvider>().userdata;
    return Scaffold(
      body: RefreshIndicator(
        // enablePullDown: true,
        onRefresh: () async {
          // context.read<CoreProvider>().initState();
          await _loadHomeRecipies(
            context,
            isRefresh: false,
          );
        },

        child: SingleChildScrollView(
          controller: columnScroll,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Consumer<CoreProvider>(builder: (context, val, _) {
            return val.getHomeReciepeSate == States.loading
                ? SizedBox(
                    height: size.height / 1.2,
                    width: size.width,
                    child: const Center(child: CustomLoadingBarWidget()))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      AppStyles.height8SizedBox(),
                      AppStyles.horizontalDivider(),
                      // AppStyles.height8SizedBox(),
                      // val.isSearching
                      //     ? const SizedBox()
                      //     : const LocationWidget(),
                      AppStyles.height16SizedBox(),
                      val.isSearching ? const SizedBox() : const HomeBanner(),
                      AppStyles.height16SizedBox(),
                      AppStyles.headingStyle(
                          "Home Recipes - Your Household cookbook"),
                      AppStyles.height16SizedBox(),

                      val.isSearching
                          ? val.searchedRecipies.isEmpty
                              ? const Center(
                                  child: Text('No Result Found'),
                                )
                              : RecipesWidget(
                                  searchController: searchController,
                                  receipies: val.searchedRecipies,
                                  onTap: () {
                                    // AppNavigator.push(
                                    //     context, RecipeDetailsScreen());
                                  },
                                )
                          : Visibility(
                              replacement: const CustomLoadingBarWidget(),
                              visible: val.homeRecipies?.data != null,
                              child: val.homeRecipies?.data != null &&
                                      val.homeRecipies!.data!.isNotEmpty
                                  ? RecipesWidget(
                                      searchController: searchController,
                                      receipies: val.homeRecipies?.data ?? [],
                                      onTap: () {
                                        AppNavigator.push(
                                            context,
                                            RecipeDetailsScreen(
                                              action: [],
                                            ));
                                      },
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Center(
                                        child: CustomText(
                                          text: 'No Recipies Found',
                                        ),
                                      ),
                                    ),
                            ),
                      AppStyles.height8SizedBox(),
                      val.isSearching
                          ? const SizedBox()
                          : AppStyles.headingStyle("Meal of the Day?"),
                      AppStyles.height12SizedBox(),

                      val.isSearching
                          ? const SizedBox()
                          : Visibility(
                              visible: val.allPoles?.data != null,
                              replacement: const SizedBox(),
                              child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final polvote = val.allPoles?.data?[index];
                                    bool myVote = polvote!.button!
                                        .any((element) => element.myVote == 1);
                                    return myVote
                                        ? MultipleVotingsContainer(
                                            allPolData: polvote,
                                          )
                                        : HomeVoteWidget(
                                            postButtons:
                                                polvote.userID?.Id ==
                                                        currentUserData
                                                            ?.data?.Id
                                                    ? PrimaryButton(
                                                        text:
                                                            "View Poll Result",
                                                        onTap: () {
                                                          AppNavigator.push(
                                                              context,
                                                              PollResultScreen(
                                                                pollID:
                                                                    polvote.sId,
                                                              ));
                                                        })
                                                    : Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        spacing: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20, // Adjust the spacing between buttons as needed

                                                        children: [
                                                          ...List.generate(
                                                              polvote.button
                                                                      ?.length ??
                                                                  0,
                                                              (index) =>
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 8),
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          3,
                                                                      child:
                                                                          PrimaryButton(
                                                                        buttonColor: index ==
                                                                                0
                                                                            ? AppColor.COLOR_GREY1.withOpacity(.5)
                                                                            : null,
                                                                        onTap:
                                                                            () async {
                                                                          if (index ==
                                                                              0) {
                                                                            context.read<CoreProvider>().loadMutualRecipes(
                                                                              StaticData.navigatorKey.currentContext!,
                                                                              polvote.userID!.Id!,
                                                                              polvote.recipeModel!.reciepieId!,
                                                                              onSuccess: () async {
                                                                                await Future.delayed(const Duration(milliseconds: 400));

                                                                                if (val.mutualRecipes?.data != null && val.mutualRecipes!.data!.isNotEmpty) {
                                                                                  AppDialog.showDialogs(
                                                                                      HomeSuggestions(
                                                                                        showDeclineButton: false,
                                                                                        onDeclineTap: () {
                                                                                          context.read<CoreProvider>().giveVote(
                                                                                            context,
                                                                                            receipieName: null,
                                                                                            buttonID: polvote.button![index].sId!,
                                                                                            pollID: polvote.sId!,
                                                                                            buttonData: polvote.button![index],
                                                                                            onSuccess: () {
                                                                                              AppNavigator.pop(context);

                                                                                              Future.delayed(const Duration(milliseconds: 50), () {
                                                                                                AppNavigator.push(context, const NearbyRestrauntScreen());
                                                                                              });

                                                                                              // if (e.text!
                                                                                              //         .toLowerCase() ==
                                                                                              //     'disagree') {
                                                                                              //   AppDialog.showDialogs(
                                                                                              //       SuggestionListWidget(),
                                                                                              //       'Suggestions',
                                                                                              //       context);
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                        onTap: (recipieID) {
                                                                                          print("GIVING VOTEE $recipieID");

                                                                                          context.read<CoreProvider>().giveVote(
                                                                                            StaticData.navigatorKey.currentContext!,
                                                                                            receipieName: recipieID,
                                                                                            buttonID: polvote.button![index].sId!,
                                                                                            pollID: polvote.sId!,
                                                                                            buttonData: polvote.button![index],
                                                                                            onSuccess: () {
                                                                                              AppNavigator.pop(context);
                                                                                              // if (e.text!
                                                                                              //         .toLowerCase() ==
                                                                                              //     'disagree') {
                                                                                              //   AppDialog.showDialogs(
                                                                                              //       SuggestionListWidget(),
                                                                                              //       'Suggestions',
                                                                                              //       context);
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                      'Suggestions',
                                                                                      StaticData.navigatorKey.currentContext!,
                                                                                      hasBack: true);
                                                                                } else {
                                                                                  /// AGAR KOII MUTUALLY SHARED NHII HAI
                                                                                  ///
                                                                                  // ignore: use_build_context_synchronously
                                                                                  context.read<SpoonCularProvider>().recipiesWithDiet(
                                                                                    context,
                                                                                    prefrenceList: [
                                                                                      ...(currentUserData?.data?.breakfastPrerence ?? []),
                                                                                      ...(currentUserData?.data?.lunchPrerence ?? []),
                                                                                      ...(currentUserData?.data?.dinnerPrerence ?? []),
                                                                                    ],
                                                                                    showLoader: true,
                                                                                    onSuccess: () {
                                                                                      // AppNavigator.pop(context);
                                                                                      if (context.read<SpoonCularProvider>().getSpooncularRecipesWithDiet != null && context.read<SpoonCularProvider>().getSpooncularRecipesWithDiet!.results!.isNotEmpty) {
                                                                                        AppDialog.showDialogs(
                                                                                            HomeSuggestionsSpoonCularWithPrefs(
                                                                                              onDeclineTap: () {
                                                                                                context.read<CoreProvider>().giveVote(
                                                                                                  context,
                                                                                                  receipieName: null,
                                                                                                  buttonID: polvote.button![index].sId!,
                                                                                                  pollID: polvote.sId!,
                                                                                                  buttonData: polvote.button![index],
                                                                                                  onSuccess: () {
                                                                                                    AppNavigator.pop(context);
                                                                                                    Future.delayed(const Duration(milliseconds: 50), () {
                                                                                                      AppNavigator.push(context, const NearbyRestrauntScreen());
                                                                                                    });
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              onTap: (recipieID) {
                                                                                                print("GIVING VOTEE $recipieID");

                                                                                                context.read<CoreProvider>().giveVote(
                                                                                                  context,
                                                                                                  receipieName: recipieID,
                                                                                                  buttonID: polvote.button![index].sId!,
                                                                                                  pollID: polvote.sId!,
                                                                                                  buttonData: polvote.button![index],
                                                                                                  onSuccess: () {
                                                                                                    AppNavigator.pop(context);
                                                                                                    // if (e.text!
                                                                                                    //         .toLowerCase() ==
                                                                                                    //     'disagree') {
                                                                                                    //   AppDialog.showDialogs(
                                                                                                    //       SuggestionListWidget(),
                                                                                                    //       'Suggestions',
                                                                                                    //       context);
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                            'Suggestions',
                                                                                            context,
                                                                                            hasBack: true);
                                                                                      } else {
                                                                                        context.read<SpoonCularProvider>().getAllRandomReceipes(context);

                                                                                        AppDialog.showDialogs(
                                                                                            HomeSuggestionsSpoonCular(
                                                                                              showDeclineButton: false,
                                                                                              onDeclineTap: () {
                                                                                                context.read<CoreProvider>().giveVote(
                                                                                                  context,
                                                                                                  receipieName: null,
                                                                                                  buttonID: polvote.button![index].sId!,
                                                                                                  pollID: polvote.sId!,
                                                                                                  buttonData: polvote.button![index],
                                                                                                  onSuccess: () {
                                                                                                    AppNavigator.pop(context);
                                                                                                    Future.delayed(const Duration(milliseconds: 50), () {
                                                                                                      AppNavigator.push(context, const NearbyRestrauntScreen());
                                                                                                    });
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              onTap: (recipieID) {
                                                                                                print("GIVING VOTEE $recipieID");
                                                                                                context.read<CoreProvider>().giveVote(
                                                                                                  context,
                                                                                                  receipieName: recipieID,
                                                                                                  buttonID: polvote.button![index].sId!,
                                                                                                  pollID: polvote.sId!,
                                                                                                  buttonData: polvote.button![index],
                                                                                                  onSuccess: () {
                                                                                                    AppNavigator.pop(context);
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                            'Suggestions',
                                                                                            context,
                                                                                            hasBack: true);
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                }
                                                                              },
                                                                            );

                                                                            //   if (val.homeRecipies!.data!.isEmpty) {
                                                                            // context.read<SpoonCularProvider>().recipiesWithDiet(
                                                                            //   context,
                                                                            //   showLoader: true,
                                                                            //   onSuccess: () {
                                                                            //     // AppNavigator.pop(context);
                                                                            //     if (context.read<SpoonCularProvider>().getSpooncularRecipesWithDiet != null && context.read<SpoonCularProvider>().getSpooncularRecipesWithDiet!.results!.isNotEmpty) {
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
                                                                            //                   Future.delayed(const Duration(milliseconds: 50), () {
                                                                            //                     AppNavigator.push(context, const NearbyRestrauntScreen());
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
                                                                            //       context.read<SpoonCularProvider>().getAllRandomReceipes(context);

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

                                                                            //                   Future.delayed(const Duration(milliseconds: 50), () {
                                                                            //                     AppNavigator.push(context, const NearbyRestrauntScreen());
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
                                                                            //   } else {
                                                                            //     // final data = context.read<CoreProvider>()
                                                                            //     context.read<CoreProvider>().loadMutualRecipes(
                                                                            //       StaticData.navigatorKey.currentContext!,
                                                                            //       polvote.userID!.Id!,
                                                                            //       polvote.recipeModel!.reciepieId!,
                                                                            //       onSuccess: () async {
                                                                            //         print("ONNCUCCESSSSS");
                                                                            //         await Future.delayed(Duration(milliseconds: 400));
                                                                            //         AppDialog.showDialogs(
                                                                            //             HomeSuggestions(
                                                                            //               onDeclineTap: () {
                                                                            //                 context.read<CoreProvider>().giveVote(
                                                                            //                   context,
                                                                            //                   receipieName: null,
                                                                            //                   buttonID: polvote.button![index].sId!,
                                                                            //                   pollID: polvote.sId!,
                                                                            //                   buttonData: polvote.button![index],
                                                                            //                   onSuccess: () {
                                                                            //                     AppNavigator.pop(context);

                                                                            //                     Future.delayed(const Duration(milliseconds: 50), () {
                                                                            //                       AppNavigator.push(context, NearbyRestrauntScreen());
                                                                            //                     });

                                                                            //                     // if (e.text!
                                                                            //                     //         .toLowerCase() ==
                                                                            //                     //     'disagree') {
                                                                            //                     //   AppDialog.showDialogs(
                                                                            //                     //       SuggestionListWidget(),
                                                                            //                     //       'Suggestions',
                                                                            //                     //       context);
                                                                            //                   },
                                                                            //                 );
                                                                            //               },
                                                                            //               onTap: (recipieID) {
                                                                            //                 context.read<CoreProvider>().giveVote(
                                                                            //                   StaticData.navigatorKey.currentContext!,
                                                                            //                   receipieName: recipieID,
                                                                            //                   buttonID: polvote.button![index].sId!,
                                                                            //                   pollID: polvote.sId!,
                                                                            //                   buttonData: polvote.button![index],
                                                                            //                   onSuccess: () {
                                                                            //                     AppNavigator.pop(context);
                                                                            //                     // if (e.text!
                                                                            //                     //         .toLowerCase() ==
                                                                            //                     //     'disagree') {
                                                                            //                     //   AppDialog.showDialogs(
                                                                            //                     //       SuggestionListWidget(),
                                                                            //                     //       'Suggestions',
                                                                            //                     //       context);
                                                                            //                   },
                                                                            //                 );
                                                                            //               },
                                                                            //             ),
                                                                            //             'Suggestions',
                                                                            //             StaticData.navigatorKey.currentContext!,
                                                                            //             hasBack: true);
                                                                            //       },
                                                                            //     );

                                                                            //     // context.rea()
                                                                            //   }
                                                                            // } else {
                                                                            //   context.read<CoreProvider>().giveVote(
                                                                            //     context,
                                                                            //     buttonID: polvote.button![index].sId!,
                                                                            //     pollID: polvote.sId!,
                                                                            //     buttonData: polvote.button![index],
                                                                            //     onSuccess: () {
                                                                            //       // if (e.text!
                                                                            //       //         .toLowerCase() ==
                                                                            //       //     'disagree') {
                                                                            //       //   AppDialog.showDialogs(
                                                                            //       //       SuggestionListWidget(),
                                                                            //       //       'Suggestions',
                                                                            //       //       context);
                                                                            //     },
                                                                            //   );
                                                                            // }
                                                                          } else {
                                                                            context.read<CoreProvider>().giveVote(
                                                                              StaticData.navigatorKey.currentContext!,
                                                                              receipieName: polvote.recipeModel!.title!,
                                                                              buttonID: polvote.button![index].sId!,
                                                                              pollID: polvote.sId!,
                                                                              buttonData: polvote.button![index],
                                                                              onSuccess: () {
                                                                                // AppNavigator.pop(context);
                                                                                // if (e.text!
                                                                                //         .toLowerCase() ==
                                                                                //     'disagree') {
                                                                                //   AppDialog.showDialogs(
                                                                                //       SuggestionListWidget(),
                                                                                //       'Suggestions',
                                                                                //       context);
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                        text: polvote.button![index].text ??
                                                                            '',
                                                                      ),
                                                                    ),
                                                                  ))
                                                        ],
                                                      ),
                                            pollData: polvote,
                                          );
                                  },

                                  // => postList[index]
                                  //     ? MealLinearVotingWidget(
                                  //         onAgreeButton: () {
                                  //           postList.removeAt(index);
                                  //           setState(() {});
                                  //         },
                                  //       )
                                  //     : MultipleVotingsContainer(),
                                  separatorBuilder: (context, index) =>
                                      AppStyles.height12SizedBox(),
                                  itemCount: val.allPoles?.data?.length ?? 0),
                            ),

                      //  Visibility(
                      //   visible: val.allPoles?.data != null,
                      //   child: ListView.separated(
                      //       physics: const NeverScrollableScrollPhysics(),
                      //       shrinkWrap: true,
                      //       itemBuilder: (context, index) => postList[index]
                      //           ? MealLinearVotingWidget(
                      //               onAgreeButton: () {
                      //                 postList.removeAt(index);
                      //                 setState(() {});
                      //               },
                      //             )
                      //           : MultipleVotingsContainer(),
                      //       separatorBuilder: (context, index) =>
                      //           AppStyles.height12SizedBox(),
                      //       itemCount: postList.length),
                      // )

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:menu_minder/common/drawer_screen.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/routes_names.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/add_recipe/screens/add_recipe_screen.dart';
import 'package:menu_minder/view/create_grocery_list/screens/create_grocery_list_screen.dart';
import 'package:menu_minder/view/grocery_list/screens/grocery_list_screen.dart';
import 'package:menu_minder/view/inbox/screens/inbox_screen.dart';
import 'package:menu_minder/view/meal_plan/screens/meal_plan_screen.dart';
import 'package:menu_minder/view/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../common/bottom_sheet_option_widget.dart';
import '../services/network/firebase_messaging_service.dart';
import '../view/home/screens/home_screen.dart';
import '../view/notifications/screens/notification_screen.dart';
import 'asset_paths.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, this.index = 0, this.pollID});
  final int index;
  final String? pollID;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<BottomBar> {
  GlobalKey<ScaffoldState> drawrKey = GlobalKey<ScaffoldState>();
  // int _currentIndex = 0;
  List<Widget> _pages = [];
  @override
  void initState() {
    _pages = [
      HomeScreen(pollID: widget.pollID),
      MealPlanScreen(),
      GroceryListScreen(),
      ProfileScreen(),
    ];

    // _pages.add(const HomeScreen());
    // _pages.add(const MealPlanScreen());
    // _pages.add(const GroceryListScreen());
    // _pages.add(const ProfileScreen());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bottomIndex,
      builder: (context, val, _) {
        return Scaffold(
          drawer: const UserDrawer(),
          key: drawrKey,
          body: WillPopScope(
            onWillPop: () async {
              if (drawrKey.currentState!.isDrawerOpen) {
                drawrKey.currentState!.closeDrawer();
              } else {
                AppDialog.showDialogs(
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 48,
                        ),
                        child: AppStyles.headingStyle(
                          "Are you sure you want to exit?",
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: "No",
                              buttonColor: Colors.grey.shade600,
                              onTap: () {
                                AppNavigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PrimaryButton(
                              text: "Yes",
                              buttonColor: AppColor.COLOR_RED1,
                              onTap: () {
                                exit(0);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  "Exit",
                  context,
                );
              }
              return false;
            },
            child: SafeArea(
              child: Container(
                margin:
                    val != 3
                        ? const EdgeInsets.only(
                          left: AppDimen.SCREEN_PADDING,
                          right: AppDimen.SCREEN_PADDING,
                          top: AppDimen.SCREEN_PADDING,
                        )
                        : EdgeInsets.zero,
                child: _pages[val],
              ),
            ),
          ),
          resizeToAvoidBottomInset: true,
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppStyles.pinkAppBar(
            context,
            val == 0
                ? "Home"
                : val == 1
                ? "My Meal Plan"
                : val == 2
                ? "Grocery List"
                : "My Profile",
            isRounded: val != 3,
            hasBack: false,
            onleadingTap: () {
              drawrKey.currentState!.openDrawer();
            },
            trailing: Row(
              children: [
                InkWell(
                  onTap: () {
                    AppNavigator.pushNamed(
                      StaticData.navigatorKey.currentContext!,
                      AppRouteName.inBoxScreen,
                    );
                    // AppNavigator.push(context, const InboxScreen());
                  },
                  child: Image.asset(AssetPath.MSG, scale: 4),
                ),
                const SizedBox(width: 10),

                // val == 2
                //     ? InkWell(
                //         onTap: () {
                //           AppDialog.modalBottomSheet(
                //               context: context,
                //               child: Consumer<CoreProvider>(
                //                   builder: (context, val, _) {
                //                 return Column(
                //                   children: [
                //                     // BottomSheetOptions(
                //                     //     heading: "Edit Grocery List",
                //                     //     imagePath: AssetPath.EDIT,
                //                     //     onTap: () {
                //                     //       AppNavigator.push(
                //                     //           context,
                //                     //           CreateGroceryListScreen(
                //                     //             isEdit: true,
                //                     //             groceryListModel:
                //                     //                 val.getGroceryyList,
                //                     //           ));
                //                     //     }),
                //                     Visibility(
                //                       visible:
                //                           val.getGroceryyList?.data != null,
                //                       child: BottomSheetOptions(
                //                           heading: "Delete Grocery List",
                //                           imagePath: AssetPath.DELETE,
                //                           bottomDivider: false,
                //                           onTap: () {
                //                             AppDialog.showDialogs(
                //                                 Column(
                //                                   children: [
                //                                     Padding(
                //                                       padding: const EdgeInsets
                //                                               .symmetric(
                //                                           vertical: 8.0,
                //                                           horizontal: 48),
                //                                       child: AppStyles.headingStyle(
                //                                           "Are you sure you want to delete this list?",
                //                                           textAlign:
                //                                               TextAlign.center,
                //                                           fontWeight:
                //                                               FontWeight.w400),
                //                                     ),
                //                                     Row(
                //                                       children: [
                //                                         Expanded(
                //                                             child:
                //                                                 PrimaryButton(
                //                                                     text:
                //                                                         "Cancel",
                //                                                     buttonColor:
                //                                                         Colors
                //                                                             .grey
                //                                                             .shade600,
                //                                                     onTap: () {
                //                                                       AppNavigator
                //                                                           .pop(
                //                                                               context);
                //                                                     })),
                //                                         const SizedBox(
                //                                           width: 10,
                //                                         ),
                //                                         // Expanded(
                //                                         //     child:
                //                                         //         PrimaryButton(
                //                                         //             text:
                //                                         //                 "Delete",
                //                                         //             buttonColor:
                //                                         //                 AppColor
                //                                         //                     .COLOR_RED1,
                //                                         //             onTap: () {
                //                                         //               if (val.getGroceryyList!
                //                                         //                       .data !=
                //                                         //                   null) {
                //                                         //                 context.read<CoreProvider>().deleteGrocery(
                //                                         //                     context,
                //                                         //                     onSuccess:
                //                                         //                         () {
                //                                         //                   AppNavigator.pop(
                //                                         //                       context);
                //                                         //                   AppNavigator.pop(
                //                                         //                       context);
                //                                         //                 }, groceryID: context.read<CoreProvider>().getGroceryyList!.data!!);
                //                                         //               }
                //                                         //             })),
                //                                       ],
                //                                     )
                //                                   ],
                //                                 ),
                //                                 "Delete List",
                //                                 context);
                //                           }),
                //                     ),

                //                   ],
                //                 );
                //               }));
                //         },
                //         child: const Icon(
                //           Icons.more_vert,
                //           color: AppColor.COLOR_WHITE,
                //         ),
                //       )
                //     :
                InkWell(
                  onTap: () {
                    AppNavigator.push(
                      context,
                      const NotificationsScreen(isFromNotifications: false),
                    );
                  },
                  child: Image.asset(AssetPath.NOTIFICATIONS, scale: 4),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: -12.0,
            clipBehavior: Clip.hardEdge,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.TRANSPARENT_COLOR,
                border: null,
              ),
              child: BottomNavigationBar(
                elevation: 0,

                // selectedFontSize: 0,
                unselectedItemColor: Colors.grey,
                unselectedFontSize: 11,
                selectedFontSize: 11,
                currentIndex: val,
                backgroundColor: AppColor.COLOR_TRANSPARENT,
                selectedItemColor: AppColor.THEME_COLOR_PRIMARY1,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  bottomIndex.value = index;
                  // searchController.clear();
                  context.read<CoreProvider>().initSearch();
                  context.read<CoreProvider>().searchedRecipies.clear();
                  setState(() {});
                },
                items: [
                  bottomBarIcon(AssetPath.HOME, "Home", 0, val),
                  bottomBarIcon(AssetPath.MEAL, "Meal Plan", 1, val),
                  bottomBarIcon(AssetPath.GROCERY, "Grocery List", 2, val),
                  bottomBarIcon(AssetPath.PROFILE, "Profile", 3, val),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton:
              MediaQuery.of(context).viewInsets.bottom == 0.0
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0.1,
                            color: AppColor.THEME_COLOR_PRIMARY1.withOpacity(
                              0.2,
                            ),
                          ),
                        ],
                      ),
                      child: Transform.scale(
                        scale: 1.0,
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
                          child: const Icon(Icons.add),
                          onPressed: () {
                            AppDialog.modalBottomSheet(
                              context: context,
                              child: Column(
                                children: [
                                  BottomSheetOptions(
                                    heading: "Create Recipe",
                                    imagePath: AssetPath.CREATE_RECIPE,
                                    onTap: () {
                                      AppNavigator.pop(context);
                                      // Future.delayed(const Duration(
                                      //         milliseconds: 200))
                                      //     .then((value) => optionsDialog());

                                      AppNavigator.push(
                                        context,
                                        const AddRecipeScreen(
                                          mealType: '',
                                          isEdit: false,
                                          isMealPlan: false,
                                        ),
                                      );
                                    },
                                  ),
                                  BottomSheetOptions(
                                    onTap: () {
                                      AppNavigator.pop(context);
                                      Future.delayed(
                                        const Duration(milliseconds: 100),
                                      ).then(
                                        (value) => AppNavigator.push(
                                          context,
                                          const CreateGroceryListScreen(
                                            isEdit: false,
                                          ),
                                        ),
                                      );
                                    },
                                    bottomDivider: false,
                                    heading: "Create Grocery List",
                                    imagePath: AssetPath.CREATE_RECIPE,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                  : null,
        );
      },
    );
  }

  optionsDialog() => AppDialog.plainDialog(
    context,
    Column(
      children: [
        PrimaryButton(
          text: "Add Manual Recipe",
          onTap: () {
            AppNavigator.pop(context);
            Future.delayed(const Duration(milliseconds: 200)).then(
              (value) => AppNavigator.push(
                context,
                const AddRecipeScreen(mealType: ''),
              ),
            );
          },
        ),
        AppStyles.height8SizedBox(),
        PrimaryButton(
          text: "Add Dynamic Recipe",
          onTap: () {
            AppNavigator.pop(context);
            Future.delayed(const Duration(milliseconds: 200)).then(
              (value) => AppNavigator.push(
                context,
                const AddRecipeScreen(mealType: ''),
              ),
            );
          },
        ),
      ],
    ),
  );

  BottomNavigationBarItem bottomBarIcon(
    final String image,
    final String label,
    int index,
    int updatedIndex,
  ) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AssetPath.HANGER,
            scale: 4.5,
            color:
                index == updatedIndex
                    ? AppColor.THEME_COLOR_PRIMARY1
                    : Colors.transparent,
          ),
          const SizedBox(height: 2),
          Image.asset(
            image,
            height: 18,
            color:
                index == updatedIndex
                    ? AppColor.THEME_COLOR_PRIMARY1
                    : Colors.grey,
          ),
          SizedBox(height: 2),
        ],
      ),
      label: label,
    );
  }
}

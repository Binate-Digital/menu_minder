import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common_model/profile.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/rounded_image.dart';
import 'package:menu_minder/utils/routes_names.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/auth/screens/social_login_screen.dart';
import 'package:menu_minder/view/inbox/screens/inbox_screen.dart';
import 'package:menu_minder/view/invite_family_member/screens/invite_family_screen.dart';
import 'package:menu_minder/view/settings/screens/settings_screen.dart';
import 'package:menu_minder/view/spooncular/spooncular_views/random_recipies_view.dart';
import 'package:menu_minder/view/spooncular/spooncular_views/spooncular_specifc_recipies_with_diet.dart';
import 'package:provider/provider.dart';

import '../../utils/asset_paths.dart';
import '../utils/app_constants.dart';
import '../utils/dummy.dart';
import '../view/show_family_members/screens/show_family_member_screen.dart';
import 'custom_text.dart';
import 'enums.dart';
import 'menu_item.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  Animation<double>? scaleAnimation;

  int popupAnimationDuration = 400;
  Curve popupAnimationType = Curves.easeIn;
  AuthProvider? _authProvider;
  @override
  void initState() {
    // TODO: implement initState
    _authProvider = context.read<AuthProvider>();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: popupAnimationDuration));
    scaleAnimation = CurvedAnimation(
        parent: animationController!, curve: popupAnimationType);
    animationController!.addListener(() {
      setState(() {});
    });
    animationController!.forward();
    super.initState();
  }

  String getName(int index) {
    switch (index) {
      case 0:
        return "Chats";
      case 1:
        return "Audition Requests";
      case 2:
        return "Home";
      case 3:
        return "Community Board";
      case 4:
        return "My Profile";

      default:
        return "";
    }
  }

  GlobalKey<ScaffoldState> globalKey = GlobalKey();
  // int index = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Drawer(
        width: 320.0,
        backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    AppNavigator.pop(context);
                    // globalKey.currentState!.closeDrawer();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  )),
            ),
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: AppColor.COLOR_WHITE,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 9,
                      blurRadius: 8,
                      offset: const Offset(1, 1), // changes position of shadow
                    )
                  ]),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Consumer<AuthProvider>(builder: (context, val, _) {
                    return RoundedImage(
                      scale: 1.5,
                      backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
                      borderColor: AppColor.COLOR_WHITE,
                      image: _authProvider!.userdata!.data!.userImage != null &&
                              _authProvider!.userdata!.data!.userImage != ""
                          ? _authProvider!.userdata!.data!.userImage
                          : AssetPath.PROFILE,
                      imageType:
                          _authProvider!.userdata!.data!.userImage != null &&
                                  _authProvider!.userdata!.data!.userImage != ""
                              ? ImageType.TYPE_NETWORK
                              : ImageType.TYPE_ASSET,
                    );

                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundColor: AppColor.COLOR_WHITE,
                    //   child: CircleAvatar(
                    //       radius: 46.0,
                    //       backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
                    //       backgroundImage:
                    //           _authProvider!.userdata!.data!.userImage != ""
                    //               ? NetworkImage(_authProvider!.userdata!.data!
                    //                   .userImage!) as ImageProvider
                    //               : AssetImage(
                    //                   AssetPath.PROFILE,
                    //                 )),
                    // );
                  }),
                  Positioned(
                    right: 105,
                    top: 70,
                    child: SizedBox(
                      height: 40,
                      child: Image.asset(
                        AssetPath.DRAWER_STAR,
                        scale: 4,
                        width: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: CustomText(
                text: _authProvider?.userdata?.data?.userName ?? "",
                fontColor: AppColor.COLOR_WHITE,
                fontSize: 15,
                weight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: CustomText(
                text: _authProvider?.userdata?.data?.userSocialType == "phone"
                    ? _authProvider?.userdata?.data?.userAlternateEmail
                    : _authProvider?.userdata?.data?.userEmail ?? "",
                fontColor: AppColor.COLOR_WHITE,
                fontSize: 13,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                ReuabledrawerItems(
                  title: "Home",
                  imagewant: true,
                  imgs: AssetPath.HOME,
                  onpress: () {
                    bottomIndex.value = 0;
                    AppNavigator.pop(context);
                    setState(() {});
                  },
                ),
                // _divider(),
                // ReuabledrawerItems(
                //   title: "My Profile",
                //   imagewant: true,
                //   imgs: AssetPaths.user1Icon,
                //   onpress: () {
                //     AppNavigation.navigateTo(context, AppRouteName.)
                //   },
                // ),
                AppStyles.height12SizedBox(),
                ReuabledrawerItems(
                  title: "My Polls",
                  imagewant: true,
                  imgs: AssetPath.POLL,
                  onpress: () {
                    AppNavigator.pop(context);

                    Future.delayed(const Duration(milliseconds: 100), () {
                      AppNavigator.pushNamed(context, AppRouteName.POLL_SCREEN);
                    });
                    // AppNavigatorKey.key.currentState!.closeDrawer();
                    // AppNavigator.push(context, const MyPollsScreen());

                    /*  AppNavigation.navigatorPop(context);
                        AppNavigation.navigateTo(
                            context, AppRouteName.requesthistory);
                       */
                  },
                ),
                // AppStyles.height12SizedBox(),

                AppStyles.height12SizedBox(),
                ReuabledrawerItems(
                  title: "Preferred Recipes",
                  imagewant: true,
                  imgs: AssetPath.CREATE_RECIPE,
                  onpress: () {
                    AppNavigator.pop(context);
                    Future.delayed(Duration(milliseconds: 100), () {
                      AppNavigator.push(
                          context,
                          const SpecificRecipesWithDiet(
                            hideButton: true,
                          ));
                    });

                    /*  AppNavigation.navigatorPop(context);
                        AppNavigation.navigateTo(
                            context, AppRouteName.requesthistory);
                       */
                  },
                ),
                // AppStyles.height12SizedBox(),
                AppStyles.height12SizedBox(),
                ReuabledrawerItems(
                  title: "Food Recipes",
                  imagewant: true,
                  imgs: AssetPath.CREATE_RECIPE,
                  onpress: () {
                    AppNavigator.pop(context);
                    AppNavigator.push(
                        context,
                        const RandomRecipiesScreen(
                          hideButton: true,
                        ));
                    /*  AppNavigation.navigatorPop(context);
                        AppNavigation.navigateTo(
                            context, AppRouteName.requesthistory);
                       */
                  },
                ),
                AppStyles.height12SizedBox(),
                ReuabledrawerItems(
                  title: "Messages",
                  imgs: AssetPath.MSG,
                  imagewant: true,
                  onpress: () {
                    AppNavigator.pop(context);

                    Future.delayed(const Duration(milliseconds: 100), () {
                      AppNavigator.push(context, const InboxScreen());
                    });
                    /*   AppNavigation.navigatorPop(context);
                        AppNavigation.navigateTo(
                            context, AppRouteName.mySchedule);
                       */
                  },
                ),
                AppStyles.height12SizedBox(),
                ReuabledrawerItems(
                  title: "Show Family Members",
                  imagewant: true,
                  iconColor: AppColor.COLOR_WHITE,
                  imgs: AssetPath.USER,
                  onpress: () {
                    AppNavigator.pop(context);

                    Future.delayed(const Duration(milliseconds: 100), () {
                      AppNavigator.push(
                          context, const ShowFamilyMemberScreen());
                    });

                    /*   AppNavigation.navigateTo(
                            context, AppRouteName.settingScreenRoute);
                        AppNavigatorKey.key.currentState!.closeDrawer();
 */
                    // _showDialogToDeleteReminder(context);
                  },
                ),
                AppStyles.height12SizedBox(),
                ReuabledrawerItems(
                  title: "Invite Family Member",
                  imagewant: true,
                  imgs: AssetPath.PROFILE_PLUS,
                  onpress: () {
                    AppNavigator.pop(context);

                    Future.delayed(const Duration(milliseconds: 100), () {
                      AppNavigator.push(
                          context,
                          const InviteFamilyScreen(
                            isEdit: true,
                          ));
                    });

                    /*   AppNavigation.navigatorPop(context);
                        AppNavigation.navigateTo(
                            context, AppRouteName.subscriptionPlan);
                       */
                  },
                ),

                AppStyles.height12SizedBox(),
                ReuabledrawerItems(
                  title: "Settings",
                  imagewant: true,
                  iconColor: AppColor.COLOR_WHITE,
                  imgs: AssetPath.SETTINGS,
                  onpress: () {
                    AppNavigator.pop(context);
                    // context.read<NotificationProvider>().initUser(context);

                    Future.delayed(const Duration(milliseconds: 100), () {
                      AppNavigator.push(context, const SettingsScreen());
                    });

                    /*   AppNavigation.navigateTo(
                            context, AppRouteName.settingScreenRoute);
                        AppNavigatorKey.key.currentState!.closeDrawer();
 */
                    // _showDialogToDeleteReminder(context);
                  },
                ),

                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 45.0,
                  width: 170.0,
                  decoration: const BoxDecoration(
                      color: AppColor.COLOR_WHITE,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0))),
                  child: Consumer<AuthProvider>(builder: (context, val, _) {
                    if (val.logoutState == States.success) {
                      profile.value = Profile();
                      AppNavigator.pushAndRemoveUntil(
                          context, const SocialLoginScreen());
                    }
                    return val.logoutState == States.loading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              // CircularProgressIndicator(
                              //   backgroundColor: AppColor.COLOR_WHITE,
                              //   color: AppColor.THEME_COLOR_PRIMARY1,
                              // ),
                              CustomLoadingBarWidget()
                            ],
                          )
                        : ReuabledrawerItems(
                            title: "Logout",
                            textColor: AppColor.THEME_COLOR_PRIMARY1,
                            iconColor: AppColor.THEME_COLOR_PRIMARY1,
                            imagewant: true,
                            imgs: AssetPath.LOGOUT,
                            onpress: () {
                              val.logout(context);
                              /*   profile.value = Profile();
                              bottomIndex.value = 2; */
                              /*     AppDialog.showDialogs(
                                  Column(
                                    children: [
                                      // const DialogAvatar(
                                      //   content: 'Are you sure you want to logout?',
                                      //   image: AssetPaths.logout1Icon,
                                      // ),
                                      Text(
                                        'Are you sure you want to logout?',
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontFamily: AppFonts.openSansMedium,
                                            fontSize: 16.sp),
                                      ),
                                      AppStyles.height20SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 0.35.sw,
                                            child: CustomButton(
                                              buttonColor: AppColors.blackColor,
                                              buttonText: 'No I don\'t',
                                              onTap: () =>
                                                  AppNavigation.navigatorPop(
                                                      context),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 0.35.sw,
                                            child: CustomButton(
                                                buttonColor: AppColors.blueColor,
                                                buttonText: 'Yes',
                                                onTap: () {
                                                  AppDialogs.showToast(
                                                      message:
                                                          "Logout successfully");
                                                  AppNavigation
                                                      .navigateToRemovingAll(
                                                          context,
                                                          AppRouteName
                                                              .socialLoginRoute);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  context,
                                  'Delete Request');
                           */
                            },
                          );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

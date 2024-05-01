import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/create_profile/screens/create_profile_screen.dart';
import 'package:menu_minder/view/settings/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/primary_button.dart';
import '../../../utils/actions.dart';
import '../../../utils/app_constants.dart';
import '../../home/widgets/meal_linear_voting_widget.dart';
import '../../home/widgets/recipes_widget.dart';
import '../../poll_results/screens/polls_result_screen.dart';
import '../../user_profile/widgets/followers_list_widget.dart';
import '../widgets/personal_info_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  AuthProvider? _authProvider;
  @override
  void initState() {
    _authProvider = context.read<AuthProvider>();
    // _authProvider = context.read<CoreProvider>().initState();
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAllReceipies(context);
      context.read<CoreProvider>().getMyPoles(context);
    });
  }

  _getAllReceipies(BuildContext context) {
    context
        .read<CoreProvider>()
        .getReciepiesByUserID(context, _authProvider?.userdata?.data?.Id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileScreenPersonInfo(
            onFollowers: () {
              _tabController!.index = 0;
              AppDialog.plainDialog(
                context,
                FollowersListWidget(tabController: _tabController),
              );
            },
            onFollowing: () {
              _tabController!.index = 1;
              AppDialog.plainDialog(
                context,
                FollowersListWidget(tabController: _tabController),
              );
            },
            leftButtonTap: () {
              AppNavigator.push(
                  context,
                  const CreateProfileScreen(
                    isEdit: true,
                  ));
            },
            rightButtonTap: () {
              AppNavigator.push(context, const SettingsScreen());
            },
          ),
          Container(
            color: AppColor.COLOR_WHITE,
            padding: const EdgeInsets.only(
              left: AppDimen.SCREEN_PADDING,
              right: AppDimen.SCREEN_PADDING,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppStyles.height16SizedBox(),

                  // const Center(
                  //     child: Text(
                  //   "will be done in next phase",
                  //   style: TextStyle(fontSize: 11, color: Colors.grey),
                  // )),
                  // AppStyles.headingStyle("My Recipes"),
                  AppStyles.height16SizedBox(),

                  Consumer<CoreProvider>(builder: (context, val, _) {
                    if (val.getMyReciepiesState == States.loading) {
                      return const CustomLoadingBarWidget();
                    } else if (val.getMyReciepiesState == States.failure) {
                      return const Center(
                        child: CustomText(
                          text: 'No Data Found',
                        ),
                      );
                    }

                    if (val.getMyReciepiesState == States.success) {
                      print(
                          "Reciepe Response Length ${val.getMyRecipies!.data!.length}");
                      return val.getMyRecipies?.data != null &&
                              val.getMyRecipies!.data!.isEmpty
                          ? const Center(
                              child: CustomText(
                                text: 'No Data yet.',
                              ),
                            )
                          : RecipesWidget(
                              receipies: val.getMyRecipies!.data ?? [],
                            );
                    }
                    return const SizedBox();
                  }),

                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: AppStyles.headingStyle("My Polls",
                  //       textAlign: TextAlign.start),
                  // ),
                  // AppStyles.height16SizedBox(),

                  // MealLinearVotingWidget(
                  //   postButtons: const SizedBox.shrink(),
                  // ),

                  // Consumer<CoreProvider>(builder: (contex, val, _) {
                  //   return Column(
                  //     children: [

                  //     ],
                  //   );
                  // }),

                  // Expanded(child: MyPollWdiget()),
                ],
              ),
            ),
          ),
          // Expanded(child: MyPollWdiget()),
        ],
      ),
    );
  }
}

class MyPollWdiget extends StatelessWidget {
  const MyPollWdiget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(builder: (context, val, _) {
      if (val.getMyPoleLoadState == States.loading) {
        return const CustomLoadingBarWidget();
      } else if (val.getMyPoleLoadState == States.success) {
        return val.getMyPolles?.data != null && val.getMyPolles!.data!.isEmpty
            ? const Center(
                child: CustomText(
                  text: 'No Data Found',
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) => MealLinearVotingWidget(
                  pollData: val.getMyPolles!.data![index],
                  showMore: true,
                  hasBottomOptions: true,
                  onMore: () {
                    // pollsBottomSheet(context, val.getMyPolles!.data![index]);
                  },
                  postButtons: PrimaryButton(
                      text: "View Poll Result",
                      onTap: () {
                        AppNavigator.push(
                            context,
                            PollResultScreen(
                              pollID: val.getMyPolles!.data![index].sId,
                            ));
                      }),
                ),
                itemCount: val.getMyPolles?.data?.length ?? 0,
                separatorBuilder: (BuildContext context, int index) =>
                    AppStyles.height12SizedBox(),
              );
      } else if (val.getMyPoleLoadState == States.failure) {
        return const Center(
          child: CustomText(
            text: 'No Data Found',
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}

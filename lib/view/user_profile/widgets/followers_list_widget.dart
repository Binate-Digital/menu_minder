import 'package:flutter/material.dart';

import '../../../common/custom_tabbar.dart';
import '../../../common/decision_container_widget.dart';
import '../../../common/primary_button.dart';
import '../../../common/profile_banner_widget.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/styles.dart';

class FollowersListWidget extends StatelessWidget {
  const FollowersListWidget({
    super.key,
    required TabController? tabController,
  }) : _tabController = tabController;

  final TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          CustomTabbar(
            tabController: _tabController,
            tabNames: const ["Followers", "Following"],
          ),
          AppStyles.height12SizedBox(),
          Flexible(
            child: TabBarView(controller: _tabController, children: [
              ListView.builder(itemBuilder: (context, index) {
                ValueNotifier<bool> isFollowed =
                    ValueNotifier(index % 2 == 0 ? true : false);
                return DecisionContainer(
                  customPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ProfileBanner(
                        nameSize: 14,
                        radius: 16,
                      ),
                      ValueListenableBuilder(
                          valueListenable: isFollowed,
                          builder: (context, val, _) {
                            return SizedBox(
                              width: 100,
                              child: PrimaryButton(
                                  height: 30,
                                  // isPadded: false,
                                  radius: 6,
                                  buttonColor: val
                                      ? AppColor.THEME_COLOR_SECONDARY
                                      : AppColor.THEME_COLOR_PRIMARY1,
                                  textColor: val
                                      ? AppColor.COLOR_BLACK
                                      : AppColor.COLOR_WHITE,
                                  textPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  text: val ? "Following" : "Follow",
                                  onTap: () {
                                    isFollowed.value = !isFollowed.value;
                                  }),
                            );
                          })
                    ],
                  ),
                );
              }),
              ListView.builder(itemBuilder: (context, index) {
                ValueNotifier<bool> isFollowed =
                    ValueNotifier(index % 2 == 0 ? true : false);
                return DecisionContainer(
                  customPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ProfileBanner(
                        nameSize: 14,
                        radius: 16,
                      ),
                      ValueListenableBuilder(
                          valueListenable: isFollowed,
                          builder: (context, val, _) {
                            return SizedBox(
                              width: 100,
                              child: PrimaryButton(
                                  height: 30,
                                  // isPadded: false,
                                  
                                  radius: 6,
                                  buttonColor: val
                                      ? AppColor.THEME_COLOR_SECONDARY
                                      : AppColor.THEME_COLOR_PRIMARY1,
                                  textColor: val
                                      ? AppColor.COLOR_BLACK
                                      : AppColor.COLOR_WHITE,
                                  textPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  text: val ? "Following" : "Follow",
                                  onTap: () {
                                    isFollowed.value = !isFollowed.value;
                                  }),
                            );
                          })
                    ],
                  ),
                );
              }),
            ]),
          )
        ],
      ),
    );
  }
}

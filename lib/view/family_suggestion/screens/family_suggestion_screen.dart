import 'package:flutter/material.dart';
import 'package:menu_minder/common/decision_container_widget.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/profile_with_name_and_desc_widget.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/dummy.dart';

class FamilySuggestionScreen extends StatelessWidget {
  const FamilySuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // _loadFamilyData(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
        child: PrimaryButton(
            text: "Give",
            onTap: () {
              AppDialog.showPlainDialog(
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetPath.ROUND_CHECK,
                        scale: 4,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Success",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColor.THEME_COLOR_PRIMARY1),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34.0),
                        child: AppStyles.contentStyle(
                          LOREMSMALL,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                          color: AppColor.COLOR_BLACK,
                        ),
                      ),
                      AppStyles.height16SizedBox(),
                      PrimaryButton(
                          text: "Continue",
                          onTap: () {
                            bottomIndex.value = 1;
                            AppNavigator.pushAndRemoveUntil(
                                context, const BottomBar());
                          })
                    ],
                  ),
                  context);
            }),
      ),
      appBar: AppStyles.pinkAppBar(context, "Family Members"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => DecisionContainer(
            containerColor: Colors.grey.shade200,
            customPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
            child: FamilySuggestWidget(
              index: index,
              notifier: ValueNotifier(false),
            ),
          ),
        ),
      ),
    );
  }
}

class FamilySuggestWidget extends StatelessWidget {
  final ValueNotifier notifier;
  final int index;

  const FamilySuggestWidget({
    super.key,
    required this.notifier,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // notifier.value = !notifier.value;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ProfileWithNameAndDescriptionWidget(
          //   name: "John Doe",
          //   desc: "Family Member",
          //   showDesc: index > 3,
          // ),
          ValueListenableBuilder(
              valueListenable: notifier,
              builder: (context, val, _) {
                return val
                    ? Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.THEME_COLOR_PRIMARY1),
                        child: const Icon(
                          Icons.check,
                          color: AppColor.COLOR_WHITE,
                          size: 22,
                        ),
                      )
                    : const SizedBox.shrink();
              })
        ],
      ),
    );
  }
}

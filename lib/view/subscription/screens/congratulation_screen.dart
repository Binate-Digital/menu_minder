import 'package:flutter/material.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/dummy.dart';

import '../../../common/primary_button.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/styles.dart';

class CongratulationScreen extends StatelessWidget {
  const CongratulationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppNavigator.pushAndRemoveUntil(context, const BottomBar());
        return false;
      },
      child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton(
                text: "Continue",
                onTap: () {
                  AppNavigator.pushAndRemoveUntil(context, const BottomBar());
                }),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AssetPath.ROUND_CHECK,
                  height: 150,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Congratulation",
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
                )
              ],
            ),
          )),
    );
  }
}

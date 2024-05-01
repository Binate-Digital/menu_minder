import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/web_screen.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/auth/screens/social_login_screen.dart';
import 'package:menu_minder/view/block_user/screens/block_user_screen.dart';
import 'package:menu_minder/view/subscription/screens/subscription_screen.dart';
import 'package:provider/provider.dart';

import '../../../common_model/profile.dart';
import '../../../utils/actions.dart';
import '../../../utils/app_constants.dart';
import '../widgets/settings_options_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // final bool value = context
    //             .read<NotificationProvider>()
    //             .userdata!
    //             .data!
    //             .userIsNotification ==
    //         1
    //     ? true
    //     : false;

    // ValueNotifier<bool> notification = ValueNotifier(value);

    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "Settings"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: Column(
          children: [
            Consumer<AuthProvider>(builder: (context, provider, _) {
              return SettingsOptionsWidget(
                notifier: provider.userdata?.data?.userIsNotification == 1
                    ? true
                    : false,
                heading: "Notifications",
              );
            }),
            AppStyles.height12SizedBox(),
            SettingsOptionsWidget(
              heading: "Block User",
              onTap: () {
                AppNavigator.push(context, const BlockUserScreen());
              },
            ),
            AppStyles.height12SizedBox(),
            SettingsOptionsWidget(
              heading: "Subscription",
              onTap: () {
                AppNavigator.push(
                    context,
                    const SubscriptionScreen(
                      isTrial: false,
                    ));
              },
            ),
            AppStyles.height12SizedBox(),
            SettingsOptionsWidget(
              heading: "Terms & Conditions",
              onTap: () {
                AppNavigator.push(
                    context,
                    const WebScreen(
                      isPrivacy: false,
                    ));
              },
            ),
            AppStyles.height12SizedBox(),
            SettingsOptionsWidget(
              heading: "Privacy Policy",
              onTap: () {
                AppNavigator.push(
                    context,
                    const WebScreen(
                      isPrivacy: true,
                    ));
              },
            ),
            AppStyles.height12SizedBox(),
            // PrimaryButton(
            //     text: "Logout",
            //     onTap: () {
            //       profile.value = Profile();
            //       bottomIndex.value = 0;
            //       AppNavigator.pushAndRemoveUntil(
            //           context, const SocialLoginScreen());
            //     }),
            // AppStyles.height12SizedBox(),
            PrimaryButton(
                text: "Delete Account",
                onTap: () {
                  AppDialog.showDialogs(
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 48),
                            child: AppStyles.headingStyle(
                                "Are you sure you want to delete your account?",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w400),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: PrimaryButton(
                                      text: "Cancel",
                                      buttonColor: Colors.grey.shade600,
                                      onTap: () {
                                        AppNavigator.pop(context);
                                      })),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Consumer<AuthProvider>(
                                  builder: (context, val, _) {
                                if (val.deleteAccountState == States.success) {
                                  profile.value = Profile();
                                  AppNavigator.pushAndRemoveUntil(
                                      context, const SocialLoginScreen());
                                  val.initState();
                                }
                                return val.deleteAccountState == States.loading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          CustomLoadingBarWidget(),
                                        ],
                                      )
                                    : PrimaryButton(
                                        text: "Delete",
                                        buttonColor: AppColor.COLOR_RED1,
                                        onTap: () {
                                          context
                                              .read<AuthProvider>()
                                              .deleteAccount();
                                        });
                              })),
                            ],
                          )
                        ],
                      ),
                      "Delete Account",
                      context);
                })
          ],
        ),
      ),
    );
  }
}

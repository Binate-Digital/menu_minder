import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/common/web_screen.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/view/auth/screens/phone_login_screens.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_background_widget.dart';
import '../../../common/primary_button.dart';
import '../../../common/transparent_container.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/styles.dart';
import '../../create_profile/screens/create_profile_screen.dart';
import '../bloc/models/user_model.dart';
import '../bloc/provider/auth_provider.dart';
import 'email_login_screen.dart';

class SocialLoginScreen extends StatefulWidget {
  const SocialLoginScreen({super.key});

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  UserModel? _userProvider;
  @override
  void initState() {
    // profile.value = Profile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWidget(
      backgroundColor: Colors.black,
      screenPadding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Image.asset(
            AssetPath.APP_LOGO,
            scale: 4.5,
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: TransparentContainer(
              child: Column(
                children: [
                  const Text(
                    "Pre Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColor.COLOR_WHITE),
                  ),
                  AppStyles.height20SizedBox(),
                  PrimaryButton(
                    text: "Sign in with Email",
                    onTap: () {
                      isEmail = true;
                      AppNavigator.push(context, const EmailLoginScreen());
                    },
                    imagePath: AssetPath.EMAIL,
                  ),
                  AppStyles.height8SizedBox(),
                  PrimaryButton(
                    text: "Sign in with Phone",
                    onTap: () {
                      isEmail = false;
                      AppNavigator.push(context, const PhoneLoginScreen());
                    },
                    imagePath: AssetPath.PHONE,
                    iconColor: Colors.white,
                    buttonColor: AppColor.COLOR_GREEN1,
                  ),
                  AppStyles.height8SizedBox(),
                  Consumer<AuthProvider>(builder: (context, val, _) {
                    if (val.socialState == States.success) {
                      val.initState();
                      _userProvider = context.read<AuthProvider>().userdata;
                      if (_userProvider!.data!.userIsVerified == 1) {
                        if (_userProvider!.data!.userIsComplete == 1) {
                          print(_userProvider!.data!.userAuthentication
                              .toString());
                          AppNavigator.pushAndRemoveUntil(
                              context, const BottomBar());
                        } else {
                          AppNavigator.pushAndRemoveUntil(
                              context,
                               CreateProfileScreen(
                                isEdit: false,
                              ));
                        }
                      }
                      val.initState();
                    }
                    return val.socialState == States.loading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                backgroundColor: AppColor.COLOR_WHITE,
                                color: AppColor.THEME_COLOR_PRIMARY1,
                              ),
                            ],
                          )
                        : PrimaryButton(
                            text: "Sign in with Google",
                            onTap: () {
                              context.read<AuthProvider>().signInWithGoogle();
                              // AppNavigator.pushAndRemoveUntil(
                              //     context, const BottomBar());
                            },
                            imagePath: AssetPath.GOOGLE,
                            buttonColor: AppColor.COLOR_RED1,
                          );
                  }),
                  AppStyles.height8SizedBox(),
                  if (Platform.isIOS)
                    Consumer<AuthProvider>(builder: (context, val, _) {
                      if (val.socialAppleState == States.success) {
                        _userProvider = context.read<AuthProvider>().userdata;
                        if (_userProvider!.data!.userIsVerified == 1) {
                          if (_userProvider!.data!.userIsComplete == 1) {
                            print(_userProvider!.data!.userAuthentication
                                .toString());
                            AppNavigator.pushAndRemoveUntil(
                                context, const BottomBar());
                          } else {
                            AppNavigator.pushAndRemoveUntil(
                                context,
                                 CreateProfileScreen(
                                  isEdit: false,
                                   name: _userProvider?.data?.userName ?? "",
                                ));

                            val.initState();
                          }
                        }
                        val.initState();
                      }

                      return val.socialAppleState == States.loading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(
                                  backgroundColor: AppColor.COLOR_WHITE,
                                  color: AppColor.THEME_COLOR_PRIMARY1,
                                ),
                              ],
                            )
                          : PrimaryButton(
                              text: "Sign in with Apple",
                              onTap: () {
                                print("apple");
                                context.read<AuthProvider>().signInWithApple();
                              },
                              imagePath: AssetPath.APPLE,
                              buttonColor: Colors.black,
                            );
                    }),
                  const Spacer(),
                  SizedBox(
                    // height: 33,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By Signing-in, you agree to our ',
                        style: const TextStyle(
                          color: AppColor.COLOR_WHITE,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '\nTerms & Conditions',
                            style: const TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                color: AppColor.THEME_COLOR_PRIMARY1),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                AppNavigator.push(
                                    context, const WebScreen(isPrivacy: false));
                              },
                          ),
                          const TextSpan(text: '  &  '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                color: AppColor.THEME_COLOR_PRIMARY1),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                AppNavigator.push(
                                    context, const WebScreen(isPrivacy: true));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

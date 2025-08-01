import 'dart:io';

import 'package:flutter/material.dart';
import 'package:menu_minder/common/transparent_container.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/models/login_model.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_background_widget.dart';
import '../../../common/primary_button.dart';
import '../../../common/primary_textfield.dart';
import '../../../utils/actions.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_validator.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/enums.dart';
import '../../../utils/styles.dart';
import 'otp_screen.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    return CustomBackgroundWidget(
        screenPadding: EdgeInsets.zero,
        appBar: AppStyles.appBar("", () {
          AppNavigator.pop(context);
        }, backrgroudColor: AppColor.TRANSPARENT_COLOR),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                AssetPath.APP_LOGO,
                scale: 4.5,
              ),
              const SizedBox(
                height: 40,
              ),
              Flexible(
                child: TransparentContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign In with Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppColor.COLOR_WHITE),
                      ),
                      AppStyles.height20SizedBox(),
                      PrimaryTextField(
                        hintText: "Email",
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        hasPrefix: true,
                        validator: (val) => AppValidator.emailValidation(val!),
                        prefixIconPath: AssetPath.EMAIL,
                        prefixColor: AppColor.THEME_COLOR_PRIMARY1,
                        errorColor: AppColor.COLOR_WHITE,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<AuthProvider>(builder: (context, val, _) {
                        if (val.loginState == States.success) {
                          // Utils.showToast(message: "Login successfully");
                          AppNavigator.push(
                              context,
                              OtpScreen(
                                isEmail: true,
                              ));
                          val.initState();
                        }

                        return val.loginState == States.loading
                            ? const CircularProgressIndicator(
                                backgroundColor: AppColor.COLOR_WHITE,
                                color: AppColor.THEME_COLOR_PRIMARY1,
                              )
                            : PrimaryButton(
                                text: "Continue",
                                onTap: () {
                                  isEmail = true;
                                  if (formKey.currentState!.validate()) {
                                    profile.value!.email = emailController.text;
                                    val.login(LoginModel(
                                        email: emailController.text,
                                        device_type: Platform.isIOS
                                            ? 'Ios'
                                            : 'Android',
                                      device_token: 'abc'
                                    ));
                                    // profile.value!.email = emailController.text.toString();
                                  }
                                });
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

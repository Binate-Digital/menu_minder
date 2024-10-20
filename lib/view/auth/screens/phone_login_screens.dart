import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:menu_minder/common/transparent_container.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/primary_button.dart';
import '../../../../common/primary_textfield.dart';
import '../../../../utils/actions.dart';
import '../../../../utils/app_functions.dart';
import '../../../../utils/asset_paths.dart';
import '../../../common/custom_background_widget.dart';
import '../../../utils/app_validator.dart';
import '../../../utils/dummy.dart';
import '../../../utils/styles.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FocusNode phoneNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    String code = "+1";
    String isoCOde = "US";

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
                height: 40,
              ),
              Image.asset(
                AssetPath.APP_LOGO,
                scale: 4,
              ),
              AppStyles.height20SizedBox(),
              Flexible(
                child: TransparentContainer(
                  child: Column(
                    children: [
                      const Text(
                        "Sign In with Phone",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppColor.COLOR_WHITE),
                      ),
                      AppStyles.height20SizedBox(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            decoration: AppStyles.countryPickerDecoration(),
                            child: CountryCodePicker(
                              onChanged: (v) {
                                code = v.dialCode!;
                                isoCOde = v.code!;
                                print(v.dialCode);
                              },
                              initialSelection: 'US',
                              favorite: const ['+1', 'US'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: KeyboardActions(
                              autoScroll: false,
                              config: AppFunctions.iosNumericKeyboard(
                                  context, phoneNode),
                              child: PrimaryTextField(
                                hintText: "Phone Number",
                                controller: phoneController,
                                inputType: TextInputType.number,
                                errorColor: AppColor.COLOR_WHITE,
                                focusNode: phoneNode,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                validator: (val) =>
                                    AppValidator.signPhoneValidation(val!),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<AuthProvider>(builder: (context, val, _) {
                        if (val.phoneState == States.success) {
                          // AppNavigator.push(
                          //               context,
                          //               OtpScreen(
                          //                 isEmail: false,
                          //               ));
                        }
                        return val.phoneState == States.loading
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
                                text: "Continue",
                                onTap: () {
                                  print(phoneController.text);

                                  isEmail = false;
                                  if (formKey.currentState!.validate()) {
                                    profile.value!.phone = phoneController.text;
                                    val.loginwithphone(
                                        isoCode: isoCOde,
                                        context: context,
                                        phoneNumber: phoneController.text,
                                        countrycode: code);
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

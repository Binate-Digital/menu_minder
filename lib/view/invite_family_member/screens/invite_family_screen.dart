import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_minder/common/custom_background_widget.dart';
import 'package:menu_minder/common/customize_international_country_code_picker/custom_phonenumber.dart';
import 'package:menu_minder/common/heading_textfield.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_validator.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_text.dart';
import '../../../common/customize_international_country_code_picker/custom_intl_phone_field.dart';
import '../../../utils/app_constants.dart';

class InviteFamilyScreen extends StatefulWidget {
  final bool isEdit;
  const InviteFamilyScreen({super.key, required this.isEdit});

  @override
  State<InviteFamilyScreen> createState() => _InviteFamilyScreenState();
}

class _InviteFamilyScreenState extends State<InviteFamilyScreen> {
  // List<String> realtionList = ["Husband", "Wife"];
  String? realtion = "Family Member";
  bool isInviteByEmail = true;

  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWidget(
        resizeToAvoidBottomInset: false,
        showBackground: !widget.isEdit,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
          child: Consumer<AuthProvider>(builder: (context, val, _) {
            if (val.addFamiltState == States.success) {
              Future.delayed(const Duration(milliseconds: 500), () {
                emailController.text = "";
                realtion = "";
                nameController.text = "";
              });
              // AppNavigator.push(
              //     context,
              //     const SubscriptionScreen(
              //       isTrial: true,
              //     ));
              val.initState();
            }
            return val.addFamiltState == States.loading
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
                    text: "Invite",
                    onTap: () {
                      if (widget.isEdit) {
                        if (_key.currentState!.validate()) {
                          if (realtion != null) {
                            // AppNavigator.pop(context);
                            val.addFamilt({
                              "user_email": emailController.text,
                              "relation": "Family Member",
                              "user_name": nameController.text
                            });
                          } else {
                            Utils.showToast(
                                message: "Please enter your relation");
                          }
                        }
                      } else {
                        if (_key.currentState!.validate()) {
                          if (realtion != null) {
                            val.addFamilt({
                              "user_email": emailController.text,
                              "relation": "Family Member",
                              "user_name": nameController.text
                            });
                          } else {
                            Utils.showToast(
                                message: "Please enter your relation");
                          }
                        }
                      }
                    });
          }),
        ),
        appBar: widget.isEdit
            ? AppStyles.pinkAppBar(context, "Invite Family Member")
            : AppStyles.appBar("Invite Family Member", () {
                AppNavigator.pop(context);
              }),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                AppStyles.height20SizedBox(),
                HeadingTextField(
                    heading: "Full Name",
                    controller: nameController,
                    headingColor: widget.isEdit
                        ? AppColor.COLOR_BLACK
                        : AppColor.COLOR_WHITE,
                    bgColor: widget.isEdit
                        ? Colors.grey.shade100
                        : AppColor.COLOR_WHITE,
                    inputFormat: [LengthLimitingTextInputFormatter(35)],
                    validator: (val) =>
                        AppValidator.validateField("Full Name", val!),
                    borderColor: widget.isEdit
                        ? AppColor.TRANSPARENT_COLOR
                        : AppColor.COLOR_BLACK),
                AppStyles.height16SizedBox(),

                // // Radio button to toggle invite method
                // RadioListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text('Invite via Email'),
                //   value: true,
                //   groupValue: isInviteByEmail,
                //   onChanged: (value) {
                //     setState(() {
                //       isInviteByEmail = value as bool;
                //     });
                //   },
                // ),
                // RadioListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text('Invite via Phone Number'),
                //   value: false,
                //   groupValue: isInviteByEmail,
                //   onChanged: (value) {
                //     setState(() {
                //       isInviteByEmail = value as bool;
                //     });
                //   },
                // ),

                isInviteByEmail
                    ? HeadingTextField(
                        heading: "Email Address",
                        validator: (val) => AppValidator.emailValidation(val!),
                        inputFormat: [LengthLimitingTextInputFormatter(50)],
                        headingColor: widget.isEdit
                            ? AppColor.COLOR_BLACK
                            : AppColor.COLOR_WHITE,
                        bgColor: widget.isEdit
                            ? Colors.grey.shade100
                            : AppColor.COLOR_WHITE,
                        borderColor: widget.isEdit
                            ? AppColor.TRANSPARENT_COLOR
                            : AppColor.COLOR_BLACK,
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                      )
                    : _phoneNoTextField(),
                AppStyles.height16SizedBox(),
                // HeadingDropDownField(
                //   items: realtionList,
                //   headingColor: widget.isEdit
                //       ? AppColor.COLOR_BLACK
                //       : AppColor.COLOR_WHITE,
                //   bgColor: widget.isEdit
                //       ? Colors.grey.shade100
                //       : AppColor.COLOR_WHITE,
                //   borderColor: widget.isEdit
                //       ? AppColor.TRANSPARENT_COLOR
                //       : AppColor.COLOR_BLACK,
                //   selected_value: realtion,
                //   onValueChanged: (v) {
                //     realtion = v;
                //     setState(() {});
                //   },
                //   heading: "Relation",
                //   hint: "Select",
                // ),
              ],
            ),
          ),
        ));
  }

  PhoneNumber? phoneNumber;

  Widget _phoneNoTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppString.TEXT_PHONE_NUMBER,
          fontColor:
              widget.isEdit ? AppColor.COLOR_BLACK : AppColor.COLOR_WHITE,
        ),
        const SizedBox(
          height: 8,
        ),
        IntlPhoneField(
          // focusNode: controller.otpFocusNode,
          showCountryFlag: true,
          // readOnly: _authProvider?.userdata?.data?.userSocialType == "phone",
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(19),
            filled: true,
            errorStyle: const TextStyle(color: AppColor.COLOR_RED1),
            fillColor:
                widget.isEdit ? Colors.grey.shade100 : AppColor.COLOR_WHITE,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 10,
              minHeight: 10,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 10,
              minHeight: 10,
            ),
            hintText: '',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.BG_COLOR,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.COLOR_WHITE,
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
          ),
          initialCountryCode: 'US',
          onChanged: (phone) {
            phoneNumber = phone;
            setState(() {});
            // controller.countryCodeValue = phone.countryISOCode;
            // controller.countryCodeNumber = phone.countryCode;
          },
          keyboardType: TextInputType.phone,
          controller: phone,
        ),
      ],
    );
  }
}

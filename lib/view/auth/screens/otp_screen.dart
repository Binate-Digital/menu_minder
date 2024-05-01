import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:menu_minder/common/transparent_container.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/view/auth/bloc/models/otp_verifiaction_model.dart';
import 'package:menu_minder/view/auth/bloc/models/resend_otp.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/auth/screens/social_login_screen.dart';
import 'package:menu_minder/view/create_profile/screens/create_profile_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../utils/actions.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/asset_paths.dart';
import '../../../../utils/styles.dart';
import '../../../common/custom_background_widget.dart';
import '../../../services/network/firbase_phone_login.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/dummy.dart';
import '../../../utils/utils.dart';

class OtpScreen extends StatefulWidget {
  bool? isEmail;
  String? countryCode;
  String? isoCode;
  String? phoneNumber, verificationID;
  OtpScreen(
      {Key? key,
      this.isEmail,
      this.countryCode,
      this.isoCode,
      this.phoneNumber,
      this.verificationID})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    // print(profile.value!.id.toString());

    Utils.showToast(
        message: isEmail
            ? "OTP verification code has been sent to your email address."
            : "OTP verification code has been sent to your phone number.");
    super.initState();
  }

  CountDownController countDownController = CountDownController();
  bool isTimerComplete = false;
  bool isComplete = false;
  final FocusNode otpNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    TextEditingController otp = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return CustomBackgroundWidget(
        screenPadding: EdgeInsets.zero,
        resizeToAvoidBottomInset: false,
        appBar: AppStyles.appBar("", () {
          AppNavigator.pushAndRemoveUntil(context, const SocialLoginScreen());
        }),
        child: WillPopScope(
          onWillPop: () async {
            AppNavigator.pushAndRemoveUntil(context, const SocialLoginScreen());
            return true;
          },
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetPath.APP_LOGO,
                      scale: 4,
                    ),
                    AppStyles.height20SizedBox(),
                    Flexible(
                      child: TransparentContainer(
                        child:
                            Consumer<AuthProvider>(builder: (context, val, _) {
                          if (val.otpState == States.success ||
                              val.socialState == States.success) {
                            if (val.userdata!.data!.userIsComplete == 1) {
                              AppNavigator.pushAndRemoveUntil(
                                  context, const BottomBar());
                            } else {
                              AppNavigator.pushAndRemoveUntil(
                                  context,
                                  const CreateProfileScreen(
                                    isEdit: false,
                                  ));
                            }

                            val.initState();
                          }
                          return Column(
                            children: [
                              AppStyles.headingStyle(
                                "Verification",
                                color: AppColor.COLOR_WHITE,
                              ),
                              AppStyles.height16SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: AppStyles.contentStyle(otpText,
                                    color: AppColor.COLOR_WHITE,
                                    fontSize: 14,
                                    textAlign: TextAlign.center),
                              ),
                              AppStyles.height16SizedBox(),
                              Theme(
                                data: ThemeData(
                                    colorScheme: ColorScheme.fromSwatch(
                                            primarySwatch: Colors.green)
                                        .copyWith(error: AppColor.COLOR_WHITE)),
                                child: KeyboardActions(
                                  config: AppFunctions.iosNumericKeyboard(
                                      context, otpNode),
                                  autoScroll: false,
                                  child: PinCodeTextField(
                                    appContext: context,
                                    length: 6,
                                    obscureText: false,
                                    focusNode: otpNode,
                                    cursorColor: AppColor.THEME_COLOR_PRIMARY1,
                                    animationType: AnimationType.fade,
                                    keyboardType: TextInputType.phone,
                                    pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        borderRadius: BorderRadius.circular(10),
                                        fieldHeight: 50,
                                        fieldWidth: 50,
                                        activeFillColor: Colors.white,
                                        inactiveFillColor: Colors.white,
                                        inactiveColor: Colors.black,
                                        activeColor: Colors.black,
                                        selectedFillColor: Colors.white,
                                        borderWidth: .5,
                                        activeBorderWidth: .5,
                                        inactiveBorderWidth: .5,
                                        selectedBorderWidth: .5,
                                        errorBorderColor: Colors.red,
                                        selectedColor: AppColor.COLOR_BLACK),
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    backgroundColor: Colors.transparent,
                                    enableActiveFill: true,
                                    controller: otp,
                                    onCompleted: (v) {
                                      isComplete = true;
                                      // if (v == "123456") {
                                      // AppNavigator.pushAndRemoveUntil(
                                      //     context,
                                      //     const CreateProfileScreen(
                                      //       isEdit: false,
                                      //     ));

                                      if (widget.isEmail == true) {
                                        val.otpVerify(OtpVerificationModel(
                                            verifiedCode: v,
                                            userId: profile.value!.id));
                                      } else {
                                        LoginWithPhoneService.instance
                                            .verifyPhoneCode(
                                                isoCode: widget.isoCode,
                                                countrycode:
                                                    widget.countryCode!,
                                                phoneNumber:
                                                    widget.phoneNumber!,
                                                context: context,
                                                socialType: 'phone',
                                                verificationId:
                                                    widget.verificationID!,
                                                verificationCode: v);
                                      }
                                      // }
                                    },
                                    onChanged: (value) {
                                      if (value.length == 6) {
                                        isComplete = true;
                                      } else {
                                        isComplete = false;
                                      }
                                    },
                                    validator: (val) {
                                      if (isComplete) {
                                        // if (val != "123456") {
                                        //   return 'Invalid OTP verification code.';
                                        // }
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              AppStyles.height16SizedBox(),
                              val.otpState == States.loading ||
                                      val.socialState == States.loading
                                  ? const CircularProgressIndicator(
                                      backgroundColor: AppColor.COLOR_WHITE,
                                      color: AppColor.THEME_COLOR_PRIMARY1,
                                    )
                                  : CircularCountDownTimer(
                                      duration: 59,
                                      initialDuration: 0,
                                      controller: countDownController,
                                      width: 111.0,
                                      height: 111.0,
                                      ringColor: Colors.white.withOpacity(0.3),
                                      fillColor: AppColor.THEME_COLOR_PRIMARY1,
                                      strokeWidth: 5.0,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.3),
                                      strokeCap: StrokeCap.round,
                                      textStyle: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                      textFormat: CountdownTextFormat.MM_SS,
                                      isReverse: true,
                                      isReverseAnimation: false,
                                      isTimerTextShown: true,
                                      autoStart: true,
                                      onStart: () {
                                        debugPrint('Countdown Started');
                                      },
                                      onComplete: () {
                                        isTimerComplete = true;
                                        debugPrint('Countdown Ended');
                                        setState(() {});
                                      },
                                    ),
                              const Spacer(),
                              Consumer<AuthProvider>(
                                  builder: (context, val, _) {
                                if (val.resendOtpState == States.success) {
                                  Utils.showToast(
                                      message: isEmail
                                          ? "We have resent OTP verification code at your email address."
                                          : "We have resent OTP verification code at your phone number.");
                                  countDownController.restart();
                                  val.initState();
                                }
                                return val.resendOtpState == States.loading
                                    ? const CircularProgressIndicator(
                                        backgroundColor: AppColor.COLOR_WHITE,
                                        color: AppColor.THEME_COLOR_PRIMARY1,
                                      )
                                    : SizedBox(
                                        height: 20,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: 'Didn\'t recieve a code? ',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Resend',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: isTimerComplete
                                                        ? AppColor
                                                            .THEME_COLOR_PRIMARY1
                                                        : AppColor.COLOR_WHITE,
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = isTimerComplete
                                                          ? () {
                                                              isTimerComplete =
                                                                  false;
                                                              if (isEmail) {
                                                                val.resendOtpVerify(
                                                                    ResendOTPCodeModel(
                                                                        user_id: profile
                                                                            .value!
                                                                            .id));
                                                              } else {
                                                                LoginWithPhoneService
                                                                    .instance
                                                                    .resendPhoneCode(
                                                                  setProgressBar: () =>
                                                                      Utils.progressAlertDialog(
                                                                          context:
                                                                              context),
                                                                  cancelProgressBar:
                                                                      () => Navigator
                                                                          .pop(
                                                                              context),
                                                                  context:
                                                                      context,
                                                                  phoneNumber: widget
                                                                          .countryCode ??
                                                                      '+1' +
                                                                          widget
                                                                              .phoneNumber!,
                                                                  getVerificationId:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      // widget.verificationID =
                                                                      //     value;

                                                                      print(
                                                                          "Verification ID :$value ");
                                                                    });
                                                                  },
                                                                );
                                                              }
                                                            }
                                                          : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              }),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

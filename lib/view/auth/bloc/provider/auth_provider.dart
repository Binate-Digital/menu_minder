import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/network/social_login_service.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/models/otp_verifiaction_model.dart';
import 'package:menu_minder/view/auth/bloc/models/resend_otp.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../services/network/firbase_phone_login.dart';
import '../../../../services/network/firebase_messaging_service.dart';
import '../../../../services/network/shared_preference.dart';
import '../../../../utils/dummy.dart';
import '../models/create_profile_model.dart';
import '../models/login_model.dart';
import '../models/social_query.dart';
import '../models/user_model.dart';
import '../repository/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  int? userId;
  //----------------------------------------------------------------//
  final AuthRepo _authRepo;
  final LoginWithPhoneService _loginWithPhoneService;
  AuthProvider(this._authRepo, this._loginWithPhoneService);
  //---------------AUTH STATES --------------------------------//
  States _loginStates = States.init;
  States get loginState => _loginStates;

  States _otpStates = States.init;
  States get otpState => _otpStates;

  States _resendOtpStates = States.init;
  States get resendOtpState => _resendOtpStates;

  States _createProfileStates = States.init;
  States get createProfileState => _createProfileStates;

  States _addFamilyStates = States.init;
  States get addFamiltState => _addFamilyStates;

  States _logoutStates = States.init;
  States get logoutState => _logoutStates;

  States _phoneState = States.init;
  States get phoneState => _phoneState;

  States _socialState = States.init;
  States get socialState => _socialState;

  States _socialAppleState = States.init;
  States get socialAppleState => _socialAppleState;

  States _deleteAccountState = States.init;
  States get deleteAccountState => _deleteAccountState;

  //---------------- models --------------------------------//
  UserModel? _userdata;
  UserModel? get userdata => _userdata;

  initState() {
    _loginStates = States.init;
    _otpStates = States.init;
    _createProfileStates = States.init;
    _resendOtpStates = States.init;
    _logoutStates = States.init;
    _addFamilyStates = States.init;
    _phoneState = States.init;
    _socialState = States.init;
    _socialAppleState = States.init;
    _deleteAccountState = States.init;

    // notifyListeners();
  }

  login(LoginModel? loginModel) async {
    try {
      _loginChangeState(States.loading);
      final firebaseToken = await FirebaseMessagingService().getToken();
      loginModel?.device_token = firebaseToken;
      print("Device Token ${loginModel?.toJson()}");

      Response? response =
          await _authRepo.loginIAuthentication(loginModel!.toJson());

      try {
        profile.value!.id = response!.data["data"]["_id"].toString();
        print("id${response.data["data"]["_id"]}");
        // SharedPreference().setBearerToken(
        //     token: UserModel.fromJson(response?.data).bearerToken);
        // SharedPreference().setUser(user: response.toString());
        // _userdata = UserModel.fromJson(response?.data);
        _loginChangeState(States.success);
      } catch (e) {
        _loginChangeState(States.failure);
        // Utils.showToast(message: response?.statusMessage);
      }
    } on DioException catch (_) {
      _loginChangeState(States.failure);
    }
  }

  otpVerify(OtpVerificationModel? otpVerificationModel) async {
    try {
      _otpChangeState(States.loading);
      Response? response = await _authRepo
          .otpVerificationIAuthentication(otpVerificationModel!.toJson());
      try {
        SharedPreference().setBearerToken(
            token: response?.data["data"]["user_authentication"]);
        SharedPreference().setUser(user: response.toString());
        _userdata = UserModel.fromJson(response?.data);
        _otpChangeState(States.success);
      } catch (e) {
        _otpChangeState(States.failure);
        Utils.showToast(message: response?.statusMessage);
      }
    } on DioException catch (_) {
      _otpChangeState(States.failure);
    }
  }

  resendOtpVerify(ResendOTPCodeModel? resendOTPCodeModel) async {
    try {
      _resendOtpChangeState(States.loading);
      Response? response = await _authRepo
          .resendOtpVerificationIAuthentication(resendOTPCodeModel!.toJson());
      try {
        _resendOtpChangeState(States.success);
      } catch (e) {
        _resendOtpChangeState(States.failure);
        // Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (_) {
      _resendOtpChangeState(States.failure);
    }
  }

  createProfile(
      BuildContext context, CreateProfileModel? createProfileModel) async {
    try {
      // print(createProfileModel?.toJson().toString());
      _createProfileChangeState(States.loading);

      var map = createProfileModel!.toJson();
      if (createProfileModel.userImage != null) {
        map["user_image"] = createProfileModel.userImage != null
            ? await dio.MultipartFile.fromFile(
                createProfileModel.userImage!,
              )
            : null;
      } else {
        map["user_image"] = createProfileModel.userImage != null
            ? createProfileModel.userImage!
            : null;
      }
      Response? response = await _authRepo.createProfileIAuthentication(
          context, dio.FormData.fromMap(map));
      print(response!.data["data"]["user_authentication"].toString());
      try {
        SharedPreference().setBearerToken(
            token: response.data["data"]["user_authentication"]);
        SharedPreference().setUser(user: response.toString());
        _userdata = UserModel.fromJson(response.data);
        _createProfileChangeState(States.success);
      } catch (e) {
        _createProfileChangeState(States.failure);
        // Utils.showToast(message: response.statusMessage);
      }
    } on DioException catch (_) {
      _createProfileChangeState(States.failure);
    }
  }

  addFamilt(Map<String, dynamic>? addFamilyModel) async {
    try {
      _addFamilyChangeState(States.loading);

      Response? response =
          await _authRepo.addFamilyIAuthentication(addFamilyModel);
      try {
        _addFamilyChangeState(States.success);
      } catch (e) {
        _addFamilyChangeState(States.failure);
        // Utils.showToast(message: response!.statusMessage);
      }
    } on DioException catch (_) {
      _addFamilyChangeState(States.failure);
    }
  }

  // LOGOUT
  logout(BuildContext context) async {
    try {
      _logoutChangeState(States.loading); //--- (STEP 5) ---//
      Response? response = await _authRepo.logoutIAuthentication({});

      try {
        _logoutChangeState(States.success);
        context.read<CoreProvider>().clearProvider();
        SharedPreference().clear();
      } catch (e) {
        _logoutChangeState(States.failure);
        initState();
        // Utils.showToast(message: response!.statusMessage);
      }
    } on DioException catch (_) {
      _logoutChangeState(States.failure);
      initState();
    }
  }

  deleteAccount() async {
    try {
      _deleteAccountChangeState(States.loading); //--- (STEP 5) ---//
      Response? response = await _authRepo.deleteAccountIAuthentication({});

      try {
        SharedPreference().clear();
        _deleteAccountChangeState(States.success);
      } catch (e) {
        _deleteAccountChangeState(States.failure);
        initState();
        // Utils.showToast(message: response!.statusMessage);
      }
    } on DioError catch (_) {
      _deleteAccountChangeState(States.failure);
      initState();
    }
  }

  signInWithGoogle() async {
    log("login with gmail function------------");
    Response? response;
    try {
      GoogleSignInAccount? user =
          await SocialLoginService().handleGoogleSignIn();

      if (user != null) {
        _socialChangeState(States.loading);
        response = await _authRepo.socialSignIn(SocialQueryModel(
          userSocialtoken: user.id,
          userDeviceToken: await FirebaseMessagingService().getToken(),
          userDeviceType: Platform.isAndroid ? "Android" : "Ios",
          userEmail: user.email.toString(),
          userSocialType: 'google',
        ));

        if (user.email.isNotEmpty) {
          print(user);

          profile.value!.email = user.email;

          log("email -----------------------${user.email}");

          setUser(response!.data);

          SharedPreference().setBearerToken(
              token: response.data["data"]["user_authentication"]);
          SharedPreference().setUser(user: response.toString());
          _userdata = UserModel.fromJson(response.data);
          Utils.showToast(message: "Signed in successfully");
          _socialChangeState(States.success);
          SocialLoginService().logout();
        } else {
          Utils.showToast(message: "Sign in failed");
          // SocialLoginService().logout();
          _socialChangeState(States.failure);
          initState();
        }
      }
    } on DioException catch (_) {
      SocialLoginService().logout();
      _socialChangeState(States.failure);
      initState();
      // Utils.showToast(message: response!.statusMessage);
    }
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      _appleChangeState(States.loading);
      AuthorizationCredentialAppleID? user =
          await SocialLoginService().appleSignIn();
      if (user != null) {
        Response? response = await _authRepo.socialSignIn(SocialQueryModel(
          userSocialtoken: user.userIdentifier,
          userDeviceToken: await FirebaseMessagingService().getToken(),
          userDeviceType: Platform.isAndroid ? "Android" : "Ios",
          userEmail: user.email,
          userSocialType: 'apple',
        ));
        profile.value!.email = user.email;

        log("email -----------------------${user.email}");
        setUser(response!.data);

        SharedPreference().setBearerToken(
            token: response.data["data"]["user_authentication"]);
        SharedPreference().setUser(user: response.toString());
        _userdata = UserModel.fromJson(response.data);
        Utils.showToast(message: "Signed in successfully");
        _appleChangeState(States.success);
      } else {
        Utils.showToast(message: "Sign in failed");
        _appleChangeState(States.failure);
      }
      // _socialLoginChangeState(States.success);
    } on DioException catch (_) {
      _appleChangeState(States.failure);
    }
    return null;
  }

  socialSignIn(
      {String? phonenumber,
      String? countryCode,
      String? verificationId,
      User? user,
      String? verificationCode}) async {
    log("login with phone function------------");
    try {
      _socialChangeState(States.loading);
      // AuthCredential _credential = PhoneAuthProvider.credential(
      //     verificationId: verificationId!, smsCode: verificationCode!);
      // _userCredential = await _firebaseAuth.signInWithCredential(_credential);

      // user = _userCredential?.user;

      // if (user != null) {
      // await _firebaseUserSignOut();
      log("user-------------------${user?.uid}");
      log("countryCode-------------------$countryCode");
      log("Phone Number-------------------$phonenumber");

      // log("token----------------${FirebaseMessagingService().getToken()}");
      final fcmToken = await FirebaseMessagingService().getToken();
      log("FCM TOKEN-------------------$fcmToken");

      Response? response = await _authRepo.socialSignIn(SocialQueryModel(
          userSocialtoken: user!.uid,
          userDeviceToken: fcmToken,
          userDeviceType: Platform.isAndroid ? "Android" : "Ios",
          userEmail: '',
          countryCode: CountryCode.fromCountryCode(countryCode ?? 'US').code,
          userSocialType: 'phone',
          userPhone: '$phonenumber'));

      log("response ----------------${response!.data}");
      setUser(response.data);
      SharedPreference().setUser(user: response.toString());
      SharedPreference()
          .setBearerToken(token: response.data["data"]["user_authentication"]);

      // Fluttertoast.showToast(msg: "Signed in succefully");
      _socialChangeState(States.success);
      //}
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      _socialChangeState(States.failure);

      Fluttertoast.showToast(msg: e.message ?? "");
    } catch (error) {
      _socialChangeState(States.failure);
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  ///-------------------- Phone Authentication Sign In -------------------- ///
  void loginwithphone(
      {required BuildContext context,
      String? phoneNumber,
      String? isoCode,
      String? countrycode}) {
    _loginWithPhoneService.signInWithPhone(
        countrycode: countrycode ?? '+1',
        isoCOde: isoCode ?? 'US',
        context: context,
        phoneNumber: '$phoneNumber',
        // phoneNumber: userPhoneNo ?? "",
        setProgressBar: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.THEME_COLOR_PRIMARY1,
                  ),
                );
              });
        },
        cancelProgressBar: () {
          Navigator.of(context);
        });
  }

  setUser(Map<String, dynamic> user) {
    _userdata = UserModel.fromJson(user);
    log("userdata----------------------${userdata?.data?.toJson()}");
  }

  setUserWithState(Map<String, dynamic> user) {
    _userdata = UserModel.fromJson(user);
    notifyListeners();
    log("userdata----------------------${userdata?.data?.toJson()}");
  }

  _loginChangeState(States state) {
    _loginStates = state;
    notifyListeners();
  }

  _otpChangeState(States state) {
    _otpStates = state;
    notifyListeners();
  }

  _resendOtpChangeState(States state) {
    _resendOtpStates = state;
    notifyListeners();
  }

  _createProfileChangeState(States state) {
    _createProfileStates = state;
    notifyListeners();
  }

  _logoutChangeState(States state) {
    _logoutStates = state;
    notifyListeners();
  }

  _socialChangeState(States state) {
    _socialState = state;
    notifyListeners();
  }

  _appleChangeState(States state) {
    _socialAppleState = state;
    notifyListeners();
  }

  _deleteAccountChangeState(States state) {
    _deleteAccountState = state;
    notifyListeners();
  }

  _addFamilyChangeState(States state) {
    _addFamilyStates = state;
    notifyListeners();
  }
}

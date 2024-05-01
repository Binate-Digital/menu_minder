import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart' as AS;
import 'package:provider/provider.dart';

import '../../utils/actions.dart';
import '../../view/auth/screens/otp_screen.dart';

class LoginWithPhoneService {
  final FirebaseAuth _firebase_auth = FirebaseAuth.instance;

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otpCode = TextEditingController();
  bool isLoading = false;
  static String? verificationIds;
  LoginWithPhoneService._();
  static final instance = LoginWithPhoneService._();
  AS.AuthProvider? _authProvider;

  ////////////////////////// Phone Sign In //////////////////////////////////
  Future<void> signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
    required String isoCOde,
    required VoidCallback setProgressBar,
    required VoidCallback cancelProgressBar,
    required String countrycode,
  }) async {
    setProgressBar();
    try {
      log("phonejwhjdbhwjdhjwbdjdhjwdbNumber");
      log(phoneNumber);

      FirebaseAuth.instance.verifyPhoneNumber(
          // phoneNumber: phoneNumber,
          phoneNumber: countrycode + phoneNumber,
          timeout: const Duration(seconds: 120),
          verificationCompleted: (AuthCredential authCredential) async {
            print("verification completed");
          },
          verificationFailed: (FirebaseAuthException authException) {
            log("Auth Exception " + authException.toString());
            if (authException.code == "Invalid Phone Number") {
              cancelProgressBar();
              // AppDialogs.showToast(
              //     message: AppStrings.INVALID_PHONE_NUMBER_MESSAGE);
            } else {
              cancelProgressBar();
              // AppDialogs.showToast(message: authException.message);
            }
            //print(authException.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            log("Verification Id:${verificationId}");

            profile.value!.id = verificationId;
            cancelProgressBar();
            verificationIds = verificationId;

            AppNavigator.push(
                context,
                OtpScreen(
                  isEmail: false,
                  isoCode: isoCOde,
                  countryCode: countrycode,
                  phoneNumber: phoneNumber,
                  verificationID: verificationId,
                ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log("Timeout Verification id: ${verificationId.toString()}");
          });
    } on FirebaseAuthException catch (e) {
      log("error" + e.toString());

      print('Failed with error code: ${e.code}');

      Fluttertoast.showToast(msg: e.message ?? "");
    } catch (error) {
      log("error" + error.toString());
      cancelProgressBar();
      // AppDialogs.showToast(message: error.toString());
    }
  }

  ///-------------------- Phone Authentication Sign In -------------------- ///
  // Future<void> signInWithPhoneNumber(
  //     {BuildContext? context, required String phoneNumber}) async {
  //   await _firebase_auth.verifyPhoneNumber(
  //       phoneNumber: "+11234567891",
  //       verificationCompleted: _onVerificationCompleted,
  //       verificationFailed: _onVerificationFailed,
  //       codeSent: _onCodeSent,
  //       codeAutoRetrievalTimeout: _onCodeTimeout);
  // }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;

    otpCode.text = authCredential.smsCode!;
    // setState(() {
    //
    // });
    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
            await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _firebase_auth.signInWithCredential(authCredential);
        }
      }
      isLoading = false;
      // setState(() {
      //
      // });
      // Navigator.pushNamedAndRemoveUntil(
      //     context, Constants.homeNavigate, (route) => false);
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      // showMessage("The phone number entered is invalid!");
      Utils.showToast(message: "The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    verificationIds = verificationId;
    print(forceResendingToken);
    print("code sent");
  }

  UserCredential? _userCredential;
  User? _user;

  Future<void> verifyPhoneCode(
      {required BuildContext context,
      String? socialType,
      String? isoCode,
      required String phoneNumber,
      required String countrycode,
      required String verificationId,
      required String verificationCode}) async {
    try {
      log("Verify Phone Code Starts");
      log("Verify Phone Code  ----------------$verificationCode");
      log(" Phone number  ----------------$phoneNumber");

      log("socialType  ----------------$socialType");
      log(" verificationId ----------------$verificationId");

      AuthCredential _credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: verificationCode);

      _userCredential = await _firebase_auth.signInWithCredential(_credential);

      _user = _userCredential?.user;

      if (_user != null) {
        await firebaseUserSignOut();

        log("Social Type: $socialType");
        log("Social Token: ${_user?.uid}");
        // API Call Here
        _authProvider = context.read<AS.AuthProvider>();
        _authProvider!.socialSignIn(
            user: _user,
            verificationCode: verificationCode,
            verificationId: verificationId,
            phonenumber: phoneNumber,
            countryCode: isoCode);
        // _socialLoginMethod(
        //   context,
        //   authName: socialType,
        //   socialToken: _user!.uid,
        // );
      }
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');

      Fluttertoast.showToast(msg: e.message ?? "");
    } catch (error) {
      showDialog(
          context: context,
          builder: (BuildContext builderContext) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("errorMessage"),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () async {
                    Navigator.of(builderContext).pop();
                  },
                )
              ],
            );
          });
    }
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void showMessage(String errorMessage, context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      // setState(() {
      isLoading = false;
      // });
    });
  }

  Future<void> resendPhoneCode(
      {required BuildContext context,
      required String phoneNumber,
      required ValueChanged<String> getVerificationId,
      required VoidCallback setProgressBar,
      required VoidCallback cancelProgressBar}) async {
    setProgressBar();
    try {
      try {
        _firebase_auth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (AuthCredential authCredential) async {
              // cancelProgressBar();
            },
            verificationFailed: (FirebaseAuthException authException) {
              // cancelProgressBar();

              Utils.showToast(message: authException.message);

              //print(authException.message);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              // cancelProgressBar();
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              // cancelProgressBar();

              log(verificationId.toString());
            });
      } catch (error) {
        cancelProgressBar();

        Utils.showToast(message: error.toString());
      }

      cancelProgressBar();

      /*   _firebase_auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            cancelProgressBar();

            Fluttertoast.showToast(msg: authException.message!);
            print(authException.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            cancelProgressBar();
            getVerificationId(verificationId);
          },
          codeAutoRetrievalTimeout: (verificationId) {
            cancelProgressBar();
            log(verificationId.toString());
            getVerificationId(verificationId);
          }); */
    } catch (error) {
      cancelProgressBar();
      Fluttertoast.showToast(msg: error.toString());
    }
  }

//   }

  ///-------------------- Sign Out -------------------- ///
  Future<void> firebaseUserSignOut() async {
    await _firebase_auth.signOut();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/view/auth/bloc/models/social_query.dart';

abstract class IAuthentication {
  Future<Response?> loginIAuthentication(Map<String, dynamic>? loginModel);
  Future<Response?> otpVerificationIAuthentication(
      Map<String, dynamic>? otpVerificationModel);
  Future<Response?> resendOtpVerificationIAuthentication(
      Map<String, dynamic>? resendOtpVerificationModel);
  Future<Response?> createProfileIAuthentication(
    BuildContext context,
    FormData? createProfileModel,
  );
  Future<Response?> addFamilyIAuthentication(
      Map<String, dynamic>? addFamilyModel);
  Future<Response?> logoutIAuthentication(Map<String, dynamic>? logoutModel);
  Future<Response?> deleteAccountIAuthentication(
      Map<String, dynamic>? logoutModel);

  Future<Response?> socialSignIn(SocialQueryModel socialLoginModel);

  Future<Response?> loaddAllNotifcations(Map data);
  Future<Response?> changeNotificationStatus(Map<String, dynamic>? data);
  Future<Response?> addAdminRecipes(Map<String, dynamic>? data);
}

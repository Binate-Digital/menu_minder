import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../services/network/dio_client.dart';
import '../../../../services/network/firebase_messaging_service.dart';
import '../../../../utils/app_navigator.dart';
import '../implements/i_authentication.dart';
import '../models/social_query.dart';

class AuthRepo implements IAuthentication {
  @override
  Future<Response?> socialSignIn(SocialQueryModel socialSignin) async =>
      await DioClient().postRequest(
          endPoint: dotenv.get("SOCIAL_LOGIN"), data: socialSignin.toJson());

  @override
  Future<Response?> loginIAuthentication(
          Map<String, dynamic>? loginModel) async =>
      await DioClient().postRequest(
        isHeaderRequire: false,
        isToast: true,
        queryParameters: {},
        isErrorToast: true,
        data: loginModel!,
        endPoint: dotenv.get('LOGIN'),
      );

  @override
  Future<Response?> otpVerificationIAuthentication(
          Map<String, dynamic>? otpVerificationModel) async =>
      await DioClient().postRequest(
        data: otpVerificationModel!,
        endPoint: dotenv.get('VERIFY'),
      );
  @override
  Future<Response?> resendOtpVerificationIAuthentication(
          Map<String, dynamic>? resendOtpVerficationModel) async =>
      await DioClient().postRequest(
        data: resendOtpVerficationModel!,
        endPoint: dotenv.get('RESEND_OTP'),
      );
  @override
  Future<Response?> createProfileIAuthentication(
          BuildContext context, FormData? createProfileModel) async =>
      await DioClient().postFileRequest(
        context: context,
        data: createProfileModel!,
        isHeaderRequire: true,
        endPoint: dotenv.get('UPDATE_PROFILE'),
      );
  @override
  Future<Response?> addFamilyIAuthentication(
          Map<String, dynamic>? createProfileModel) async =>
      await DioClient().postRequest(
        data: createProfileModel!,
        isHeaderRequire: true,
        endPoint: dotenv.get('SEND_INVITATION'),
      );
  @override
  Future<Response?> logoutIAuthentication(
          Map<String, dynamic>? logoutModel) async =>
      await DioClient().getRequest(
        context: StaticData.navigatorKey.currentContext,
        isHeaderRequire: true,
        queryParameters: logoutModel,
        endPoint: dotenv.get('LOGOUT'),
      );
  @override
  Future<Response?> deleteAccountIAuthentication(
          Map<String, dynamic>? deleteAccount) async =>
      await DioClient().getRequest(
        context: StaticData.navigatorKey.currentContext,
        isHeaderRequire: true,
        queryParameters: deleteAccount,
        endPoint: dotenv.get('DELETE_USER'),
      );

  @override
  Future<Response?> loaddAllNotifcations(Map data) async {
    return await DioClient().getRequest(
      context: StaticData.navigatorKey.currentContext,
      isHeaderRequire: true,
      isLoader: false,
      queryParameters: {},
      endPoint: dotenv.get('GETALL_NOTIFICATIONS'),
    );
  }

  @override
  Future<Response?> changeNotificationStatus(
          Map<String, dynamic>? deleteAccount) async =>
      await DioClient().getRequest(
        context: StaticData.navigatorKey.currentContext,
        isHeaderRequire: true,
        queryParameters: deleteAccount,
        endPoint: dotenv.get('NOTIFICATION_STATUS'),
      );

  @override
  Future<Response?> addAdminRecipes(Map<String, dynamic>? data) async =>
      await DioClient().getRequest(
        context: StaticData.navigatorKey.currentContext,
        isHeaderRequire: true,
        // queryParameters: deleteAccount,
        endPoint: dotenv.get('ADD_ADMIN_RECIPIES'),
      );
}

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/services/network/listeners.dart';
import 'package:menu_minder/services/network/shared_preference.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/screens/social_login_screen.dart';

import '../../utils/network_strings.dart';

import 'connectivity_manager.dart';

class DioClient {
  static Dio? _dio;

  static DioClient? _dioClient;

  static ConnectivityManager? _connectivityManager;

  static CancelToken? _cancelToken;

  DioClient._createInstance();

  factory DioClient() {
    if (_dioClient == null) {
      _dioClient = DioClient._createInstance();

      _getDio();
      _dio?.interceptors.add(LogInterceptor());

      _connectivityManager = ConnectivityManager();

      _cancelToken ??= CancelToken();
    }
    return _dioClient!;
  }

  static void _getDio() {
    _dio ??= Dio();
  }

  Future<Response?> getRequest({
    String? endPoint,
    Map<String, dynamic>? queryParameters,
    ResponseListener? responseListener,
    bool? isHeaderRequire,
    required BuildContext? context,
    Function()? onSuccess,
    Function()? onFailure,
    bool? isLoader,
    bool? isToast,
    bool? dismissONTap,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        response = await _dio?.get(
            endPoint != null
                ? dotenv.get("BASE_URL") + endPoint
                : dotenv.get("BASE_URL"),
            queryParameters: queryParameters,
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 90)));

        validateResponse(
            response: response,
            responseListener: responseListener,
            istoast: false,
            message: true);
      } on DioError catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        log("Dio Error:${e.response.toString()}");
        _validateException(
          context: context,
          response: e.response,
          message: e.message,
          // onFailure: onFailure,
          // isToast: isToast,
          // isErrorToast: isErrorToast
        );
        log("$endPoint Dio: ${e.message}");
        rethrow;
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  Future<Response?> postRequest({
    String? endPoint,
    dynamic data,
    bool? isHeaderRequire,
    BuildContext? context,
    ResponseListener? responseListener,
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    bool isErrorToast = true,
    bool? isLoader,
    bool? dismissONTap,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      print("sending Params: $data");
      try {
        response = await _dio?.post(dotenv.get("BASE_URL") + endPoint!,
            data: data,
            // queryParameters: queryParameters,
            // queryParameters: {
            //   "email":"test2@getnada.com"
            // },
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 90)));
        validateResponse(
            response: response,
            responseListener: responseListener,
            istoast: true,
            message: true);
      } on TimeoutException catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        print("$endPoint TimeOut: ${e.message!}");
      } on DioError catch (e) {
        log("Dio Error:${e.response.toString()}");
        _validateException(
            response: e.response,
            message: e.message,
            onFailure: onFailure,
            context: context,
            isToast: isToast,
            isErrorToast: isErrorToast);
        log("$endPoint Dio: ${e.message}");
        rethrow;
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  Future<Response?> postFileRequest(
      {String? endPoint,
      dynamic data,
      ResponseListener? responseListener,
      bool? isHeaderRequire,
      BuildContext? context,
      FormData? formData,
      Map<String, dynamic>? queryParameters,
      VoidCallback? onFailure,
      bool isToast = true,
      bool isErrorToast = true,
      bool? isLoader,
      bool? dismissONTap,
      dynamic map}) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      log("Post Response: " + SharedPreference().getBearerToken().toString());
      try {
        log("TITLE IS GOIING THISS " + data.toString());
        response = await _dio?.post(dotenv.get("BASE_URL") + endPoint!,
            // data: map
            // ,
            data: data,
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 90)));
        log("Post Response: $response");
      } on TimeoutException catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        print("$endPoint TimeOut: ${e.message!}");
      } on DioError catch (e) {
        log("Dio Error:${e.response.toString()}");
        _validateException(
            response: e.response,
            message: e.message,
            onFailure: onFailure,
            context: context,
            isToast: isToast,
            isErrorToast: isErrorToast);
        log("$endPoint Dio: ${e.message}");
        rethrow;
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  ////////////////// Put Request /////////////////////////
  Future<Response?> putRequest(
      {required BuildContext? context,
      required String endPoint,
      // Map<String, dynamic>? queryParameters,
      dynamic map,
      VoidCallback? onFailure,
      ResponseListener? responseListener,
      bool isToast = true,
      int connectTimeOut = 20000,
      bool isErrorToast = true,
      required bool isHeaderRequire}) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        // _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.put(dotenv.get("BASE_URL") + endPoint,
            data: map,
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 20)));
        print(response);
        validateResponse(
            response: response,
            responseListener: responseListener,
            istoast: true,
            message: true);
      } on TimeoutException catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        print("$endPoint TimeOut: ${e.message!}");
      } on DioException catch (e) {
        _validateException(
            response: e.response,
            context: context,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  Future<Response?> deleteRequest({
    String? endPoint,
    BuildContext? context,
    Map<String, dynamic>? queryParameters,
    ResponseListener? responseListener,
    bool? isHeaderRequire,
    dynamic deleteId,
    bool? isLoader,
    bool isErrorToast = true,
    VoidCallback? onFailure,
    bool isToast = true,
    bool? dismissONTap,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        print("abcded" + queryParameters.toString());
        response = await _dio!.delete(
            dotenv.get("BASE_URL") + endPoint! + deleteId,
            // queryParameters: queryParameters?['property_id'],
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 20)));
        print("respondi$response");
      } on TimeoutException catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        print("$endPoint TimeOut: ${e.message!}");
      } on DioException catch (e) {
        _validateException(
            response: e.response,
            context: context,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: ${e.message}");
        print("error Dio: ${e.error}");
        rethrow;
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  Future<Response?> deleteAccount({
    String? endPoint,
    BuildContext? context,
    Map<String, dynamic>? queryParameters,
    ResponseListener? responseListener,
    bool? isHeaderRequire,
    dynamic deleteId,
    bool? isLoader,
    bool isErrorToast = true,
    VoidCallback? onFailure,
    bool isToast = true,
    bool? dismissONTap,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        print("abcded" + queryParameters.toString());
        response = await _dio!.delete(dotenv.get("BASE_URL") + endPoint!,
            // queryParameters: queryParameters?['property_id'],
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 20)));
        print("respondi$response");
      } on TimeoutException catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        print("$endPoint TimeOut: ${e.message!}");
      } on DioException catch (e) {
        _validateException(
            response: e.response,
            context: context,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: ${e.message}");
        print("error Dio: ${e.error}");
        rethrow;
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  ///MAPS
  Future<Response?> getMapRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    ResponseListener? responseListener,
    bool? isHeaderRequire,
    required BuildContext? context,
    Function()? onSuccess,
    Function()? onFailure,
    bool? isLoader,
    bool? isToast,
    bool? dismissONTap,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        response = await _dio?.get(endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 90)));

        if (response?.statusCode == 200) {
          onSuccess?.call();
        } else {
          onFailure?.call();
        }

        // validateResponse(
        //     response: response,
        //     responseListener: responseListener,
        //     istoast: false,
        //     message: true);
      } on DioException catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        log("Dio Error:${e.response.toString()}");
        response = e.response;
        onFailure?.call();

        // _validateException(
        //   context: context,
        //   response: e.response,
        //   message: e.message,
        //   // onFailure: onFailure,
        //   // isToast: isToast,
        //   // isErrorToast: isErrorToast
        // );
        log("$endPoint Dio: ${e.message}");
        rethrow;
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  Future<Response?> getSpoonCularApi({
    String? endPoint,
    Map<String, dynamic>? queryParameters,
    ResponseListener? responseListener,
    bool? isHeaderRequire,
    required BuildContext? context,
    Function()? onSuccess,
    Function()? onFailure,
    bool? isLoader,
    bool? isToast,
    bool? dismissONTap,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        response = await _dio?.get(
            endPoint != null
                ? dotenv.get("SPOONCULAR_BASE_URL") + endPoint
                : dotenv.get("BASE_URL"),
            queryParameters: queryParameters,
            cancelToken: _cancelToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: const Duration(seconds: 90)));

        // validateResponse(
        //     response: response,
        //     responseListener: responseListener,
        //     istoast: false,
        // message: true);
      } on DioException catch (e) {
        _onTimeOut(message: e.message, responseListener: responseListener);
        log("Dio Error:${e.response.toString()}");
        // _validateException(
        //   context: context,
        //   response: e.response,
        //   message: e.message,
        //   // onFailure: onFailure,
        //   // isToast: isToast,
        //   // isErrorToast: isErrorToast
        // );
        log("$endPoint Dio: ${e.message}");
        rethrow;
      }
    } else {
      _noInternetConnection(responseListener: responseListener);
    }

    return response;
  }

  _setHeader({bool? isHeaderRequire}) {
    if (isHeaderRequire == true) {
      String? token = SharedPreference().getBearerToken();
      return {
        'Accept': NetworkStrings.ACCEPT,
        'Authorization': "Bearer $token",
        // 'Authorization':
        //     'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2VtYWlsIjoidXNlcjM0QGdldC5jb20iLCJ1c2VyX2lkIjoiNjU3MDc2NzE1YWYwMThlMWRiYjlkZmZkIiwiaWF0IjoxNzAyMzczMDI0fQ.VC67BNQ7-n_OH97i0PXSd7CfB7luqrhEflqxWXZoXWY'
      };
    } else {
      return {
        'Accept': NetworkStrings.ACCEPT,
      };
    }
  }

  void _validateException(
      {Response? response,
      String? message,
      required BuildContext? context,
      bool isToast = true,
      bool isErrorToast = true,
      VoidCallback? onFailure}) {
    print("exception m agya h ");
    if (onFailure != null) {
      onFailure();
    }

    if (response?.statusCode == NetworkStrings.BAD_REQUEST_CODE) {
      Utils.showToast(
          message:
              response?.data["message"] ?? NetworkStrings.BAD_REQUEST_CODE);
    } else if (response?.statusCode == NetworkStrings.UNAUTHORIZED_CODE) {
      print("unauthoirzed user ");
      Utils.showToast(message: response?.data["message"] ?? "");
      SharedPreference().clear();
      AppNavigator.pushAndRemoveUntil(context!, const SocialLoginScreen());
    } else if (response?.statusCode == NetworkStrings.BAD_REQUEST_CODE) {
      Utils.showToast(message: response?.statusMessage ?? message.toString());
    } else if (response?.statusCode == 503) {
      Utils.showToast(message: response?.statusMessage ?? message.toString());
    } else {
      isErrorToast
          ? Utils.showToast(
              message: response?.statusMessage ?? message.toString())
          : null;
    }
  }

  Future<void> validateResponse(
      {Response? response,
      ResponseListener? responseListener,
      bool message = false,
      bool istoast = true}) async {
    log(" validateResponse :${response?.data}");
    if (response != null) {
      var jsonResponse = response.data;
      log(" response:$jsonResponse");
      if (jsonResponse != null) {
        if (response.statusCode == NetworkStrings.SUCCESS_CODE) {
          print("ismein hai : ${response.statusCode}");

          istoast ? Utils.showToast(message: jsonResponse['message']) : null;
          if (jsonResponse['status'] == NetworkStrings.API_SUCCESS_STATUS) {
            if (responseListener != null) {
              log("responseListener.onSuccess");
              responseListener.onSuccess(response: jsonResponse);
            }
          }
          if (jsonResponse['status'] != NetworkStrings.API_SUCCESS_STATUS) {
            if (responseListener != null) {
              log("responseListener.onSuccess");
              responseListener.onFailure(response: jsonResponse);
            }
          } else if (jsonResponse['status'] == null) {
            if (responseListener != null) {
              log("responseListener.onSuccess");
              responseListener.onSuccess(response: jsonResponse);
            }
          } else if (response.statusCode == NetworkStrings.BAD_REQUEST_CODE) {
            if (responseListener != null) {
              log("responseListener.onFailure");
              log(jsonResponse['status'].toString());
              responseListener.onFailure(response: jsonResponse);
            }
          }
        } else {
          print("200 nh hai @@@@@@@@@@@@@@@@@@@@@@@@@@@@");
          if (responseListener != null) {
            responseListener.onFailure(response: jsonResponse);
          }
          log(response.statusCode.toString());
        }
      }
    }
  }

  void _noInternetConnection({ResponseListener? responseListener}) {
    if (responseListener != null) {
      responseListener.onFailure(response: {});
    }

    Utils.showToast(message: "NO_INTERNET_CONNECTION");
  }

  void _onTimeOut({String? message, ResponseListener? responseListener}) {
    if (responseListener != null) {
      responseListener.onFailure(response: {});
    }
  }
}

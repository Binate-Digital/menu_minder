// import 'package:dio/dio.dart';
// import 'package:menu_minder/utils/utils.dart';

// class DioInterceptors extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     if (options.path != (dotenv.get("BASE_URL"))) {
//       // Utils.showDialogs(
//       //   context: getP.Get.context!,
//       //   barrierDismissible: false,
//       //   widget: const Center(
//       //     child: CircularProgressIndicator(color: AppColors.colorPrimary),
//       //   ),
//       // );

//     }
//     // EasyLoading.dismiss();
//     return super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     // EasyLoading.dismiss();
//     if (response.requestOptions.path != (dotenv.get("BASE_URL"))) {
//       Navigator.pop(getP.Get.context!);
//     }
//     return super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioError err, ErrorInterceptorHandler handler) {
//     // EasyLoading.dismiss();
//     if (err.requestOptions.path != (dotenv.get("BASE_URL"))) {
//       Navigator.pop(getP.Get.context!);
//     }

//     Response? response = err.response;

//     String? errorMessage = _getErrorMessage(response: response);

//     Utils.showToast(message: errorMessage ?? err.message.toString());

//     // when status code= 401
//     if (err.response?.statusCode == Constants.UNAUTHORIZED_USER_CODE) {
//       _invalidAuthorization();
//     }

//     return;
//   }

//   void _invalidAuthorization() {
//     Utils.clearPreferences();
//     getP.Get.offAllNamed(Paths.LOGIN_SCREEN_ROUTE);
//   }

//   String? _getErrorMessage({Response? response}) {
//     String? errorMessage;

//     if (response?.data is Map<String, dynamic>) {
//       // Checking that API is returning JSON Object instead of crashing HTML
//       if (response?.data != null) {
//         if (response?.data["message"]) {
//           errorMessage = response?.data["message"];
//         }
//       } else {
//         errorMessage = response?.statusMessage;
//       }
//     }
//     return errorMessage;
//   }
// }

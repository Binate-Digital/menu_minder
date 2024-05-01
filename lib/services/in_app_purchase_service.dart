// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:menu_minder/providers/core_provider.dart';
// import 'package:menu_minder/services/network/firebase_messaging_service.dart';
// import 'package:menu_minder/utils/constants.dart';
// import 'package:menu_minder/utils/strings.dart';
// import 'package:menu_minder/utils/utils.dart';
// import 'package:provider/provider.dart';
// import 'dart:io' as IO;
// import '../utils/config.dart';
// import '../utils/network_strings.dart';
// import '../utils/toast.dart';

// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

// class InAppPurchaseService {
//   late InAppPurchase _inAppPurchase;

//   // final CoreProvider _subscriptionProvider = CoreProvider();

//   static var _productIds = {
//     // IO.Platform.isIOS
//     //     ? AppStrings.IOS_MONTHLY_SUBSCRIPTION_PRODUCT_ID
//     //     : AppStrings.ANDROID_MONTHLY_SUBSCRIPTION_PRODUCT_ID,
//     "monthly_subscription",
//   };

//   List<ProductDetails> _products = [];
//   List<String> _notFoundIDs = [];

//   StreamSubscription<List<PurchaseDetails>>? _subscription;

//   //api store ka object
//   //final _storeBloc = StoreBloc();

//   InAppPurchaseService() {
//     _inAppPurchase = InAppPurchase.instance;
//     // _subscriptionProvider =
//     //     BlocProvider.of<AuthenticationCubit>(MyApp.globalKey.currentContext!);
//   }

//   //jasa hi subscription hogi ya listener chalega
//   initPurchaseUpdated(BuildContext context) {
//     log("top");

//     Stream<List<PurchaseDetails>> purchaseUpdated =
//         _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       log("under listen");
//       _listenToPurchaseUpdated(purchaseDetailsList, context);
//     }, onDone: () {
//       log("onDone");
//       _subscription?.cancel();
//     }, onError: (error) {
//       // Toast_Message()
//       // CustomToast.showToast(
//       //     message: "Purchase Updated Stream Error: " + error.toString());
//     });
//   }

//   _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
//     log("purchase working");
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       log(purchaseDetails.status.name.toString());
//       try {
//         if (purchaseDetails.status == PurchaseStatus.pending) {
//           Utils.progressAlertDialog(context: context);
//           // show progress bar or something
//           // Utils.showToast(
//           //     message: "Purchase Status: " + AppStrings.PURCHASED_PENDING);
//         } else {
//           log("purchaseDetails.status  ${purchaseDetails.status}");
//           if (purchaseDetails.status == PurchaseStatus.error) {
//             // CustomToast error message or failure icon
//             CustomToast().showToast(
//                 message:
//                     "Purchase Status Error: ${purchaseDetails.error?.message ?? ""}");
//           } else if (purchaseDetails.status == PurchaseStatus.purchased) {
//             // if (Constants.isSubscriptionPurchased == true) {
//             print("Subscription Purchased");

//             log("susbcriptionBlocMethod");
//             Constants.isSubscriptionPurchased = false;

//             StaticData.navigatorKey.currentContext!
//                 .read<CoreProvider>()
//                 .subscription(
//                   context,
//                   packageName: IO.Platform.isIOS
//                       ? AppConfig.IOS_PACKAGE_NAME
//                       : AppConfig.ANDROID_PACKAGE_NAME,
//                   reciept:
//                       purchaseDetails.verificationData.serverVerificationData,
//                   userDeviceType: IO.Platform.isIOS ? "apple" : "google",
//                   productID: purchaseDetails.productID,
//                   purchaseToken: purchaseDetails.purchaseID!,
//                   // setProgressBar: () {
//                   //   Utils.progressAlertDialog(context: context);
//                   // },
//                   //purchaseDetails: purchaseDetails,
//                 );
//             // }
//           }

//           if (purchaseDetails.pendingCompletePurchase) {
//             print("Pending purchase");
//             await _inAppPurchase.completePurchase(purchaseDetails);
//           }

//           // if (Platform.isAndroid) {
//           //   if (purchaseDetails.productID == _kConsumableId) {
//           //     await _connection.consumePurchase(purchaseDetails);
//           //   }
//           // }
//         }
//       } catch (ex) {
//         print("Error Message:${ex.toString()}");
//         CustomToast().showToast(message: ex.toString());
//       }
//     });
//   }

//   //ya products lekr aiga
//   Future<List<ProductDetails>> initStoreInfo() async {
//     try {
//       final bool isAvailable = await _inAppPurchase.isAvailable();
//       print("bool isAvailable ${isAvailable}");

//       if (isAvailable) {
//         ProductDetailsResponse productDetailResponse =
//             await _inAppPurchase.queryProductDetails(_productIds);
//         print("product id" + _productIds.toString());

//         // CustomToast().showToast(
//         //     message: "Products Found: " +
//         //         (productDetailResponse.productDetails.length.toString() ?? ""));
//         // {"monthly_subscription"}.toSet());
//         // log("price  ${productDetailResponse.productDetails[0].title}");

//         log("Price ${productDetailResponse.productDetails.toString()}");

//         if (productDetailResponse.error == null) {
//           if (productDetailResponse.productDetails.isEmpty) {
//             CustomToast().showToast(message: AppString.PRODUCT_NOT_FOUND);
//           } else {
//             log("PRoducts aga ha");
//             _products = productDetailResponse.productDetails;
//             log("_products after updating ${_products.length}");
//             _notFoundIDs = productDetailResponse.notFoundIDs;
//             log("Not Found IDs $_notFoundIDs");
//           }
//         } else {
//           CustomToast().showToast(
//               message: "Query Product Details Error: " +
//                   (productDetailResponse.error?.message ?? ""));
//         }
//       } else {
//         CustomToast().showToast(message: NetworkStrings.NO_INTERNET_CONNECTION);
//       }
//     } catch (error) {
//       log("Error:${error.toString()}");
//       CustomToast().showToast(message: error.toString());
//     }

//     return _products;
//   }

//   //subscription button pr ya chalega
//   void subcribe({required ProductDetails productDetails}) async {
//     try {
//       if (_products.length > 0) {
//         final PurchaseParam purchaseParam =
//             PurchaseParam(productDetails: productDetails);
//         bool checkSubscribe =
//             await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

//         log("Check Subscribe:${checkSubscribe}");

//         // if (Platform.isIOS) {
//         //   var transactions = await SKPaymentQueueWrapper().transactions();
//         //   transactions.forEach((skPaymentTransactionWrapper) {
//         //     SKPaymentQueueWrapper()
//         //         .finishTransaction(skPaymentTransactionWrapper);
//         //   });
//         // }
//       }
//     } catch (error) {
//       print(error.toString());
//     }
//   }

//   void printWrapped(String text) {
//     final pattern = RegExp('.{1,1800}'); // 800 is the size of each chunk
//     pattern.allMatches(text).forEach((match) => print(match.group(0)));
//   }

//   void disposeSubscription() {
//     _subscription?.cancel();
//   }
// }

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/constants.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:provider/provider.dart';

import '../utils/network_strings.dart';

class InAppPurchaseService {
  late InAppPurchase _inAppPurchase;

  // final SubscriptionBloc _subscriptionBloc = SubscriptionBloc();

  static final _productIds = {
    // Platform.isIOS
    //     ? AppStrings.IOS_MONTHLY_SUBSCRIPTION_PRODUCT_ID
    //     : AppStrings.ANDROID_MONTHLY_SUBSCRIPTION_PRODUCT_ID,
    "monthly_subscription",
  };

  List<ProductDetails> _products = [];
  List<String> _notFoundIDs = [];

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  InAppPurchaseService() {
    _inAppPurchase = InAppPurchase.instance;
  }

  /// Jase hi subscription hogi ya listener chalega
  initPurchaseUpdated(BuildContext context) {
    log("top");

    Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      log("under listen");
      _listenToPurchaseUpdated(purchaseDetailsList, context);
    }, onDone: () {
      log("onDone");
      _subscription?.cancel();
    }, onError: (error) {
      Utils.showToast(message: "Purchase Updated Stream Error: $error");
    });
  }

  _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
    log("purchase working");

    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      try {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          // show progress bar or something
          // Utils.showToast(
          //     message: "Purchase Status: " + AppStrings.PURCHASED_PENDING);
        } else {
          log("purchaseDetails.status  ${purchaseDetails.status}");
          if (purchaseDetails.status == PurchaseStatus.error) {
            Utils.showToast(
                message:
                    "Purchase Status Error: ${purchaseDetails.error?.message ?? ""}");
          } else if (purchaseDetails.status == PurchaseStatus.purchased) {
            // if (Constants.isSubscriptionPurchased == true) {
            log("susbcriptionBlocMethod");
            // Constants.isSubscriptionPurchased = false;
            context.read<CoreProvider>().subscription(context,
                reciept:
                    purchaseDetails.verificationData.serverVerificationData,
                userDeviceType: Platform.isIOS ? 'apple' : 'google',
                packageName: "com.appsnado.menuminder",
                productID: purchaseDetails.productID,
                purchaseToken: purchaseDetails.purchaseID ?? "");
            // .blocMethod(
            //   context: context,
            //   packageName: 'com.appsnado.menuminder',
            //   receipt:
            //       purchaseDetails.verificationData.serverVerificationData,
            //   source: Platform.isIOS ? 'apple' : 'google',
            //   type: purchaseDetails.productID,
            //   purchaseToken: purchaseDetails.purchaseID,
            //   setProgressBar: () {
            //     Utils.progressAlertDialog(context: context);
            //   },
            // );
            // }
          }

          if (purchaseDetails.pendingCompletePurchase) {
            print("Pending purchase");
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      } catch (ex) {
        print("Error Message:${ex.toString()}");
        Utils.showToast(message: ex.toString());
      }
    });
  }

  /// This will load products
  Future<List<ProductDetails>> initStoreInfo() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();

      if (isAvailable) {
        ProductDetailsResponse productDetailResponse =
            await _inAppPurchase.queryProductDetails(_productIds);
        // log("price  ${productDetailResponse.productDetails[0].title}");
        if (productDetailResponse.error == null) {
          if (productDetailResponse.productDetails.isEmpty) {
            log("Product ki length ");
            log(productDetailResponse.productDetails.length.toString());
            Utils.showToast(message: AppString.PRODUCT_NOT_FOUND);
          } else {
            log("Products aga ha");
            _products = productDetailResponse.productDetails;
            log("_products after updating ${_products.length}");
            _notFoundIDs = productDetailResponse.notFoundIDs;
            log("Not Found IDs $_notFoundIDs");
          }
        } else {
          Utils.showToast(
              message:
                  "Query Product Details Error: ${productDetailResponse.error?.message ?? ""}");
        }
      } else {
        Utils.showToast(message: NetworkStrings.NO_INTERNET_CONNECTION);
      }
    } catch (error) {
      log("Error:${error.toString()}");
      Utils.showToast(message: error.toString());
    }

    return _products;
  }

  //subscription button pr ya chalega
  void subscribe({required ProductDetails productDetails}) async {
    try {
      if (_products.isNotEmpty) {
        final PurchaseParam purchaseParam =
            PurchaseParam(productDetails: productDetails);
        bool checkSubscribe =
            await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

        log("Check Subscribe:$checkSubscribe");

        // if (purchase.pendingCompletePurchase) {
        //   _inAppPurchase.completePurchase(purchase);
        // }

        // if (Platform.isIOS) {
        //   var transactions = await SKPaymentQueueWrapper().transactions();
        //   transactions?.forEach((skPaymentTransactionWrapper) {
        //     SKPaymentQueueWrapper()
        //         .finishTransaction(skPaymentTransactionWrapper);
        //   });
        // }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,1800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void disposeSubscription() {
    _subscription?.cancel();
  }
}

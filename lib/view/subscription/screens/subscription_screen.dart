import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/in_app_purchase_service.dart';
import 'package:menu_minder/services/network/shared_preference.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/config.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/strings.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/auth/screens/social_login_screen.dart';
import 'package:menu_minder/view/subscription/screens/congratulation_screen.dart';
import 'package:provider/provider.dart';

import '../../../utils/bottom_bar.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool isTrial;
  final bool showLogout;
  final bool logoutKrdo;
  final bool isFromProfile;
  const SubscriptionScreen(
      {super.key,
      required this.isTrial,
      this.isFromProfile = false,
      this.logoutKrdo = false,
      this.showLogout = false});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  InAppPurchaseService _inAppPurchaseService = InAppPurchaseService();
  List<ProductDetails> _products = [];
  bool _productsWaiting = true;
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await InAppPurchaseService().initStoreInfo();
    // });
    // _setSubscriptionListener();
    // _getInAppPurchaseProducts();
    _setSubscriptionListener();
    _getInAppPurchaseProducts();

    super.initState();
  }

  void _getInAppPurchaseProducts() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _products = await _inAppPurchaseService.initStoreInfo();
        _productsWaiting = false;
        setState(() {});
        log("_products  at _getInAppPurchaseProducts ${_products}");
      },
    );
  }

  void _setSubscriptionListener() {
    _inAppPurchaseService.initPurchaseUpdated(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _inAppPurchaseService.disposeSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.logoutKrdo
          ? () async {
              print("Logout Hogyaa");
              context.read<CoreProvider>().clearProvider();
              SharedPreference().clear();
              AppNavigator.pushAndRemoveUntil(
                  context, const SocialLoginScreen());
              return true;
            }
          : () async {
              AppNavigator.pop(context);
              return true;
              // context.read<AuthProvider>().logout(context);
            },
      child: Scaffold(
        bottomNavigationBar: widget.isTrial
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: PrimaryButton(
                    text: "Start Free 7 days Trial",
                    onTap: () {
                      AppNavigator.pushAndRemoveUntil(
                          context, const CongratulationScreen());
                    }),
              )
            : const SizedBox.shrink(),
        appBar: AppStyles.pinkAppBar(context, "Subscription",
            trailing: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: widget.showLogout
                  ? Consumer<AuthProvider>(builder: (context, val, _) {
                      if (val.logoutState == States.success) {
                        AppNavigator.pushAndRemoveUntil(
                            context, const SocialLoginScreen());
                      }
                      if (val.logoutState == States.loading) {
                        return const SizedBox(
                          height: 10,
                          width: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              // backgroundColor: Colors.white,
                              color: AppColor.COLOR_WHITE,
                              // color: Colo,
                            ),
                          ),
                        );
                      }
                      return InkWell(
                        onTap: () {
                          context.read<AuthProvider>().logout(context);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.login),
                            SizedBox(
                              width: 3,
                            ),
                            Text('Logout'),
                          ],
                        ),
                      );
                    })
                  : null,
            ),
            onleadingTap: widget.logoutKrdo
                ? () {
                    print("Logout Hogyaa");
                    context.read<CoreProvider>().clearProvider();
                    SharedPreference().clear();
                    AppNavigator.pushAndRemoveUntil(
                        context, const SocialLoginScreen());
                  }
                : () {
                    log("ONME TIME BACK");
                    AppNavigator.pop(context);
                    // context.read<AuthProvider>().logout(context);
                  },
            // leading: null,
            // onleadingTap: widget.showLogout
            //     ? () {
            //         print("SHOWIMNH LOGOUT TAPPED");
            //         AppNavigator.pushAndRemoveUntil(context, const BottomBar());
            //       }
            //     : widget.isFromProfile
            //         ? () {
            //             // AppNavigator.pushAndRemoveUntil(
            //             //     context, const BottomBar());

            //             context.read<AuthProvider>().logout(context);
            //           }
            //         : null,
            isFromCreateProfile: false,
            hasBack: false,
            leading: widget.showLogout
                ? InkWell(
                    onTap: () {
                      context.read<AuthProvider>().logout(context);
                    },
                    child: const Icon(Icons.close))
                : InkWell(
                    child: const Icon(Icons.arrow_back),
                    onTap: () {
                      if (widget.logoutKrdo) {
                        context.read<CoreProvider>().clearProvider();
                        SharedPreference().clear();

                        AppNavigator.pushAndRemoveUntil(
                            context, const SocialLoginScreen());
                      } else {
                        AppNavigator.pop(context);
                      }
                    },
                  )
            // hasBack: !widget.showLogout,
            ),
        body: _productsWaiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  AppStyles.height20SizedBox(),

                  _products.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimen.LOGIN_BUTTON_VERT_PADDING),
                          child: SizedBox(
                            height: 300,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(
                                        left: 2.0, right: 2, bottom: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                AppColor.THEME_COLOR_SECONDARY,
                                            width: 2)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 60,
                                          alignment: Alignment.center,
                                          decoration:
                                              AppStyles.dialogLinearGradient(),
                                          child: const Text(
                                            'Subscription Plan Monthly',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: AppColor.COLOR_WHITE),
                                          ),
                                        ),
                                        AppStyles.height16SizedBox(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _products.first.currencySymbol,
                                              style: const TextStyle(
                                                  color: AppColor.COLOR_BLACK,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              _products.first.rawPrice
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor
                                                      .THEME_COLOR_PRIMARY1),
                                            ),
                                          ],
                                        ),
                                        AppStyles.height16SizedBox(),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5, bottom: 5),
                                                child: CircleAvatar(
                                                  backgroundColor: AppColor
                                                      .THEME_COLOR_SECONDARY,
                                                  radius: 12,
                                                  child: Icon(
                                                    Icons.check,
                                                    color: AppColor.COLOR_BLACK,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3),
                                                  child: CustomText(
                                                    lineSpacing: 1.3,
                                                    textAlign: TextAlign.start,
                                                    text: _products
                                                        .first.description,
                                                    maxLines: 5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        // Flexible(
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     children: List.generate(
                                        //         1,
                                        //         (index) => Padding(
                                        //               padding:
                                        //                   const EdgeInsets.all(
                                        //                       6.0),
                                        //               child: Row(
                                        //                 mainAxisAlignment:
                                        //                     MainAxisAlignment
                                        //                         .center,
                                        //                 children: const [
                                        //                   CircleAvatar(
                                        //                     backgroundColor:
                                        //                         AppColor
                                        //                             .THEME_COLOR_SECONDARY,
                                        //                     radius: 12,
                                        //                     child: Icon(
                                        //                       Icons.check,
                                        //                       color: AppColor
                                        //                           .COLOR_BLACK,
                                        //                       size: 18,
                                        //                     ),
                                        //                   ),
                                        //                   SizedBox(
                                        //                     width: 10,
                                        //                   ),
                                        //                   Text(_products.first
                                        //                       .description.toString()),
                                        //                 ],
                                        //               ),
                                        //             )),
                                        //   ),
                                        // )
                                      ],
                                    )),
                                Consumer<CoreProvider>(
                                    builder: (context, val, _) {
                                  return SizedBox(
                                      width: 200,
                                      child: PrimaryButton(
                                          text:
                                              //  val.subscribed == 1
                                              "Buy Now",
                                          // : "Buy Now",
                                          onTap: () {
                                            // if (widget.isTrial) {
                                            //   AppNavigator.pushAndRemoveUntil(
                                            //       context,
                                            //       const CongratulationScreen());

                                            _inAppPurchaseService.subscribe(
                                                productDetails:
                                                    _products.first);
                                            // } else {
                                            // if (val.subscribed == 1) {
                                            // } else {}

                                            // AppNavigator.pop(context);
                                            // }
                                          }));
                                })
                              ],
                            ),
                          ),
                        )
                      : const Center(
                          child: CustomText(
                            textAlign: TextAlign.center,
                            text: 'No Products Found',
                          ),
                        ),

                  AppStyles.height16SizedBox(),

                  // SizedBox(
                  //   height: 200,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 12),
                  //     child: ListView.separated(
                  //         separatorBuilder: (context, index) {
                  //           return const SizedBox(
                  //             height: 10,
                  //           );
                  //         },
                  //         itemCount: _products.length ?? 0,
                  //         itemBuilder: (context, index) {
                  //           final product = _products[index];
                  //           return ListTile(
                  //             tileColor: AppColor.THEME_COLOR_SECONDARY
                  //                 .withOpacity(.4),
                  //             // contentPadding: EdgeInsets.all(12),
                  //             title: Text(
                  //               product.title,
                  //               style: const TextStyle(fontSize: 16),
                  //             ),
                  //             trailing: Text(product.price),
                  //           );
                  //         }),
                  //   ),
                  // ),

                  // CarouselSlider(
                  //   options: CarouselOptions(height: 400, enlargeCenterPage: true),
                  //   items: [1].map((i) {
                  //     return Builder(
                  //       builder: (BuildContext context) {
                  //         return

                  //         Stack(
                  //           alignment: Alignment.bottomCenter,
                  //           children: [
                  //             Container(
                  //                 width: MediaQuery.of(context).size.width,
                  //                 margin: const EdgeInsets.only(
                  //                     left: 2.0, right: 2, bottom: 20),
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     border: Border.all(
                  //                         color: AppColor.THEME_COLOR_SECONDARY,
                  //                         width: 2)),
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   children: [
                  //                     Container(
                  //                       width: double.infinity,
                  //                       height: 60,
                  //                       alignment: Alignment.center,
                  //                       decoration: AppStyles.dialogLinearGradient(),
                  //                       child: const Text(
                  //                         'Subscription Plan Monthly',
                  //                         style: TextStyle(
                  //                             fontSize: 16.0,
                  //                             color: AppColor.COLOR_WHITE),
                  //                       ),
                  //                     ),
                  //                     AppStyles.height16SizedBox(),
                  //                     Row(
                  //                       mainAxisAlignment: MainAxisAlignment.center,
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: const [
                  //                         Text(
                  //                           '\$',
                  //                           style: TextStyle(
                  //                               color: AppColor.COLOR_BLACK,
                  //                               fontSize: 18,
                  //                               fontWeight: FontWeight.bold),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 2,
                  //                         ),
                  //                         Text(
                  //                           '7.99',
                  //                           style: TextStyle(
                  //                               fontSize: 30,
                  //                               fontWeight: FontWeight.bold,
                  //                               color: AppColor.THEME_COLOR_PRIMARY1),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     AppStyles.height16SizedBox(),
                  //                     Flexible(
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.center,
                  //                         children: List.generate(
                  //                             5,
                  //                             (index) => Padding(
                  //                                   padding:
                  //                                       const EdgeInsets.all(6.0),
                  //                                   child: Row(
                  //                                     mainAxisAlignment:
                  //                                         MainAxisAlignment.center,
                  //                                     children: const [
                  //                                       CircleAvatar(
                  //                                         backgroundColor: AppColor
                  //                                             .THEME_COLOR_SECONDARY,
                  //                                         radius: 12,
                  //                                         child: Icon(
                  //                                           Icons.check,
                  //                                           color:
                  //                                               AppColor.COLOR_BLACK,
                  //                                           size: 18,
                  //                                         ),
                  //                                       ),
                  //                                       SizedBox(
                  //                                         width: 10,
                  //                                       ),
                  //                                       Text("Lorem ipsum dolor sit"),
                  //                                     ],
                  //                                   ),
                  //                                 )),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 )),
                  //             SizedBox(
                  //                 width: 200,
                  //                 child: PrimaryButton(
                  //                     text: "Buy Now",
                  //                     onTap: () {
                  //                       if (widget.isTrial) {
                  //                         AppNavigator.pushAndRemoveUntil(
                  //                             context, const CongratulationScreen());
                  //                       } else {
                  //                         context.read<CoreProvider>().subscription(
                  //                             context,
                  //                             productID: 'dummy',
                  //                             packageName:
                  //                                 AppConfig.ANDROID_PACKAGE_NAME,
                  //                             purchaseToken: 'abc',
                  //                             reciept: 'sdsdsdwef',
                  //                             userDeviceType: Platform.isAndroid
                  //                                 ? 'android'
                  //                                 : 'ios');
                  //                         // AppNavigator.pop(context);
                  //                       }
                  //                     }))
                  //           ],
                  //         );

                  //       },
                  //     );
                  //   }).toList(),
                  // ),

                  const SizedBox(
                    height: 50,
                  ),
                  // SizedBox(
                  //     width: 100, child: PrimaryButton(text: 'Logout', onTap: () {}))
                ],
              ),
      ),
    );
  }
}

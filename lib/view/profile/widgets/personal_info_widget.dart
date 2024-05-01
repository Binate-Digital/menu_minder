// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/meal_plan/screens/data/friend_profile_model.dart';
import 'package:menu_minder/view/profile/widgets/profile_info_counter_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/enums.dart';
import '../../../common/primary_button.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/rounded_image.dart';

class ProfileScreenPersonInfo extends StatelessWidget {
  String? leftButtonText;
  VoidCallback? leftButtonTap;
  VoidCallback? rightButtonTap;
  VoidCallback? onFollowers;
  VoidCallback? onFollowing;
  String? rightButtonText;
  Color? leftButtonColor;
  Color? leftTextColor;
  ProfileScreenPersonInfo({
    Key? key,
    this.leftButtonText,
    this.leftButtonTap,
    this.rightButtonTap,
    this.onFollowers,
    this.onFollowing,
    this.rightButtonText,
    this.leftButtonColor = AppColor.COLOR_WHITE,
    this.leftTextColor = AppColor.THEME_COLOR_PRIMARY1,
  }) : super(key: key);
  AuthProvider? _authProvider;
  @override
  Widget build(BuildContext context) {
    _authProvider = context.read<AuthProvider>();
    return Container(
        height: 180,
        decoration: const BoxDecoration(
            color: AppColor.THEME_COLOR_PRIMARY1,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Consumer<AuthProvider>(builder: (context, val, p) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedImage(
                                scale: 1,
                                backgroundColor: AppColor.COLOR_WHITE,
                                image: _authProvider!
                                                .userdata!.data!.userImage !=
                                            null &&
                                        _authProvider!
                                                .userdata!.data!.userImage !=
                                            ""
                                    ? _authProvider!.userdata!.data!.userImage
                                    : AssetPath.PROFILE,
                                radius: 60,
                                borderWidth: 10,
                                borderColor: AppColor.COLOR_WHITE,
                                imageType:
                                    _authProvider!.userdata!.data!.userImage !=
                                                null &&
                                            _authProvider!.userdata!.data!
                                                    .userImage !=
                                                ""
                                        ? ImageType.TYPE_NETWORK
                                        : ImageType.TYPE_ASSET,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                _authProvider?.userdata?.data?.userName ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              // const Text(
                              //   "(Family Member)",
                              //   style: TextStyle(
                              //       color: Colors.white, fontSize: 13),
                              //   textAlign: TextAlign.center,
                              //   maxLines: 1,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // IntrinsicHeight(
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       const SizedBox(
                              //         width: 10,
                              //       ),
                              //       // InkWell(
                              //       //   onTap: onFollowers,
                              //       //   child: const ProfileInfoWidget(
                              //       //     heading: "Followers",
                              //       //     quantity: "0",
                              //       //   ),
                              //       // ),
                              //       SizedBox(),
                              //       const VerticalDivider(
                              //         color: Colors.white,
                              //         thickness: 1.2,
                              //       ),
                              //       // InkWell(
                              //       //   onTap: onFollowing,
                              //       //   child: const ProfileInfoWidget(
                              //       //     heading: "Following",
                              //       //     quantity: "0",
                              //       //   ),
                              //       // ),
                              //       const SizedBox(
                              //         width: 10,
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: PrimaryButton(
                                      height: 35,
                                      text: leftButtonText ?? "Edit Profile",
                                      buttonTextSize: 12,
                                      onTap: leftButtonTap ?? () {},
                                      isPadded: false,
                                      buttonColor:
                                          leftButtonColor ?? Colors.white,
                                      textColor: leftTextColor ??
                                          AppColor.THEME_COLOR_PRIMARY1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: PrimaryButton(
                                      text: rightButtonText ?? "Settings",
                                      height: 35,
                                      buttonTextSize: 12,
                                      onTap: rightButtonTap ?? () {},
                                      isPadded: false,
                                      buttonColor: Colors.white,
                                      textColor: AppColor.THEME_COLOR_PRIMARY1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        }));
  }
}

class FriendProfileInfo extends StatelessWidget {
  String? leftButtonText;
  VoidCallback? leftButtonTap;
  final FriendData? friendData;
  VoidCallback? rightButtonTap;
  VoidCallback? onFollowers;
  VoidCallback? onFollowing;
  String? rightButtonText;
  Color? leftButtonColor;
  Color? leftTextColor;
  FriendProfileInfo({
    Key? key,
    this.leftButtonText,
    this.leftButtonTap,
    this.rightButtonTap,
    this.friendData,
    this.onFollowers,
    this.onFollowing,
    this.rightButtonText,
    this.leftButtonColor = AppColor.COLOR_WHITE,
    this.leftTextColor = AppColor.THEME_COLOR_PRIMARY1,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        decoration: const BoxDecoration(
            color: AppColor.THEME_COLOR_PRIMARY1,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedImage(
                              scale: 1,
                              backgroundColor: AppColor.COLOR_WHITE,
                              image: friendData?.userImage != null &&
                                      friendData?.userImage != ""
                                  ? friendData?.userImage
                                  : AssetPath.PROFILE,
                              radius: 60,
                              borderWidth: 10,
                              borderColor: AppColor.COLOR_WHITE,
                              imageType: friendData?.userImage != null &&
                                      friendData?.userImage != ""
                                  ? ImageType.TYPE_NETWORK
                                  : ImageType.TYPE_ASSET,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              friendData?.userName ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const Text(
                              "(Family Member)",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // IntrinsicHeight(
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       const SizedBox(
                            //         width: 10,
                            //       ),
                            //       InkWell(
                            //         onTap: onFollowers,
                            //         child: ProfileInfoWidget(
                            //           heading: "Followers",
                            //           quantity: friendData?.followers != null
                            //               ? friendData!.followers.toString()
                            //               : "0",
                            //         ),
                            //       ),
                            //       const VerticalDivider(
                            //         color: Colors.white,
                            //         thickness: 1.2,
                            //       ),
                            //       InkWell(
                            //         onTap: onFollowing,
                            //         child: ProfileInfoWidget(
                            //           heading: "Following",
                            //           quantity: friendData?.following != null
                            //               ? friendData!.following.toString()
                            //               : "0",
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 10,
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            const SizedBox(
                              height: 20,
                            ),

                            PrimaryButton(
                              text: rightButtonText ?? "Settings",
                              height: 35,
                              buttonTextSize: 12,
                              onTap: rightButtonTap ?? () {},
                              isPadded: false,
                              buttonColor: Colors.white,
                              textColor: AppColor.THEME_COLOR_PRIMARY1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   width: 100,
                                //   child: PrimaryButton(
                                //     height: 35,
                                //     text: leftButtonText ?? "Edit Profile",
                                //     buttonTextSize: 12,
                                //     onTap: leftButtonTap ?? () {},
                                //     isPadded: false,
                                //     buttonColor:
                                //         leftButtonColor ?? Colors.white,
                                //     textColor: leftTextColor ??
                                //         AppColor.THEME_COLOR_PRIMARY1,
                                //   ),
                                // ),

                                const SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

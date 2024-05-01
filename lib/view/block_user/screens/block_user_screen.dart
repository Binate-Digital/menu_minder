import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/dotted_image.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_text.dart';
import '../../../common/decision_container_widget.dart';
import '../../../common/primary_button.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/enums.dart';

class BlockUserScreen extends StatelessWidget {
  const BlockUserScreen({super.key});
  _loadBlockedUsers(BuildContext context) {
    context.read<CoreProvider>().getBlockedUsersList();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      _loadBlockedUsers(context);
    });
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "Block Profiles"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: Consumer<CoreProvider>(builder: (context, provider, _) {
          return provider.getAllBlockedUsersState == States.loading
              ? const CustomLoadingBarWidget()
              : provider.getAllBlockedUsersState == States.failure
                  ? const Center(
                      child: CustomText(
                      text: "No Blocked Users",
                    ))
                  : provider.blockedUsers != null &&
                          provider.blockedUsers!.data!.isEmpty
                      ? const Center(
                          child: CustomText(
                            text: 'No Blocked Users',
                          ),
                        )
                      : ListView.builder(
                          itemCount: provider.blockedUsers?.data?.length ?? 0,
                          itemBuilder: (innerConext, index) {
                            final user = provider.blockedUsers!.data![index];
                            return DecisionContainer(
                              containerColor:
                                  AppColor.COLOR_GREY2.withOpacity(0.5),
                              customPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      DottedImage(
                                        netWorkUrl: user.receiverId!.userImage,

                                        // nameSize: 14,
                                        // image: AssetPath.PERSON,
                                        radius: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppStyles.subHeadingStyle(
                                              user.receiverId?.userName ?? ''),
                                          // AppStyles.contentStyle(
                                          //     "Accept your request")
                                        ],
                                      )
                                    ],
                                  ),
                                  PrimaryButton(
                                      height: 30,
                                      // isPadded: false,

                                      radius: 6,
                                      buttonColor:
                                          AppColor.THEME_COLOR_PRIMARY1,
                                      textColor: AppColor.COLOR_WHITE,
                                      textPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      text: "Unblock",
                                      onTap: () {
                                        AppDialog.showDialogs(
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 48.0,
                                                      vertical: 12),
                                                  child: AppStyles.headingStyle(
                                                      "Are you sure you want to unblock this person?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: PrimaryButton(
                                                            text: "Cancel",
                                                            buttonColor: Colors
                                                                .grey.shade600,
                                                            onTap: () {
                                                              AppNavigator.pop(
                                                                  context);
                                                            })),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: PrimaryButton(
                                                          text: "Yes",
                                                          // buttonColor: AppColor.COLOR_RED1,
                                                          onTap: () {
                                                            innerConext
                                                                .read<
                                                                    CoreProvider>()
                                                                .unBlockUser(
                                                              user,
                                                              innerConext,
                                                              onSuccess: () {
                                                                AppNavigator.pop(
                                                                    context);
                                                                AppNavigator.pop(
                                                                    context);
                                                                context
                                                                    .read<
                                                                        CoreProvider>()
                                                                    .removeBlockedUser(
                                                                        context,
                                                                        user);
                                                              },
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            "Unblock User",
                                            context);
                                      })
                                ],
                              ),
                            );
                          });
        }),
      ),
    );
  }
}

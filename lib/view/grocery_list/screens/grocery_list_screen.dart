// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/config.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/grocery_list/model/grocery_list_model.dart';
import 'package:menu_minder/view/grocery_list/screens/grocery_details_screen.dart';
import 'package:menu_minder/view/notifications/custom_slidable.dart';
import 'package:provider/provider.dart';

import '../../../common/primary_button.dart';
import '../../../utils/actions.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoreProvider>().getGroceryList();
    });
    return Scaffold(
      body: Consumer<CoreProvider>(builder: (context, val, _) {
        if (val.getGroceryListState == States.loading) {
          return const CustomLoadingBarWidget();
        } else if (val.getGroceryListState == States.failure) {
          return const Center(
            child: CustomText(
              text: 'No Data Found',
            ),
          );
        } else if (val.getGroceryListState == States.success) {
          return val.getGroceryyList?.data == null ||
                  val.getGroceryyList!.data!.isEmpty
              ? const Center(
                  child: CustomText(
                    text: 'No Data Found',
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return AppStyles.height16SizedBox();
                  },
                  itemCount: val.getGroceryyList?.data?.length ?? 0,
                  itemBuilder: (itemContext, index) {
                    final item = val.getGroceryyList?.data?[index];
                    return CustomSlidableWidget(
                      // customIcon: AssetPath.EDIT,
                      // secondIcon: AssetPath.EDIT,
                      onSecondTap: () {},
                      onTap: () {
                        AppDialog.showDialogs(
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 48),
                                  child: AppStyles.headingStyle(
                                      "Are you sure you want to delete this Grocery?",
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: PrimaryButton(
                                            text: "Cancel",
                                            buttonColor: Colors.grey.shade600,
                                            onTap: () {
                                              AppNavigator.pop(context);
                                            })),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: PrimaryButton(
                                          text: "Delete",
                                          buttonColor: AppColor.COLOR_RED1,
                                          onTap: () {
                                            context
                                                .read<CoreProvider>()
                                                .deleteGrocery(
                                              context,
                                              onSuccess: () {
                                                AppNavigator.pop(context);
                                                Future.delayed(const Duration(
                                                        milliseconds: 100))
                                                    .then((value) =>
                                                        AppNavigator.pop(
                                                            context));
                                              },
                                              groceryID: item,
                                            );
                                          }),
                                    )
                                  ],
                                )
                              ],
                            ),
                            "Delete Grocery",
                            context);
                      },
                      child: StoreContainer(
                        groceryData: item!,
                        onTap: () {
                          AppNavigator.push(
                              context, GroceryDetailsScreen(groceryData: item));
                        },
                      ),
                    );

                    // GroceryListWidget(
                    //   index: index,
                    //   onCheckTapped: () {
                    //     // int isCheck;

                    //     // if (item.isCheck == 1) {
                    //     //   isCheck = 0;
                    //     // } else {
                    //     //   isCheck = 1;
                    //     // }
                    //     // print("Checked $isCheck");
                    //     // val.checkUnCheckGroceryItem(context,
                    //     //     isCheck: isCheck, groceryID: item.sId!);
                    //   },
                    //   product: item!,
                    //   // notifier: notifier,
                    // );
                  },
                );
        }
        return const SizedBox();
      }),
    );
  }
}

class StoreContainer extends StatelessWidget {
  const StoreContainer({super.key, required this.groceryData, this.onTap});
  final GroceryData groceryData;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: AppColor.COLOR_WHITE,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: AppColor.THEME_COLOR_SECONDARY,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(1, 1))
            ]),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColor.THEME_COLOR_PRIMARY1,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                AssetPath.CREATE_RECIPE,
                color: AppColor.BG_COLOR,
              ),
            ),
            AppStyles.height12SizedBox(height: 0, width: 12),
            Expanded(
                child: AppStyles.subHeadingStyle(groceryData.storeName ?? '')),
            AppStyles.subHeadingStyle(
                Utils.formatDate(
                    pattern: AppConfig.DATE_FORMAT,
                    date: DateTime.parse(
                        groceryData.createdAt ?? DateTime.now().toString())),
                fontWeight: FontWeight.normal,
                fontSize: 10),
          ],
        ),
      ),
    );
  }
}

// ListView.builder(
//                   itemCount:
//                       val.getGroceryyList?.data?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     final item = val.getGroceryyList?.data?.groceryList?[index];
//                     return GroceryListWidget(
//                       index: index,
//                       onCheckTapped: () {
//                         int isCheck;

//                         if (item.isCheck == 1) {
//                           isCheck = 0;
//                         } else {
//                           isCheck = 1;
//                         }
//                         print("Checked $isCheck");
//                         val.checkUnCheckGroceryItem(context,
//                             isCheck: isCheck, groceryID: item.sId!);
//                       },
//                       product: item!,
//                       // notifier: notifier,
//                     );
//                   },
//                 );

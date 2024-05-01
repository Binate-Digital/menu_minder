import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/utils/asset_paths.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/styles.dart';
import '../model/grocery_list_model.dart';

class GroceryListWidget extends StatelessWidget {
  final int index;
  final GroceryItem product;
  final Function()? onCheckTapped;
  final Function()? onEditTap;
  const GroceryListWidget({
    Key? key,
    required this.index,
    required this.product,
    this.onCheckTapped,
    this.onEditTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCheckTapped,
      child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: product.isCheck == 1
                  ? AppColor.THEME_COLOR_SECONDARY
                  : AppColor.COLOR_WHITE,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: AppColor.COLOR_RED1.withOpacity(.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(1, 1))
              ]),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: product.isCheck == 1
                    ? Colors.white
                    : AppColor.THEME_COLOR_SECONDARY, // radius: 30,
                child: CustomText(
                  text: (product.productQuantity ?? 1) > 200
                      ? '200+'
                      : product.productQuantity.toString(),
                  fontColor: product.isCheck == 1
                      ? Colors.black
                      : AppColor.COLOR_BLACK, // fontSize: ,
                  weight: FontWeight.normal,
                ),
                // child: Image.network(
                //   // groceryList[widget.index].image,
                //   // scale: 4,
                // ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppStyles.subHeadingStyle(product.productName ?? ''),
                  AppStyles.height8SizedBox(),
                  AppStyles.contentStyle(product.productDiscription ?? '')
                ],
              )),

              InkWell(
                onTap: onEditTap,
                child: Image.asset(
                  AssetPath.EDIT,
                  scale: 3,
                ),
              ),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             width: 20,
              //             height: 20,
              //             decoration: BoxDecoration(boxShadow: [
              //               BoxShadow(
              //                   color: product.isCheck == 1
              //                       ? Colors.transparent
              //                       : AppColor.THEME_COLOR_SECONDARY,
              //                   spreadRadius: 2)
              //             ], shape: BoxShape.circle, color: Colors.white),
              //             child: product.isCheck == 1
              //                 ? Container(
              //                     decoration: const BoxDecoration(
              //                         shape: BoxShape.circle,
              //                         color: AppColor.THEME_COLOR_PRIMARY1),
              //                     child: const Icon(
              //                       Icons.check,
              //                       color: AppColor.COLOR_WHITE,
              //                       size: 14,
              //                     ),
              //                   )
              //                 : const SizedBox.shrink(),
              //           )
              //         ],
              //       ),
              //       AppStyles.height16SizedBox(),
              //       AppStyles.contentStyle(product.productDiscription ?? '')
              //     ],
              //   ),
              // )
            ],
          )),
    );
  }
}

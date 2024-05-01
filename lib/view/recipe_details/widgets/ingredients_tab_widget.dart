import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/styles.dart';

class IngredientsTab extends StatelessWidget {
  const IngredientsTab({super.key, required this.ingredients});
  // final List<Map<String, dynamic>>? ingredients;
  final dynamic ingredients;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ingredients != null
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (int i = 0; i < ingredients!.length; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: AppColor.THEME_COLOR_SECONDARY,
                              size: 10,
                            ),
                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: CustomText(
                                lineSpacing: 1.2,
                                textAlign: TextAlign.start,
                                text: ingredients![i].keys.first,
                                maxLines: 3,
                              ),
                            )
                            // AppStyles.subHeadingStyle(
                            //     ingredients![i].keys.first,
                            //     fontWeight: FontWeight.normal),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppStyles.contentStyle(
                            ingredients![i]
                                .values
                                .first
                                .toString()
                                .replaceAll('|', ' '),
                            color: AppColor.THEME_COLOR_SECONDARY,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  )
              ])
            : Center(
                child: AppStyles.contentStyle("No Data found",
                    color: AppColor.COLOR_BLACK, fontWeight: FontWeight.normal),
              )

        //   List.generate(
        //       ingredients!.length,
        //       (index) => Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: AppStyles.subHeadingStyle(
        //                     "${ingredients?.getFirstKeys()[index]}:",
        //                     fontWeight: FontWeight.normal),
        //               ),
        //               Column(
        //                 children: List.generate(
        //                     ingredientsList[index].ingredients.length,
        //                     (index2) => Padding(
        //                           padding: const EdgeInsets.all(4.0),
        //                           child: Row(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             mainAxisAlignment:
        //                                 MainAxisAlignment.spaceBetween,
        //                             children: [
        //                               Expanded(
        //                                 child: Row(
        //                                   children: [
        //                                     const Icon(
        //                                       Icons.circle,
        //                                       color:
        //                                           AppColor.THEME_COLOR_SECONDARY,
        //                                       size: 10,
        //                                     ),
        //                                     const SizedBox(
        //                                       width: 10,
        //                                     ),
        //                                     Expanded(
        //                                       child: AppStyles.contentStyle(
        //                                           ingredients!
        //                                               .getFirstValues()[index]),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                               AppStyles.contentStyle("1/4 cups",
        //                                   color: AppColor.THEME_COLOR_SECONDARY)
        //                             ],
        //                           ),
        //                         )),
        //               )
        //             ],
        //           )),
        // ),

        );
  }
}

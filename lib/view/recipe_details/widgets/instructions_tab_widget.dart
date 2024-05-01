import 'package:flutter/material.dart';
import '../../../utils/styles.dart';

class InstructionsTab extends StatelessWidget {
  const InstructionsTab({
    super.key,
    this.instructions,
  });

  final String? instructions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: AppStyles.subHeadingStyle(instructions ?? "",
                fontWeight: FontWeight.normal),
          ),
          // Column(
          //   children: List.generate(
          //       instructionsList[index].ingredients.length,
          //       (index2) => Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 8.0, horizontal: 4),
          //             child: Column(
          //               children: [
          //                 Row(
          //                   crossAxisAlignment:
          //                       CrossAxisAlignment.start,
          //                   mainAxisAlignment:
          //                       MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Expanded(
          //                       child: AppStyles.contentStyle(
          //                           instructionsList[index]
          //                               .ingredients[index2]),
          //                     ),
          //                   ],
          //                 ),
          //                 AppStyles.height16SizedBox()
          //               ],
          //             ),
          //           )),
          // )
        ],
      ),
    );
  }
}

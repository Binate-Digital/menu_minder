import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:provider/provider.dart';

import '../../../common/profile_banner_widget.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dummy.dart';
import '../../../utils/styles.dart';

class SuggestionListWidget extends StatelessWidget {
  const SuggestionListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(builder: (context, val, _) {
      if (val.getAllReceipeState == States.loading) {
        return const CustomLoadingBarWidget();
      } else if (val.getAllReceipeState == States.failure) {
        return const Center(
          child: CustomText(
            text: 'No Reciepies Found',
          ),
        );
      }

      if (val.getAllBlockedUsersState == States.success) {
        return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, listIndex) {
              return Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.THEME_COLOR_SECONDARY.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProfileBanner(),
                    AppStyles.horizontalDivider(),
                    AppStyles.subHeadingStyle("Family Suggestions:"),
                    AppStyles.height16SizedBox(),
                    Column(
                      children: List.generate(
                          suggestionList.length,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppStyles.contentStyle(
                                      "${index + 1} - ${suggestionList[index]}",
                                      fontSize: 14),
                                  AppStyles.horizontalDivider(
                                      color: index + 1 != suggestionList.length
                                          ? Colors.grey.shade300
                                          : Colors.transparent)
                                ],
                              )),
                    )
                  ],
                ),
              );
            });
      }
      return SizedBox();
    });
  }
}

List<String> suggestionList = [
  LOREM_UTLRA_SMALL,
  LOREM_UTLRA_SMALL,
  LOREM_UTLRA_SMALL,
];

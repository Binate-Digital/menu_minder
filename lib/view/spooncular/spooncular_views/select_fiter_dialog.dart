import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/config.dart';

class SelectFilterDialog extends StatelessWidget {
  const SelectFilterDialog({super.key, required this.selectedPrefrence});
  final Function(String selectedPref) selectedPrefrence;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(AppConfig.recipePrefrnces.length,
            (index) => customTile(AppConfig.recipePrefrnces[index]))
      ],
    );
  }

  Widget customTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        tileColor: AppColor.COLOR_GREY1.withOpacity(.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          selectedPrefrence(text.toLowerCase());
        },
        title: CustomText(
          text: text,
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}

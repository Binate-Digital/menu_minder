import 'package:flutter/material.dart';
import 'package:menu_minder/common/primary_textfield.dart';
import 'package:menu_minder/utils/app_constants.dart';

import '../utils/asset_paths.dart';

class SearchWidget extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final String? prefixIcon;
  const SearchWidget(
      {super.key, this.hint, required this.controller, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: AppColor.THEME_COLOR_PRIMARY1.withOpacity(0.2),
            offset: const Offset(1, 2),
            blurRadius: 10)
      ]),
      child: PrimaryTextField(
          borderColor: Colors.grey.shade300,
          hintText: hint ?? "Search here...",
          hasPrefix: true,
          prefixIconPath: prefixIcon ?? AssetPath.SEARCH,
          prefixColor: Colors.grey.shade600,
          hintColor: Colors.grey.shade600,
          controller: controller),
    );
  }
}

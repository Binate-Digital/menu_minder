import 'package:flutter/material.dart';
import 'package:menu_minder/utils/app_constants.dart';

class CustomLoadingBarWidget extends StatelessWidget {
  const CustomLoadingBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: AppColor.THEME_COLOR_PRIMARY1.withOpacity(.2),
        color: AppColor.THEME_COLOR_PRIMARY1,
        strokeWidth: 4,
      ),
    );
  }
}

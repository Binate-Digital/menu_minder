import 'package:flutter/material.dart';
import 'package:menu_minder/utils/app_constants.dart';

import '../utils/asset_paths.dart';

class CustomBackgroundWidget extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  bool? showBackground;
  bool? extendBodyBehindAppBar;
  bool? resizeToAvoidBottomInset;
  Color? backgroundColor;
  EdgeInsets? screenPadding;
  CustomBackgroundWidget(
      {super.key,
      required this.child,
      this.appBar,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.showBackground = true,
      this.resizeToAvoidBottomInset = false,
      this.screenPadding,
      this.extendBodyBehindAppBar = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: extendBodyBehindAppBar!,
        backgroundColor: backgroundColor,
        extendBody: true,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: Stack(
          children: [
            if (showBackground!)
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(
                      AssetPath.BG_BLUR,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SafeArea(
              child: Container(
                  padding: screenPadding ??
                      const EdgeInsets.symmetric(
                          horizontal: AppDimen.SCREEN_PADDING),
                  child: SizedBox(width: double.infinity, child: child)),
            )
          ],
        ),
      ),
    );
  }
}

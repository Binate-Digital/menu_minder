import 'package:flutter/material.dart';
import 'package:menu_minder/utils/styles.dart';

import '../utils/app_constants.dart';
import 'actions.dart';

class ImageSourcePicker extends StatelessWidget {
  const ImageSourcePicker({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColor.COLOR_WHITE,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: InkWell(
              onTap: () => AppNavigator.pop(context),
              child: const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.close,
                  color: AppColor.THEME_COLOR_PRIMARY1,
                ),
              ),
            ),
          ),
          buildOption(
            context,
            "Gallery",
          ),
          buildOption(
            context,
            "Camera",
          ),
          AppStyles.height16SizedBox()
        ],
      ),
    );
  }

  Widget buildOption(
    BuildContext context,
    String text,
  ) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, text);
        },

        style: ElevatedButton.styleFrom(
            foregroundColor: AppColor.THEME_COLOR_PRIMARY1,
            backgroundColor: AppColor.COLOR_WHITE,
            //splashFactory: InkRipple.splashFactory,

            padding: EdgeInsets.zero,
            elevation: 0
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
             // side: BorderSide(width: 0,color: AppColors.TRANSPARENT_COLOR)
          )*/
            ),
        //    color: AppColor.COLOR_TRANSPARENT,
        child: Center(
            child: Text(
          text,
          /*   style: AppStyles.headingStyle(), */
        )),
      ),
    );
  }
}

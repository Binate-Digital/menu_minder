import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_constants.dart';

class SettingsOptionsWidget extends StatelessWidget {
  SettingsOptionsWidget(
      {super.key, this.notifier, this.onTap, required this.heading});

  bool? notifier;
  VoidCallback? onTap;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: AppColor.COLOR_WHITE,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              heading,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            notifier != null
                ? SizedBox(
                    width: 20,
                    height: 50,
                    child: Transform.scale(
                      scale: 0.65,
                      child: CupertinoSwitch(
                        value: notifier!,
                        onChanged: (v) {
                          // notifier!.value = v;
                          if (notifier == true) {
                            context
                                .read<NotificationProvider>()
                                .changeNotificaionsStatus(
                                    isEnabled: true, context: context);
                            // Utils.showToast(message: "Notifications on");
                          } else {
                            context
                                .read<NotificationProvider>()
                                .changeNotificaionsStatus(
                                    isEnabled: false, context: context);
                            // Utils.showToast(message: "Notifications off");
                          }
                        },
                        trackColor: AppColor.THEME_COLOR_SECONDARY,
                        activeColor: AppColor.THEME_COLOR_PRIMARY1,
                      ),
                    ),
                  )
                : Image.asset(
                    AssetPath.ARROW_FORWARD,
                    scale: 4,
                  )
          ],
        ),
      ),
    );
  }
}

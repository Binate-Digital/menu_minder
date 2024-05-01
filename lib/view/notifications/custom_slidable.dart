import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';

class CustomSlidableWidget extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final Function()? onSecondTap;
  final bool? isenable;
  final String? customIcon;
  final String? secondIcon;
  const CustomSlidableWidget({
    super.key,
    required this.child,
    this.onTap,
    this.isenable,
    this.onSecondTap,
    this.customIcon,
    this.secondIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableScrollActionPane(),
      actionExtentRatio: 0.22,
      enabled: isenable ?? true,
      secondaryActions: [
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: _deleteIcon(customIcon: customIcon),
          onTap: onTap,
        ),
        if (secondIcon != null)
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: _deleteIcon(customIcon: secondIcon),
            onTap: onSecondTap,
          )
      ],
      child: child,
    );
  }

  Widget _deleteIcon({String? customIcon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      // margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: AppColor.COLOR_WHITE,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                offset: const Offset(2, 2),
                color: Colors.grey.withOpacity(.3),
                spreadRadius: 2,
                blurRadius: 8)
          ]),
      // padding: const EdgeInsets.only(bottom: 20),
      child: Image.asset(
        customIcon ?? AssetPath.DELETE,
        scale: 3,
      ),
    );
  }
}

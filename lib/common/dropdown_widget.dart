import 'package:flutter/material.dart';
import 'package:menu_minder/view/family_suggestion/data/famliy_list_res.dart';
import 'package:provider/provider.dart';

import '../utils/app_constants.dart';
import '../view/auth/bloc/provider/auth_provider.dart';

class DropDownField extends StatelessWidget {
  final String hint;
  final List<String>? items;
  final Function(String? t) onValueChanged;
  final String? selected_value;
  final double fontsize, elevation, radius;
  final bool italic;
  final double? iconSize;
  final bool? hasBorder;
  final Color? borderColor;
  final FontWeight fontWeight;
  final IconData? trailingWidget;
  final Color? backgroundColor;
  final Color? hintColor;
  const DropDownField(
      {super.key,
      this.hint = "",
      this.items = const [],
      this.iconSize,
      this.fontWeight = FontWeight.w600,
      required this.onValueChanged,
      this.selected_value,
      this.italic = true,
      this.fontsize = AppDimen.FONT_DROPDOWN_FIELD,
      this.elevation = 0,
      this.radius = AppDimen.LOGIN_FIELD_RADIUS,
      this.hasBorder,
      this.borderColor,
      this.trailingWidget,
      this.backgroundColor,
      this.hintColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: elevation),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimen.LOGINFIELD_HORZ_PADDING, vertical: 4),
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColor.INPUTBACKGROUND,
            borderRadius: BorderRadius.circular(AppDimen.LOGIN_FIELD_RADIUS),
            border: Border.all(
                color: borderColor ?? Colors.grey.shade100, width: 1)),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                dropdownColor: AppColor.COLOR_WHITE,
                hint: Text(
                  hint,
                  style: TextStyle(fontSize: 14, color: hintColor),
                ),
                value: selected_value,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  size: iconSize ?? 30,
                  color: AppColor.THEME_COLOR_PRIMARY1,
                ),
                items: items != null
                    ? items!.map<DropdownMenuItem<String>>((it) {
                        return DropdownMenuItem(
                          value: it,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                it.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              trailingWidget != null
                                  ? Icon(
                                      trailingWidget!,
                                      color: selected_value == it
                                          ? AppColor.THEME_COLOR_PRIMARY1
                                          : AppColor.THEME_COLOR_PRIMARY1
                                              .withOpacity(0.5),
                                      size: 24,
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        );
                      }).toList()
                    : [],
                onChanged: (val) {
                  onValueChanged(val);
                })),
      ),
    );
  }
}

class FamliyDropdowm extends StatelessWidget {
  final String hint;
  final List<FamilyData>? items;
  final Function(FamilyData? t) onValueChanged;
  final FamilyData? selected_value;
  final double fontsize, elevation, radius;
  final bool italic;
  final bool? hasBorder;
  final Color? borderColor;
  final FontWeight fontWeight;
  final IconData? trailingWidget;
  final Color? backgroundColor;
  final Color? hintColor;
  const FamliyDropdowm(
      {super.key,
      this.hint = "",
      this.items = const [],
      this.fontWeight = FontWeight.w600,
      required this.onValueChanged,
      this.selected_value,
      this.italic = true,
      this.fontsize = AppDimen.FONT_DROPDOWN_FIELD,
      this.elevation = 0,
      this.radius = AppDimen.LOGIN_FIELD_RADIUS,
      this.hasBorder,
      this.borderColor,
      this.trailingWidget,
      this.backgroundColor,
      this.hintColor});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().userdata!.data!.Id!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: elevation),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimen.LOGINFIELD_HORZ_PADDING, vertical: 4),
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColor.INPUTBACKGROUND,
            borderRadius: BorderRadius.circular(AppDimen.LOGIN_FIELD_RADIUS),
            border: Border.all(
                color: borderColor ?? Colors.grey.shade100, width: 1)),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<FamilyData>(
                dropdownColor: AppColor.COLOR_WHITE,
                hint: Text(
                  hint,
                  style: TextStyle(fontSize: 14, color: hintColor),
                ),
                value: selected_value,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 30,
                  color: AppColor.THEME_COLOR_PRIMARY1,
                ),
                items: items != null
                    ? items!.map<DropdownMenuItem<FamilyData>>((it) {
                        final user = it.receiverId?.sId == userId
                            ? it.senderId
                            : it.receiverId;
                        return DropdownMenuItem(
                          value: it,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user?.userName ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              trailingWidget != null
                                  ? Icon(
                                      trailingWidget!,
                                      color: selected_value == it
                                          ? AppColor.THEME_COLOR_PRIMARY1
                                          : AppColor.THEME_COLOR_PRIMARY1
                                              .withOpacity(0.5),
                                      size: 24,
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        );
                      }).toList()
                    : [],
                onChanged: (val) {
                  onValueChanged(val);
                })),
      ),
    );
  }
}

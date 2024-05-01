import 'package:flutter/material.dart';

import '../utils/app_constants.dart';
import '../utils/styles.dart';

class HeadingDropDownField extends StatelessWidget {
  final String hint;
  final List<String>? items;
  final Function(String? t) onValueChanged;
  final String? selected_value;
  final double fontsize, elevation, radius;
  final bool italic;
  final bool? hasBorder;
  final Color? borderColor;
  final FontWeight fontWeight;
  final IconData? trailingWidget;
  final String heading;
  final Color? bgColor;
  final Color? headingColor;
  const HeadingDropDownField(
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
      required this.heading,
      this.bgColor,
      this.headingColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: elevation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
                color: headingColor ?? AppColor.COLOR_WHITE, fontSize: 15),
          ),
          AppStyles.height8SizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimen.LOGINFIELD_HORZ_PADDING, vertical: 4),
            decoration: BoxDecoration(
                color: bgColor ?? AppColor.INPUTBACKGROUND,
                borderRadius:
                    BorderRadius.circular(AppDimen.LOGIN_FIELD_RADIUS),
                border: Border.all(
                    color: borderColor ?? Colors.grey.shade100, width: 1)),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    dropdownColor: AppColor.COLOR_WHITE,
                    hint: Text(
                      hint,
                      style: const TextStyle(
                          fontSize: 14, color: AppColor.COLOR_BLACK),
                    ),
                    value: selected_value,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 30,
                      color: AppColor.THEME_COLOR_PRIMARY1,
                    ),
                    items: items != null
                        ? items!.map<DropdownMenuItem<String>>((it) {
                            return DropdownMenuItem(
                              value: it,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
        ],
      ),
    );
  }
}

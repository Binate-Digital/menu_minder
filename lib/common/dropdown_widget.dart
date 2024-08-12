import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
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
  final Offset? offset;

  const DropDownField({
    super.key,
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
    this.hintColor,
    this.offset,
  });

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

// import 'package:flutter/material.dart';

// class DropDownField extends StatefulWidget {
//   final String hint;
//   final List<String>? items;
//   final Function(String? t) onValueChanged;
//   final String? selected_value;
//   final double fontsize, elevation, radius;
//   final bool italic;
//   final double? iconSize;
//   final bool? hasBorder;
//   final Color? borderColor;
//   final FontWeight fontWeight;
//   final IconData? trailingWidget;
//   final Color? backgroundColor;
//   final Color? hintColor;
//   final Offset? offset;

//   const DropDownField({
//     super.key,
//     this.hint = "",
//     this.items = const [],
//     this.iconSize,
//     this.fontWeight = FontWeight.w600,
//     required this.onValueChanged,
//     this.selected_value,
//     this.italic = true,
//     this.fontsize = 16,
//     this.elevation = 0,
//     this.radius = 8,
//     this.hasBorder,
//     this.borderColor,
//     this.trailingWidget,
//     this.backgroundColor,
//     this.hintColor,
//     this.offset,
//   });

//   @override
//   _DropDownFieldState createState() => _DropDownFieldState();
// }

// class _DropDownFieldState extends State<DropDownField> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widget.elevation),
//       child: Container(
//         height: 50,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         decoration: BoxDecoration(
//           color: widget.backgroundColor ?? Colors.white,
//           borderRadius: BorderRadius.circular(widget.radius),
//           border: Border.all(
//               color: widget.borderColor ?? Colors.grey.shade100, width: 1),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: widget.selected_value,
//             hint: Text(
//               widget.selected_value ?? widget.hint,
//               style: TextStyle(
//                 fontSize: widget.fontsize,
//                 fontWeight: widget.fontWeight,
//                 color: widget.selected_value == null ? widget.hintColor : null,
//               ),
//             ),
//             isExpanded: true,
//             icon: Icon(
//               Icons.arrow_drop_down_rounded,
//               size: widget.iconSize ?? 30,
//               color: Colors.blue,
//             ),
//             items: widget.items?.map((String it) {
//               return DropdownMenuItem<String>(
//                 value: it,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         it,
//                         style: TextStyle(fontSize: widget.fontsize),
//                       ),
//                     ),
//                     if (widget.trailingWidget != null)
//                       Icon(
//                         widget.trailingWidget!,
//                         color: widget.selected_value == it
//                             ? Colors.blue
//                             : Colors.blue.withOpacity(0.5),
//                         size: 24,
//                       ),
//                   ],
//                 ),
//               );
//             }).toList(),
//             onChanged: (String? value) {
//               widget.onValueChanged(value);
//             },
//             dropdownColor: widget.backgroundColor ?? Colors.white,
//             itemHeight: 50, // Adjust item height as needed
//           ),
//         ),
//       ),
//     );
//   }
// }

//NEW

class CustomDropDown2 extends StatelessWidget {
  final String? dropdownValue, hintText;
  double? maxLines;
  final Widget? prefix;
  final List<String>? dropDownData;
  final Function(String)? onChanged;
  final double? width,
      fontSize,
      dropDownWidth,
      buttonPadding,
      menuItemPadding,
      horizontalPadding,
      verticalPadding;
  final Color? borderColor;
  final EdgeInsets? contentPadding;
  final Offset? offset;
  final String? Function(String?)? validator;
  final Color? hintColor;
  final double? borderRadius;
  bool? isNotCenter;

  CustomDropDown2(
      {Key? key,
      this.dropDownData,
      this.borderColor = AppColor.COLOR_BLACK,
      this.dropdownValue,
      this.maxLines,
      this.width,
      this.onChanged,
      this.hintColor,
      this.fontSize = 16,
      this.borderRadius,
      this.hintText,
      this.verticalPadding,
      this.horizontalPadding,
      this.validator,
      this.prefix,
      this.contentPadding,
      this.menuItemPadding,
      this.dropDownWidth,
      this.buttonPadding,
      this.isNotCenter,
      this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        style: TextStyle(
          color: AppColor.COLOR_RED1,
          // fontSize: fontSize!.sp,
          // fontFamily: AppFonts.ptSansRegular,
        ),
        validator: validator,
        decoration: InputDecoration(
          isDense: true,
          prefix: prefix,
          contentPadding: contentPadding ??
              EdgeInsets.only(
                  left: horizontalPadding ?? 5,
                  top: verticalPadding ?? 0,
                  bottom: verticalPadding ?? 0),
          // // fillColor: AppColors.textfiledInsideColor,
          // border: AppBorders.outLineInputBorder(
          //     borderColor: borderColor, radius: borderRadius),
          // focusedBorder: AppBorders.outLineInputBorder(
          //     borderColor: borderColor, radius: borderRadius),
          // enabledBorder: AppBorders.outLineInputBorder(
          //     borderColor: borderColor, radius: borderRadius),
          // errorBorder: AppBorders.outLineInputErrorBorder(radius: borderRadius),
          errorStyle: _errorStyle(),
          filled: true,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: menuItemPadding ?? 10),
        ),
        // iconStyleData: IconStyleData(
        //   icon: Padding(
        //     padding: EdgeInsets.only(right: 16.w),
        //     child: Image.asset(
        //       AssetPaths.dropDown,
        //       color: AppColors.blackColor,
        //       scale: 2.5,
        //     ),
        //   ),
        //   // iconSize: 30,
        // ),
        isExpanded: true,
        items: dropDownData!.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: _text(
              text: value,
              isNotCenter: isNotCenter,
              color: hintColor ?? AppColor.COLOR_BLACK,
              // fontSize: 16.sp,
              maxLines: 1,
            ),
          );
        }).toList(),
        hint:
            _text(text: hintText, color: hintColor ?? Colors.grey, maxLines: 1),
        value: dropdownValue,
        // onChanged: onChanged,
        onChanged: (String? newValue) {
          onChanged!(newValue!);
        },
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.only(left: buttonPadding ?? 7),
          //width: 0.5.sw,
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.only(left: horizontalPadding ?? 5),
          elevation: 1,
          width: dropDownWidth ?? 0.813,
          offset: offset ?? const Offset(-5, -20),
          isOverButton: false,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(width: 0, color: AppColor.TRANSPARENT_COLOR),
            color: AppColor.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  TextStyle _errorStyle() {
    return TextStyle(
      color: Colors.red,
      height: 0.7,
      // fontSize: 11.sp,
    );
  }

  Widget _text(
      {String? text,
      Color? color,
      int? maxLines,
      double? fontSize,
      bool? isNotCenter}) {
    return CustomText(
      text: text ?? "",
      // fontsize: fontSize ?? 16.0.sp,
      // fontFamily: AppFonts.ptSansRegular,
      textAlign: TextAlign.start,
      // color: color ?? AppColors.blackColor,
      // overflow: TextOverflow.visible,
      // lineSpacing: 1.3,
      maxLines: maxLines,
      // isLeftAlign: isNotCenter ?? true,
    );
  }
}

//NEW

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

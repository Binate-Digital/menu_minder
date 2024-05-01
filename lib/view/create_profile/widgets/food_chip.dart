import 'package:flutter/material.dart';

import '../../../utils/app_constants.dart';

class FoodChip extends StatelessWidget {
  const FoodChip({
    Key? key,
    required this.label,
    this.onDelete,
    this.isDeleteable = false,
    this.color,
    this.onChipTab,
  }) : super(key: key);

  final String label;
  final VoidCallback? onDelete;
  final bool? isDeleteable;
  final Color? color;
  final VoidCallback? onChipTab;
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChipTab,
      child: Chip(
        deleteIconColor: Colors.black,
        deleteIcon: isDeleteable!
            ? const Icon(
                Icons.cancel,
                color: AppColor.COLOR_RED1,
              )
            : null,
        onDeleted: isDeleteable! ? onDelete : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        label: Text(
          label,
          style: const TextStyle(
            color: AppColor.COLOR_BLACK,
          ),
        ),
        backgroundColor: color ?? AppColor.THEME_COLOR_PRIMARY1,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';

import '../widgets/my_meal_grid_widget.dart';

class MealPlanSuggesstionGrid extends StatelessWidget {
  MealPlanSuggesstionGrid(
      {super.key,
      required this.mealType,
      required this.mealPlansModel,
      required this.currentDate,
      this.hideEditButton = false});
  String? mealType;
  List<MealPlanModel> mealPlansModel;
  final bool hideEditButton;
  final String currentDate;

  @override
  Widget build(BuildContext context) {
    return MealPlansGridWidget(
      hideEditButton: hideEditButton,
      currentDate: currentDate,
      mealSList: mealPlansModel,
      mealType: mealType!,
      isSuggesstionns: true,
      onTap: () {},
    );
  }
}

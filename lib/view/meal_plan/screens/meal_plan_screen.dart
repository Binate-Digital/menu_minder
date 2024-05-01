import 'package:flutter/material.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/meal_plan/screens/plan_meal_type_screen.dart';
import 'package:menu_minder/view/meal_plan/widgets/meal_type_widget.dart';

import '../widgets/meal_calendar_widget.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({
    super.key,
  });

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  // DateTime currentDate = DateTime.now();
  DateTime selctedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MealCalendarWidget(
              dateCallBack: (dateTime) {
                setState(() {
                  selctedDate = dateTime;
                  print("Date Changed");
                });
              },
            ),
            AppStyles.height12SizedBox(),
            MealTypeWidget(
                name: "Breakfast",
                onTap: () {
                  AppNavigator.push(
                      context,
                      PlanMealTypeScreen(
                        mealType: "Breakfast",
                        currentDate: Utils.convertDateWithSlashes(selctedDate),
                      ));
                }),
            AppStyles.height12SizedBox(),
            MealTypeWidget(
                name: "Lunch",
                onTap: () {
                  AppNavigator.push(
                      context,
                      PlanMealTypeScreen(
                        mealType: "Lunch",
                        currentDate: Utils.convertDateWithSlashes(selctedDate),
                      ));
                }),
            AppStyles.height12SizedBox(),
            MealTypeWidget(
                name: "Dinner",
                onTap: () {
                  AppNavigator.push(
                      context,
                      PlanMealTypeScreen(
                        mealType: "Dinner",
                        currentDate: Utils.convertDateWithSlashes(selctedDate),
                      ));
                }),
          ],
        ),
      ),
    );
  }
}

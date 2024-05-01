// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/meal_plan/widgets/meal_calendar_widget.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';

class ChangeDayScreen extends StatefulWidget {
  const ChangeDayScreen({super.key});

  @override
  State<ChangeDayScreen> createState() => _ChangeDayScreenState();
}

class _ChangeDayScreenState extends State<ChangeDayScreen> {
  DateTime currentDate = DateTime.now();
  int selectDay = 0;

  List<String> mealType = [
    "Breakfast",
    "Lunch",
    "Dinner",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "Select Day"),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
        child: PrimaryButton(
            text: "Save",
            onTap: () {
              AppNavigator.pop(context);
            }),
      ),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: ListView(
          children: [
            MealCalendarWidget(
              dateCallBack: (dateTime) {},
            ),
            AppStyles.height12SizedBox(),
            Column(
                children: List.generate(
              3,
              (index) => SelectDayWidget(
                name: mealType[index],
                isSelected: selectDay == index,
                onTap: () {
                  selectDay = index;
                  setState(() {});
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class SelectDayWidget extends StatelessWidget {
  final String name;
  bool isSelected;
  VoidCallback onTap;
  SelectDayWidget({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? AppColor.THEME_COLOR_PRIMARY1
                : AppColor.CONTAINER_GREY),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: TextStyle(
                    color: isSelected ? AppColor.COLOR_WHITE : Colors.black,
                    fontSize: 15)),
            if (isSelected)
              Image.asset(
                AssetPath.ROUND_CHECK1,
                // color: AppColor.THEME_COLOR_PRIMARY1,
                scale: 3,
              )
          ],
        ),
      ),
    );
  }
}

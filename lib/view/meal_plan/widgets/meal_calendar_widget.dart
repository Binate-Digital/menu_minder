import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/strings.dart';

class MealCalendarWidget extends StatefulWidget {
  final Function(DateTime dateTime) dateCallBack;

  const MealCalendarWidget({super.key, required this.dateCallBack});

  @override
  State<MealCalendarWidget> createState() => _MealCalendarWidgetState();
}

class _MealCalendarWidgetState extends State<MealCalendarWidget> {
  DateTime currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColor.COLOR_WHITE,
        border: Border.all(color: Colors.grey.shade200, width: 2),
      ),
      child: TableCalendar(
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        calendarBuilders:
            CalendarBuilders(todayBuilder: (context, dateTime, lists) {
          return calendarDaysWidget(dateTime);
        }, defaultBuilder: (context, dateTime, lists) {
          return unAvailableDayWidget(dateTime);
        }),
        onDaySelected: (
          date,
          events,
        ) {
          setState(() {
            currentDate = date;
            //
          });

          widget.dateCallBack(currentDate);
        },
        focusedDay: currentDate,
        currentDay: currentDate,
        rowHeight: 40,
        daysOfWeekStyle: DaysOfWeekStyle(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(1)),
          weekdayStyle: const TextStyle(color: AppColor.COLOR_BLACK),
          weekendStyle: const TextStyle(color: AppColor.COLOR_BLACK),
        ),
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 3, 14),
        calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(5)),
            holidayDecoration: const BoxDecoration(
              color: AppColor.COLOR_BLACK,
            )),
        headerStyle: HeaderStyle(
          formatButtonPadding: EdgeInsets.zero,
          leftChevronIcon: Image.asset(
            AssetPath.LEFT_ARROW,
            scale: 4,
          ),
          leftChevronPadding: const EdgeInsets.only(left: 30),
          rightChevronPadding: const EdgeInsets.only(right: 30),
          rightChevronIcon: Image.asset(
            AssetPath.RIGHT_ARROW,
            scale: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: AppColor.COLOR_WHITE,
          ),
          headerMargin:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          headerPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          titleTextStyle: const TextStyle(
            color: AppColor.COLOR_BLACK,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          formatButtonVisible: false,
          titleCentered: true,
          formatButtonDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(1)),
        ),
      ),
    );
  }

  Widget unAvailableDayWidget(DateTime dateTime) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 6.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: AppColor.COLOR_WHITE, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          DateFormat(AppString.DAY_FORMAT_DD).format(dateTime),
          style: const TextStyle(
              color: AppColor.COLOR_GREY1,
              fontSize: 14.0,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget calendarDaysWidget(DateTime dateTime) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 6.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: AppColor.THEME_COLOR_PRIMARY1,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          DateFormat(AppString.DAY_FORMAT_DD).format(dateTime),
          style: const TextStyle(
              color: AppColor.COLOR_WHITE,
              fontSize: 14.0,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}

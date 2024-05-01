import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

typedef OnTabTapped = Function(int i);

class CustomTabbar extends StatelessWidget {
  const CustomTabbar({
    super.key,
    required TabController? tabController,
    required this.tabNames,
    this.onTabTapped,
  }) : _tabController = tabController;

  final TabController? _tabController;
  final List<String> tabNames;
  final OnTabTapped? onTabTapped;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.CONTAINER_GREY,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: .5,
                blurRadius: 10,
                offset: const Offset(3, 2))
          ]),
      child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: Colors.grey.shade600,
          padding: const EdgeInsets.all(2),
          onTap: onTabTapped,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.THEME_COLOR_PRIMARY1,
          ),
          controller: _tabController,
          tabs: List.generate(
            tabNames.length,
            (index) => Tab(
              text: tabNames[index],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/restraunt_menu/widgets/restraunt_list_widget.dart';

class RestrauntMenuScren extends StatelessWidget {
  const RestrauntMenuScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "Restaurant Menu"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: ListView.builder(
          itemBuilder: (context, index) => RestrauntListWidget(index: index),
        ),
      ),
    );
  }
}

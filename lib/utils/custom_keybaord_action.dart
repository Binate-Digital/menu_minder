import 'package:menu_minder/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CustomKeyboardActionWidget extends StatelessWidget {
  final Widget child;
  final FocusNode focusNode;
  const CustomKeyboardActionWidget(
      {super.key, required this.child, required this.focusNode});
  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
        config: _buildConfig(context), disableScroll: true, child: child);
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: AppColor.BG_COLOR,
      actions: [
        KeyboardActionsItem(focusNode: focusNode, displayArrows: false),
      ],
    );
  }
}

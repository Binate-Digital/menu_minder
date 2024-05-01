import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/meal_plan/screens/data/meal_plan_suggestion.dart';

import '../utils/styles.dart';
import '../view/auth/bloc/models/user_model.dart';
import 'dotted_image.dart';

class ProfileBanner extends StatelessWidget {
  final double? radius;
  final double? nameSize;
  final Function()? onTap;
  const ProfileBanner({
    super.key,
    this.userModelData,
    this.radius = 20,
    this.nameSize,
    this.onTap,
  });

  final UserModelData? userModelData;

  @override
  Widget build(BuildContext context) {
    print(userModelData?.userImage.toString());
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DottedImage(
            radius: radius,
            netWorkUrl: userModelData?.userImage != null
                ? userModelData!.userImage!
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 6),
            child: AppStyles.headingStyle(userModelData?.userName ?? "",
                fontSize: nameSize ?? 16),
          )
        ],
      ),
    );
  }
}

class FamliMamberBanner extends StatelessWidget {
  final double? radius;
  final double? nameSize;

  const FamliMamberBanner({
    super.key,
    required this.userModelData,
    this.radius = 20,
    this.nameSize,
  });

  final FamilyMemberModel userModelData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedImage(
          radius: radius,
          netWorkUrl: userModelData.userImage,
        ),
        // DottedImage(
        //   radius: radius,
        //   netWorkUrl: userModelData?.userImage,
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 6),
          child: AppStyles.headingStyle(userModelData.userName ?? "John Doe",
              fontSize: nameSize ?? 16),
        )
      ],
    );
  }
}

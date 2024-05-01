import 'package:flutter/material.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../utils/styles.dart';
import 'dotted_image.dart';

class ProfileWithNameAndDescriptionWidget extends StatelessWidget {
  final String name;
  final String? desc;
  final String? image;
  final bool? showDesc;
  final Function()? onTap;
  const ProfileWithNameAndDescriptionWidget({
    super.key,
    required this.name,
    this.image,
    this.desc,
    this.showDesc,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          DottedImage(
            radius: 20,
            netWorkUrl: image,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStyles.headingStyle(name, fontSize: 14),
              if (showDesc == false)
                AppStyles.contentStyle(
                  desc!,
                )
            ],
          )
        ],
      ),
    );
  }
}

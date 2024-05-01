import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/decision_container_widget.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/my_polls/data/my_poll_response_model.dart';

import '../../../common/profile_with_name_and_desc_widget.dart';

class PollMembersScreen extends StatelessWidget {
  const PollMembersScreen({super.key, this.familyMembers});
  final List<FamilyMembers>? familyMembers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "My Poll Members"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: familyMembers != null && familyMembers!.isEmpty
            ? const Center(
                child: CustomText(
                  text: 'No Members',
                ),
              )
            : ListView.separated(
                itemCount: familyMembers?.length ?? 0,
                separatorBuilder: (context, index) =>
                    AppStyles.height4SizedBox(),
                itemBuilder: (context, index) {
                  final member = familyMembers![index];
                  return DecisionContainer(
                      customPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      containerColor: AppColor.COLOR_GREY1.withOpacity(0.2),
                      child: ProfileWithNameAndDescriptionWidget(
                        name: member.userName ?? '',
                        showDesc: false,
                        image: member.userImage,
                        desc: "Family Member",
                      ));
                }),
      ),
    );
  }
}

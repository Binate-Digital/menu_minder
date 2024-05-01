import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/decision_container_widget.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:provider/provider.dart';

import '../../../common/profile_with_name_and_desc_widget.dart';
import '../../../providers/core_provider.dart';
import '../../auth/bloc/provider/auth_provider.dart';
import '../../user_profile/screens/friends_profile_screen.dart';

class ShowFamilyMemberScreen extends StatelessWidget {
  const ShowFamilyMemberScreen({super.key, this.isFromInbox = false});
  final bool isFromInbox;

  _loadFamilyData(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoreProvider>().getFamliyMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().userdata!.data!.Id!;

    _loadFamilyData(context);
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "Family Members"),
      body: Padding(
        padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
        child: Consumer<CoreProvider>(builder: (context, val, _) {
          if (val.getFamilyListState == States.loading) {
            return const CustomLoadingBarWidget();
          } else if (val.getFamilyListState == States.failure) {
            return const Center(
              child: CustomText(
                text: 'No Data Found',
              ),
            );
          } else if (val.getFamilyListState == States.success) {
            return val.familyList?.data != null && val.familyList!.data!.isEmpty
                ? const Center(
                    child: CustomText(
                      text: 'No Members added yet.',
                    ),
                  )
                : ListView.builder(
                    itemCount: val.familyList?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final user =
                          val.familyList?.data?[index].receiverId?.sId == userId
                              ? val.familyList?.data![index].senderId
                              : val.familyList?.data?[index].receiverId;
                      return DecisionContainer(
                        customPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: ProfileWithNameAndDescriptionWidget(
                          // id: user!.sId!,

                          onTap: () {
                            if (isFromInbox) {
                              Navigator.pop(context,
                                  {'id': user?.sId, 'name': user?.userName});
                            } else {
                              AppNavigator.push(
                                  context,
                                  FriendsProfileScreen(
                                    userID: user!.sId!,
                                  ));
                            }
                          },
                          image: user?.userImage,
                          name: user?.userName ?? '',
                          desc: 'Family Member',
                          showDesc: false,
                        ),
                      );
                    });
          }
          return const SizedBox();
        }),
      ),
    );
  }
}

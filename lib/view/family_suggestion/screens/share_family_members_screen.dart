import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/decision_container_widget.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:provider/provider.dart';

import '../../../common/profile_with_name_and_desc_widget.dart';
import '../../../providers/core_provider.dart';
import '../../auth/bloc/provider/auth_provider.dart';

class ShareFamilyScreen extends StatefulWidget {
  const ShareFamilyScreen({Key? key, required this.recipeModel})
      : super(key: key);
  final RecipeModel recipeModel;
  @override
  _ShareFamilyScreenState createState() => _ShareFamilyScreenState();
}

class _ShareFamilyScreenState extends State<ShareFamilyScreen> {
  _loadFamilyData(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoreProvider>().selectedUserIds.clear();
      print(
          "selectedUserIds ${context.read<CoreProvider>().selectedUserIds.length}");
      context.read<CoreProvider>().getFamliyMembers(
        onSucecess: () {
          if (widget.recipeModel.sharedMembers != null) {
            print("Famil;y Members");
            context
                .read<CoreProvider>()
                .updateSharedList(ids: widget.recipeModel.sharedMembers ?? []);
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().userdata!.data!.Id!;
    // print("object")

    _loadFamilyData(context);
    return Scaffold(
      appBar: AppStyles.pinkAppBar(context, "Share Recipe"),
      floatingActionButton: Consumer<CoreProvider>(builder: (context, val, _) {
        return val.familyList?.data != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: PrimaryButton(
                    text: 'Share',
                    onTap: () {
                      context.read<CoreProvider>().shareRecipe(
                        context,
                        recipeModel: widget.recipeModel,
                        onSuccess: () {
                          AppNavigator.pop(context);
                        },
                      );
                    }),
              )
            : const SizedBox();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                : Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (val.selectedUserIds.isNotEmpty &&
                                  val.selectedUserIds.length ==
                                      val.familyList?.data?.length) {
                                val.updateSharedList(ids: []);
                              } else {
                                final famlies = val.familyList?.data!
                                    .map((e) => e.receiverId?.sId == userId
                                        ? e.senderId!.sId!
                                        : e.receiverId!.sId!)
                                    .toList();
                                val.updateSharedList(ids: famlies ?? []);
                              }
                            },
                            child: CustomText(
                              text: val.selectedUserIds.isNotEmpty &&
                                      val.selectedUserIds.length ==
                                          val.familyList?.data?.length
                                  ? 'Deselect All'
                                  : 'Select All',
                              fontColor: AppColor.THEME_COLOR_SECONDARY,
                              weight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: val.familyList?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final user = val.familyList?.data?[index]
                                          .receiverId?.sId ==
                                      userId
                                  ? val.familyList?.data![index].senderId
                                  : val.familyList?.data?[index].receiverId;

                              return Row(
                                children: [
                                  CustomCheckboxWithContainer(
                                    value:
                                        val.selectedUserIds.contains(user?.sId),
                                    onChanged: (value) {
                                      val.updateSelectedIds(
                                          value: value!, sid: user!.sId!);
                                    },
                                  ),
                                  Expanded(
                                    child: DecisionContainer(
                                      customPadding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 8),
                                      child:
                                          ProfileWithNameAndDescriptionWidget(
                                        // id: user!.sId!,
                                        image: user?.userImage,
                                        name: user?.userName ?? '',
                                        desc: 'Family Member',
                                        showDesc: false,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  );
          }
          return const SizedBox();
        }),
      ),
    );
  }
}

class CustomCheckboxWithContainer extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Color containerColor;

  const CustomCheckboxWithContainer({
    Key? key,
    required this.value,
    required this.onChanged,
    this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.containerColor = Colors.transparent,
  }) : super(key: key);

  @override
  _CustomCheckboxWithContainerState createState() =>
      _CustomCheckboxWithContainerState();
}

class _CustomCheckboxWithContainerState
    extends State<CustomCheckboxWithContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(!widget.value);
        }
      },
      child: Container(
        color: widget.containerColor,
        padding: widget.padding,
        child: Row(
          children: [
            Checkbox(
              fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return AppColor.THEME_COLOR_PRIMARY1;
                }
                return AppColor.THEME_COLOR_PRIMARY1;
              }), // fillColor: MaterialStatePropertyAll(AppColor.COLOR_WHITE),
              value: widget.value,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onChanged: widget.onChanged,
            ),
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}

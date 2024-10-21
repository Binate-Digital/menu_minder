import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/decision_container_widget.dart';
import 'package:menu_minder/common/dropdown_widget.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/primary_textfield.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/utils/uppercase_string_extension.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/family_suggestion/data/famliy_list_res.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/my_polls/data/my_poll_response_model.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_extended_image_with_loading.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_validator.dart';
import '../../../utils/asset_paths.dart';

class CreateNewPollScreen extends StatefulWidget {
  final bool isEdit;
  final PollData? pollData;
  const CreateNewPollScreen({super.key, required this.isEdit, this.pollData});

  @override
  State<CreateNewPollScreen> createState() => _CreateNewPollScreenState();
}

class _CreateNewPollScreenState extends State<CreateNewPollScreen> {
  String? time, family;
  TimeOfDay? selectedTimeOfTheDay;
  final description = TextEditingController();
  final pollEndDate = TextEditingController();
  final pollEndTime = TextEditingController();
  DateTime? selectedDate;
  List<String> suggestionString = [
    LOREM_UTLRA_SMALL,
    LOREM_UTLRA_SMALL,
    LOREM_UTLRA_SMALL,
  ];
  List<String> buttonPost = [];

  List<FamilyData> selectedFamilyMembers = [];
  TextEditingController suggestionController = TextEditingController();
  TextEditingController buttonController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final List<String> familyMembers = [];

  RecipeModel? selectedRecipie;

  @override
  void initState() {
    context.read<CoreProvider>().updateSelectedRecipe(null, notify: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoreProvider>().getFamliyMembers(onSucecess: () {
        updateFamilyMembers();
      });
    });

    if (widget.isEdit && widget.pollData != null) {
      preSetData();
    } else {
      buttonPost.addAll(["Disagree", "Agree"]);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAllReceipies(
        context,
      );
    });

    super.initState();
  }

  List<RecipeModel> userRecipies = [];

  _getAllReceipies(BuildContext context) {
    context.read<CoreProvider>().getReciepiesByUserID(
      context,
      context.read<AuthProvider>().userdata?.data?.Id ?? '',
      onSuccess: () {
        final provcid = context.read<CoreProvider>();

        setState(() {
          userRecipies = [
            ...provcid.getMyRecipies?.data ?? [],
            ...provcid.getMyRecipies?.adminRecipies ?? []
          ];

          userRecipies.shuffle();
          print(userRecipies.length);
        });
      },
    );
  }

  updateFamilyMembers() {
    final currentUserId = context.read<AuthProvider>().userdata?.data?.Id;
    if (widget.isEdit && widget.pollData != null) {
      final familyList = context.read<CoreProvider>().familyList?.data;
      widget.pollData?.familyMembers?.forEach((pollMember) {
        try {
          final member = familyList!.firstWhere((listMember) =>
              (listMember.receiverId?.sId == currentUserId
                  ? listMember.senderId?.sId
                  : listMember.receiverId?.sId) ==
              pollMember.sId);

          if ((!selectedFamilyMembers.contains(member))) {
            selectedFamilyMembers.add(member);
            familyList.remove(member);
          }

          log("Member Added");
        } catch (e) {
          // Handle the case where no matching element is found
          print('No matching element found for ${pollMember.sId}');
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  preSetData() {
    print("PRE SETTING DATAAA");
    description.text = widget.pollData?.title ?? '';

    selectedDate = DateTime.parse(widget.pollData!.endTime!);

    pollEndDate.text =
        Utils.formatDate(pattern: 'MM/dd/yyyy', date: selectedDate);
    widget.pollData?.button?.forEach((element) {
      buttonPost.add(element.text ?? 'NO TEXT');
      print("Adding Button ${element.text}");
    });

    selectedRecipie = widget.pollData?.recipeModel;
  }

  String utcMaker(String localTime) {
    // Split the local time string into hours, minutes, and period (AM/PM)
    List<String> parts = localTime.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    String period = parts[1]; // Extract the AM/PM part

    // Convert hours to 24-hour format
    if (period.toUpperCase() == 'PM' && hours < 12) {
      hours += 12;
    } else if (period.toUpperCase() == 'AM' && hours == 12) {
      hours = 0;
    }

    // Get the current UTC time
    DateTime now = selectedDate!;

    // Create a new DateTime object with the local time
    DateTime localDateTime =
        DateTime(now.year, now.month, now.day, hours, minutes);

    // Convert local time to UTC time
    DateTime utcDateTime = localDateTime.toUtc();

    return utcDateTime.toIso8601String();
  }

  DateTime utcToLocal(String utcTime) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(utcTime, true);
    var dateLocal = dateTime.toLocal();
    return dateLocal;
  }

  @override
  Widget build(BuildContext context) {
    final userID = context.read<AuthProvider>().userdata?.data?.Id;
    // final homeRecipies = context.read<CoreProvider>().getMyRecipies?.data;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
        child: Consumer<CoreProvider>(builder: (context, val, _) {
          if (val.createPollState == States.loading) {
            return const SizedBox(
                height: 40, width: 40, child: CustomLoadingBarWidget());
          }

          return PrimaryButton(
              text: widget.isEdit ? "Save Details" : "Create Poll",
              onTap: () {
                if (_key.currentState!.validate()) {
                  // if (time == null) {
                  //   Utils.showToast(message: "Please enter time");
                  //   return;
                  // }
                  if (selectedFamilyMembers.isEmpty) {
                    Utils.showToast(message: "Please enter family");

                    return;
                  }

                  if (buttonPost.isEmpty || buttonPost.length < 2) {
                    Utils.showToast(message: "Please enter atleast 2 button");

                    return;
                  }

                  if (val.selectedRecipie == null) {
                    Utils.showToast(message: "Please select recipe.");

                    return;
                  }

                  if (widget.isEdit && widget.pollData != null) {
                    final dateSelected = Utils.formatDate(
                        pattern: 'yyyy/MM/dd', date: selectedDate);

                    final selctedFamilyMembersIDs = selectedFamilyMembers
                        .map((e) => e.receiverId?.sId == userID
                            ? e.senderId?.sId
                            : e.receiverId?.sId)
                        .toList();

                    Map<String, dynamic> createData = {
                      'pole_id': widget.pollData!.sId,
                      'title': description.text,
                      'end_time': dateSelected,
                      'recipe_id': val.selectedRecipie?.reciepieId,
                      'family_members': selctedFamilyMembersIDs
                    };

                    print("CREATE DATA ${createData.toString()}");

                    context.read<CoreProvider>().editPole(createData, () {
                      AppNavigator.pop(context);
                    }, context);
                  } else {
                    List<Map<String, dynamic>> buttonsList = [];

                    buttonPost.forEach((element) {
                      buttonsList.add({'text': element});
                    });

                    final selctedFamilyMembersIDs = selectedFamilyMembers
                        .map((e) => e.receiverId?.sId == userID
                            ? e.senderId?.sId
                            : e.receiverId?.sId)
                        .toList();

                    final dateSelected = Utils.formatDate(
                        pattern: 'yyyy/MM/dd', date: selectedDate);

                    final utcEndTime = utcMaker(pollEndTime.text);

                    print("POLL END UTC TIME $utcEndTime");

                    Map<String, dynamic> createData = {
                      'title': description.text,
                      'end_time': utcEndTime,
                      'button': buttonsList,
                      'recipe_id': val.selectedRecipie?.reciepieId,
                      'family_members': selctedFamilyMembersIDs
                    };

                    // log('SELECTED FAMLI MEMBERS $createData');

                    // /Create Poll Here
                    context.read<CoreProvider>().createPoll(createData, () {
                      AppNavigator.pop(context);
                    }, context);
                  }

                  // AppNavigator.pop(context);
                }
              });
        }),
      ),
      appBar: AppStyles.pinkAppBar(
          context, widget.isEdit ? "Edit Poll" : "Create Poll"),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              const CustomText(
                text: 'Choose Recipe',
                textAlign: TextAlign.start,
                weight: FontWeight.w500,
                fontSize: 18,
              ),

              AppStyles.height18SizedBox(),

              Consumer<CoreProvider>(builder: (context, val, _) {
                // final recipiesList = val.getMyRecipies?.data;
                if (val.getMyReciepiesState == States.loading) {
                  return const CustomLoadingBarWidget();
                } else if (val.getMyReciepiesState == States.failure) {
                  return const Center(
                    child: CustomText(
                      text: 'Something went wrong.',
                    ),
                  );
                }

                if (val.getMyReciepiesState == States.success) {
                  // val.getMyRecipies?.data?.shuffle();
                  print(
                      "Reciepe Response Length ${val.getMyRecipies!.data!.length}");
                  return val.getMyRecipies?.data != null &&
                              val.getMyRecipies!.data!.isEmpty ||
                          userRecipies.isEmpty
                      ? const Center(
                          child: CustomText(
                            text: 'No Recipies yet.',
                          ),
                        )
                      : Column(
                          // physics: const NeverScrollableScrollPhysics(),
                          // crossAxisCount: 2, // 2 items per row
                          // mainAxisSpacing: 10,
                          // crossAxisSpacing: 8,
                          // childAspectRatio: .9,
                          // shrinkWrap:
                          //     true, // to make GridView adapt its size according to its contents
                          children: List.generate(
                            userRecipies.length > 3 ? 3 : userRecipies.length,
                            (index) {
                              final recipe = userRecipies[index];
                              return PollRecipieDisplayWidget(
                                onTap: () {
                                  val.updateSelectedRecipe(recipe,
                                      notify: true);
                                  // setState(() {
                                  //   selectedRecipie = recipe;
                                  // });
                                },
                                recipe: recipe,
                                isSelected: val.selectedRecipie?.reciepieId ==
                                    recipe.reciepieId,
                              );
                            },
                          ),
                        );

                  // GridView.count(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     crossAxisCount: 2, // 2 items per row
                  //     mainAxisSpacing: 10,
                  //     crossAxisSpacing: 8,
                  //     childAspectRatio: .9,
                  //     shrinkWrap:
                  //         true, // to make GridView adapt its size according to its contents
                  //     children: List.generate(
                  //       userRecipies.length > 3 ? 3 : userRecipies.length,
                  //       (index) {
                  //         final recipe = userRecipies[index];
                  //         return PollRecipieDisplayWidget(
                  //           onTap: () {
                  //             val.updateSelectedRecipe(recipe,
                  //                 notify: true);
                  //             // setState(() {
                  //             //   selectedRecipie = recipe;
                  //             // });
                  //           },
                  //           recipe: recipe,
                  //           isSelected: val.selectedRecipie?.reciepieId ==
                  //               recipe.reciepieId,
                  //         );
                  //       },
                  //     ),
                  //   );

                  //  RecipesWidget(
                  //     selectedRecipie: selectedRecipie,
                  //     // isSelected: ,
                  //     onSelectedRecipie: (recipieID) {
                  //       setState(() {
                  //         selectedRecipie = recipieID;
                  //       });
                  //       log("On Recipie Selected ${recipieID}");
                  //     },
                  //     receipies: val.getMyRecipies!.data ?? [],
                  //   );
                }
                return const SizedBox();
              }),

              AppStyles.height18SizedBox(),

              const CustomText(
                text: 'Poll Details',
                textAlign: TextAlign.start,
                weight: FontWeight.w500,
                fontSize: 18,
              ),
              AppStyles.height18SizedBox(),

              PrimaryTextField(
                hintText: "Description",
                controller: description,
                hasOutlined: false,
                borderColor: AppColor.TRANSPARENT_COLOR,
                validator: (val) =>
                    AppValidator.validateField("Description", val!),
                fillColor: Colors.grey.shade100,
              ),
              AppStyles.height8SizedBox(),

              PrimaryTextField(
                hintText: "Poll End Date",
                controller: pollEndDate,
                isReadOnly: true,
                hasOutlined: false,
                onTap: () async {
                  // if (selectedDate!.isBefore(DateTime.now())) {

                  // }

                  final date = await Utils.displayDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                  );
                  if (date != null) {
                    pollEndDate.text =
                        Utils.formatDate(pattern: 'MM/dd/yyyy', date: date);
                    selectedDate = date;

                    setState(() {});
                  }
                },
                borderColor: AppColor.TRANSPARENT_COLOR,
                validator: (val) =>
                    AppValidator.validateField("Poll End Time", val!),
                fillColor: Colors.grey.shade100,
              ),

              AppStyles.height8SizedBox(),

              PrimaryTextField(
                hintText: "Poll End Time",
                controller: pollEndTime,
                enabled: selectedDate != null,
                isReadOnly: true,
                hasOutlined: false,
                onTap: () async {
                  final timeOfDay = await Utils.timePicker(
                    initialTime: selectedTimeOfTheDay,
                    context: context,
                  );

                  if (timeOfDay != null) {
                    DateTime now = DateTime.now();
                    DateTime selectedDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      timeOfDay.hour,
                      timeOfDay.minute,
                    );

                    // Check if the selected date is today and the selected time is before the current time
                    if (selectedDate!.isAtSameMomentAs(now) ||
                        selectedDateTime.isBefore(now)) {
                      // Show an error dialog
                      // ignore: use_build_context_synchronously
                      AppDialog.showDialogs(
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                                'Please select a time greater than the current time.'),
                            AppStyles.height12SizedBox(),
                            PrimaryButton(
                              text: 'Continue',
                              onTap: () {
                                AppNavigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        "Invalid Time",
                        context,
                      );
                    } else {
                      // Extract hours, minutes, and AM/PM from the TimeOfDay object
                      int hours = timeOfDay.hour;
                      int minutes = timeOfDay.minute;
                      String period = hours < 12 ? 'AM' : 'PM';

                      // Convert hours to 12-hour format
                      if (hours > 12) {
                        hours -= 12;
                      } else if (hours == 0) {
                        hours = 12;
                      }

                      // Pad the hours and minutes with leading zeros if necessary
                      String formattedHours = hours < 10 ? '0$hours' : '$hours';
                      String formattedMinutes =
                          minutes < 10 ? '0$minutes' : '$minutes';

                      // Set the text field with the formatted time
                      pollEndTime.text =
                          '$formattedHours:$formattedMinutes $period';

                      selectedTimeOfTheDay = timeOfDay;
                    }
                  }
                },
                borderColor: AppColor.TRANSPARENT_COLOR,
                validator: (val) =>
                    AppValidator.validateField("Poll End Time", val!),
                fillColor: Colors.grey.shade100,
              ),

              // DropDownField(
              //   onValueChanged: (v) {
              //     time = v;
              //     setState(() {});
              //   },
              //   hint: "Poll End Time",
              //   items: const ["Today", "Tommorrow", "1 Week", "1 Month"],
              //   backgroundColor: Colors.grey.shade100,
              //   borderColor: AppColor.TRANSPARENT_COLOR,
              //   hintColor: AppColor.COLOR_BLACK,
              //   selected_value: time,
              // ),
              AppStyles.height8SizedBox(),
              Consumer<CoreProvider>(builder: (context, val, _) {
                return val.getFamilyListState == States.loading
                    ? FamliyDropdowm(
                        onValueChanged: (v) {
                          // if (selectedFamilyMembers.contains(v)) {
                          //   return;
                          // } else {
                          //   selectedFamilyMembers.add(v!);
                          // }
                          // setState(() {});
                        },
                        hint: "Loading househould members/family/friends",
                        items: [],
                        backgroundColor: Colors.grey.shade100,
                        borderColor: AppColor.TRANSPARENT_COLOR,
                        hintColor: AppColor.COLOR_BLACK,
                        selected_value: null,
                      )
                    : FamliyDropdowm(
                        onValueChanged: (v) {
                          if (selectedFamilyMembers.contains(v)) {
                            return;
                          } else {
                            val.familyList?.data?.remove(v);
                            selectedFamilyMembers.add(v!);
                            // val.familyList.data.remove(v);
                          }
                          setState(() {});
                        },
                        hint: "Add househould members/family/friends",
                        items: val.familyList?.data ?? <FamilyData>[],
                        backgroundColor: Colors.grey.shade100,
                        borderColor: AppColor.TRANSPARENT_COLOR,
                        hintColor: AppColor.COLOR_BLACK,
                        selected_value: null,
                      );
              }),

              Visibility(
                visible: selectedFamilyMembers.isNotEmpty,
                child: SizedBox(
                  height: 60,
                  child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          AppStyles.height8SizedBox(width: 10, height: 0),
                      itemCount: selectedFamilyMembers.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColor.THEME_COLOR_SECONDARY),
                          child: Row(
                            children: [
                              CustomText(
                                  text: selectedFamilyMembers[index]
                                              .receiverId
                                              ?.sId ==
                                          userID
                                      ? selectedFamilyMembers[index]
                                          .senderId
                                          ?.userName
                                      : selectedFamilyMembers[index]
                                          .receiverId
                                          ?.userName),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  context
                                      .read<CoreProvider>()
                                      .familyList
                                      ?.data
                                      ?.add(selectedFamilyMembers[index]);
                                  setState(() {
                                    selectedFamilyMembers.removeAt(index);

                                    //  val.familyList?.data?.remove(v);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.COLOR_RED1),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColor.COLOR_WHITE,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              AppStyles.height8SizedBox(),
              // DecisionContainer(
              //   containerColor: Colors.grey.shade200,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       AppStyles.subHeadingStyle(
              //         "Add Questions",
              //       ),
              //       AppStyles.height8SizedBox(),
              //       Column(
              //           children: List.generate(
              //         suggestionString.length,
              //         (index) => Padding(
              //           padding: const EdgeInsets.only(bottom: 8.0),
              //           child: PrimaryTextField(
              //             hintText: "Description",
              //             controller: TextEditingController(
              //                 text: suggestionString[index]),
              //             hasOutlined: false,
              //             isReadOnly: true,
              //             borderColor: AppColor.TRANSPARENT_COLOR,
              //             hasTrailingWidget: true,
              //             trailingWidgetList: InkWell(
              //                 onTap: () {
              //                   suggestionString.removeAt(index);
              //                   setState(() {});
              //                 },
              //                 child: const Icon(Icons.cancel,
              //                     color: AppColor.COLOR_RED1)),
              //             validator: (val) =>
              //                 AppValidator.validateField("Description", val!),
              //             fillColor: Colors.grey.shade100,
              //           ),
              //         ),
              //       )),
              //       PrimaryTextField(
              //         hintText: "Enter Suggestion",
              //         controller: suggestionController,
              //         hasOutlined: false,
              //         borderColor: AppColor.TRANSPARENT_COLOR,
              //         fillColor: Colors.grey.shade100,
              //       ),
              //       AppStyles.height8SizedBox(),
              //       PrimaryButton(
              //           text: "Add Suggestion",
              //           imagePath: AssetPath.ADD,
              //           iconColor: AppColor.COLOR_WHITE,
              //           onTap: () {
              //             if (suggestionController.text.trim().isNotEmpty) {
              //               suggestionString.add(suggestionController.text);
              //               suggestionController.clear();
              //               setState(() {});
              //             }
              //           })
              //     ],
              //   ),
              // ),

              Visibility(
                visible: !widget.isEdit,
                child: DecisionContainer(
                  containerColor: Colors.grey.shade200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppStyles.subHeadingStyle(
                        "Poll Buttons",
                      ),
                      AppStyles.height8SizedBox(),
                      Column(
                          children: List.generate(
                        buttonPost.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: PrimaryTextField(
                            hintText: "",
                            controller:
                                TextEditingController(text: buttonPost[index]),
                            hasOutlined: false,
                            isReadOnly: true,
                            borderColor: AppColor.TRANSPARENT_COLOR,
                            hasTrailingWidget: false,
                            // trailingWidgetList: InkWell(
                            //     onTap: () {
                            //       buttonPost.removeAt(index);
                            //       setState(() {});
                            //     },
                            //     child: const Icon(Icons.cancel,
                            //         color: AppColor.COLOR_RED1)),
                            validator: (val) =>
                                AppValidator.validateField("Description", val!),
                            fillColor: Colors.grey.shade100,
                          ),
                        ),
                      )),
                      buttonPost.length >= 2
                          ? const SizedBox()
                          : PrimaryTextField(
                              hintText: "Enter button text",
                              controller: buttonController,
                              hasOutlined: false,
                              borderColor: AppColor.TRANSPARENT_COLOR,
                              fillColor: Colors.grey.shade100,
                            ),
                      AppStyles.height8SizedBox(),
                      buttonPost.length >= 2
                          ? const SizedBox()
                          : PrimaryButton(
                              text: "Add Buttons",
                              onTap: () {
                                if (buttonController.text.trim().isNotEmpty) {
                                  buttonPost.add(buttonController.text);
                                  buttonController.clear();
                                  setState(() {});
                                }
                              })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PollRecipieDisplayWidget extends StatelessWidget {
  const PollRecipieDisplayWidget({
    super.key,
    required this.recipe,
    required this.isSelected,
    this.onTap,
  });

  final RecipeModel recipe;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            // width: 1p,
            // height: 200,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.COLOR_WHITE,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.THEME_COLOR_SECONDARY.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 10,
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: recipe.recipeImages != null &&
                          recipe.recipeImages!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: MyCustomExtendedImage(
                            imageUrl: recipe.recipeImages![0].startsWith('http')
                                ? recipe.recipeImages![0]
                                : dotenv.get('IMAGE_URL') +
                                    recipe.recipeImages![0],
                          ),
                        )
                      : Center(
                          child: Image.asset(
                            AssetPath.PHOTO_PLACE_HOLDER,
                            fit: BoxFit.cover,
                            scale: 2,
                          ),
                        ),
                ),
                AppStyles.height8SizedBox(),
                SizedBox(
                  // width: MediaQuery.of(context).size.width / 2,
                  child: AppStyles.headingStyle(
                    recipe.title ?? '',
                    textAlign: TextAlign.start,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // AppStyles.height12SizedBox(),
                // ProfileBanner(
                //   userModelData: recipe.userData,
                //   radius: 14,
                //   nameSize: 14,
                // ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: AppColor.THEME_COLOR_SECONDARY,
                  borderRadius: BorderRadius.circular(8)),
              child: CustomText(
                text: recipe.prefrence.toString().capitalizeFirstLetter(),
              ),
            ),
          ),
          isSelected != null && isSelected == true
              ? Positioned(
                  top: 10,
                  right: 15,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: AppColor.THEME_COLOR_SECONDARY,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.check)),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

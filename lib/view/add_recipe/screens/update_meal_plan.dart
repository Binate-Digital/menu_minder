import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/primary_textfield.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/image_chooser.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/app_validator.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/config.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/add_recipe/data/create_reciepe_model.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:provider/provider.dart';

import '../../../common/dropdown_widget.dart';
import '../../../utils/toast.dart';
import '../data/k_ingredeitns.dart';

class UpdateMealPlanScreen extends StatefulWidget {
  final bool? isEdit;
  final MealPlanModel? mealPlanModel;
  final bool isMealPlan;
  final String mealType;
  final String? date;
  final String? title;
  final String? buttonText;
  final bool loadMyReciepies;

  const UpdateMealPlanScreen(
      {super.key,
      this.isEdit = false,
      this.mealPlanModel,
      this.title,
      this.buttonText,
      this.loadMyReciepies = false,
      this.date,
      this.isMealPlan = false,
      required this.mealType});

  @override
  State<UpdateMealPlanScreen> createState() => _UpdateMealPlanScreenState();
}

class _UpdateMealPlanScreenState extends State<UpdateMealPlanScreen> {
  List<String> imageList = [];
  List<String> networkImages = [];
  List<String> ingredientsList = [];
  final ingredientsController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final servingSize = TextEditingController();
  final instructionsController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final List<Map<String, TextEditingController>> ingredientsControllerList = [];

  _buildController(KIngredeint ingredeint) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: TextFieldItem(
              hintText: "Item",
              controller: ingredeint.itemController,
              hasOutlined: false,
              horizontalPadding: 6,
              hasPrefix: false,
              maxLines: 1,
              hasTrailingWidget: false,
              borderColor: AppColor.TRANSPARENT_COLOR,
              validator: (val) => AppValidator.validateField("Item", val!),
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFieldItem(
              hintText: "Qty",
              inputFormatters: [
                FilteringTextInputFormatter.deny('|'),
                // FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              controller: ingredeint.valueController,
              hasOutlined: false,
              // contentPadding: EdgeInsets.zero,
              horizontalPadding: 5,
              maxLines: 1,
              borderColor: AppColor.TRANSPARENT_COLOR,
              // validator: (val) => AppValidator.validateField("Value", val!),
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: DropDownField(
              backgroundColor: Colors.grey.shade100,
              hint: 'Unit',
              iconSize: 24,
              selected_value: ingredeint.dropdownValue,
              items: AppConfig.mesaureMents,
              onValueChanged: (t) {
                setState(() {
                  ingredeint.dropdownValue = t;
                });
              },
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              setState(() {
                allIngredients.remove(ingredeint);
              });
            },
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: AppColor.THEME_COLOR_SECONDARY,
              child: Icon(Icons.remove),
            ),
          ),
        ],
      ),
    );
  }

  // _buildController(Map<String, TextEditingController> controllers) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 10),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: PrimaryTextField(
  //             hintText: "Item",
  //             controller: controllers['item']!,
  //             hasOutlined: false,
  //             maxLines: 1,
  //             borderColor: AppColor.TRANSPARENT_COLOR,
  //             validator: (val) => AppValidator.validateField("Item", val!),
  //             fillColor: Colors.grey.shade100,
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 10,
  //         ),
  //         Expanded(
  //           child: PrimaryTextField(
  //             hintText: "Value",
  //             controller: controllers['value']!,
  //             hasOutlined: false,
  //             maxLines: 1,
  //             borderColor: AppColor.TRANSPARENT_COLOR,
  //             validator: (val) => AppValidator.validateField("Value", val!),
  //             fillColor: Colors.grey.shade100,
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 10,
  //         ),
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               ingredientsControllerList.remove(controllers);
  //             });
  //           },
  //           child: const CircleAvatar(
  //             radius: 18,
  //             backgroundColor: AppColor.THEME_COLOR_SECONDARY,
  //             child: Icon(Icons.remove),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  List<KIngredeint> allIngredients = [];

  @override
  void initState() {
    context.read<CoreProvider>().initState();
    if (widget.isEdit ?? false) {
      setControllers();
    }
    super.initState();
  }

  setControllers() {
    if (widget.mealPlanModel != null) {
      titleController.text = widget.mealPlanModel!.reciepieData?.title ?? '';
      descriptionController.text =
          widget.mealPlanModel!.reciepieData?.discription ?? '';
      instructionsController.text =
          widget.mealPlanModel!.reciepieData?.instruction ?? '';

      servingSize.text = widget.mealPlanModel?.reciepieData?.servingSize != null
          ? widget.mealPlanModel!.reciepieData!.servingSize.toString()
          : '';

      widget.mealPlanModel?.reciepieData?.ingredients?.forEach((element) {
        // TextEditingController key =
        //     TextEditingController(text: element.keys.first);
        // TextEditingController value =
        //     TextEditingController(text: element.values.first);

        // ingredientsControllerList.add({'item': key, 'value': value});

        TextEditingController key =
            TextEditingController(text: element.keys.first);

        TextEditingController value = TextEditingController(
            text: element.values.first.toString().contains('|')
                ? element.values.first.toString().split('|').first
                : element.values.first.toString());

        String? dropdownV = element.values.first.toString().contains('|')
            ? element.values.first.toString().split('|').last
            : null;

        allIngredients.add(KIngredeint(
            itemController: key,
            valueController: value,
            dropdownValue: dropdownV));
      });

      if (widget.mealPlanModel?.reciepieData?.recipeImages != null &&
          widget.mealPlanModel!.reciepieData!.recipeImages!.isNotEmpty) {
        networkImages.addAll(widget.mealPlanModel!.reciepieData!.recipeImages!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.pinkAppBar(
        context,
        "Edit Meal Plan",
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimen.SCREEN_PADDING),
        child: Consumer<CoreProvider>(builder: (context, val, _) {
          if (val.addReceipeSate == States.success) {
            print("Yahan Success m Chala Gyaaa");
            // val.initState();
            // AppMessage.showMessage(widget.isEdit!
            //     ? 'Meal Plan Updated Successfully'
            //     : 'Meal Plan Added Successfully');

            // AppNavigator.pop(context);
          } else if (val.addReceipeSate == States.loading) {
            return const SizedBox(
              height: 40,
              width: 40,
              child: CustomLoadingBarWidget(),
            );
          }

          return PrimaryButton(
              text: "Save Details",
              onTap: () {
                if (_key.currentState!.validate()) {
                  final List<Map<String, String>> ingredients = [];

                  bool notValid = allIngredients.any((element) =>
                      element.valueController.text.isNotEmpty &&
                      element.dropdownValue == null);

                  if (notValid) {
                    CustomToast().showToast(message: 'Please Select all units');
                    return;
                  }

                  // log("Ingredients Result ${ingredientsControllerList.length}");

                  for (var e in allIngredients) {
                    final item = e.itemController.text.toString();
                    String value = e.valueController.text.toString();

                    if (value.isNotEmpty && e.dropdownValue != null) {
                      value = '$value|${e.dropdownValue}';
                    }

                    final Map<String, String> map = {item: value};

                    ingredients.add(map);
                  }

                  Map<String, String> mergedMap = {};

                  for (var map in ingredients) {
                    mergedMap.addAll(map);
                  }

                  // log("Dataaa $ingredients");

                  final model = CreateReceipeModel(
                      title: titleController.text,
                      servingSize: servingSize.text.isNotEmpty
                          ? int.parse(servingSize.text)
                          : null,
                      descriptions: descriptionController.text == ""
                          ? " "
                          : descriptionController.text,
                      instructions: instructionsController.text,
                      images: imageList,
                      ingredients: mergedMap,
                      type: widget.isMealPlan ? 'Meal Plan' : 'Recipe');

                  // if (widget.isEdit!) {
                  print(
                      "////------------Updating Meal Plan------------------//////");
                  context.read<CoreProvider>().editReciepe(
                      context, model, ingredients, onSuccess: () async {
                    // val.initState();
                    val.initState();
                    await Future.delayed(const Duration(milliseconds: 400));
                    final userID =
                        // ignore: use_build_context_synchronously
                        context.read<AuthProvider>().userdata?.data?.Id;
                    // ignore: use_build_context_synchronously
                    context.read<CoreProvider>().getAllMealPalnsByType(
                        context, widget.mealType, widget.date);

                    AppNavigator.pop(context);
                  },
                      editRecipeID:
                          widget.mealPlanModel?.reciepieData?.reciepieId,
                      networksImages: networkImages);
                  // } else {
                  //   print(
                  //       "Adding New Meal Plan  date ${widget.date}  mealType :${widget.mealType}  ");
                  //   print(
                  //       "////------------Add Reciepy------------------//////");
                  //   context.read<CoreProvider>().addNewReciepe(context,
                  //       () async {
                  //     if (widget.isMealPlan) {
                  //       context
                  //           .read<CoreProvider>()
                  //           .getAllMealPalnsByType(context, widget.mealType);
                  //     }
                  //     AppNavigator.pop(context);
                  //   }, model, ingredients,
                  //       isEdit: false,
                  //       // editRecipeID: widget.recipeModel?.reciepieId,
                  //       type: widget.mealType != '' ? widget.mealType : 'No',
                  //       date: widget.date ?? '',
                  //       isMealPlan: widget.isMealPlan);
                  // }
                  // }
                }
              });
        }),
      ),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                PrimaryTextField(
                  hintText: "Add Title",
                  controller: titleController,
                  hasOutlined: false,
                  borderColor: AppColor.TRANSPARENT_COLOR,
                  fillColor: Colors.grey.shade100,
                  validator: (val) => AppValidator.validateField("Title", val!),
                ),
                AppStyles.height16SizedBox(),
                InkWell(
                  onTap: () {
                    ImageChooser().pickImage(context, (path) {
                      imageList.add(path);
                      setState(() {});
                    });
                  },
                  child: DottedBorder(
                    color: AppColor.THEME_COLOR_SECONDARY,
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetPath.UPLOAD,
                            scale: 4,
                          ),
                          AppStyles.height8SizedBox(),
                          AppStyles.contentStyle("Upload Images", fontSize: 14),
                        ],
                      ),
                    ),
                  ),
                ),
                AppStyles.height16SizedBox(),
                if (imageList.isNotEmpty || networkImages.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView(
                      // itemCount: imageList.length,
                      scrollDirection: Axis.horizontal,
                      children: [
                        ////FILE IMAGES SELECTED BY USER
                        ...List.generate(
                          networkImages.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ExtendedImage.network(
                                          dotenv.get('IMAGE_URL') +
                                              networkImages[index],
                                          fit: BoxFit.cover,
                                        )),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: InkWell(
                                        onTap: () {
                                          networkImages.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          color: AppColor.COLOR_RED1,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),

                        ////FILE IMAGES SELECTED BY USER
                        ...List.generate(
                          imageList.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Image.file(
                                          File(imageList[index]),
                                          fit: BoxFit.cover,
                                        )),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: InkWell(
                                        onTap: () {
                                          imageList.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          color: AppColor.COLOR_RED1,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                if (imageList.isNotEmpty || networkImages.isNotEmpty)
                  AppStyles.height16SizedBox(),
                PrimaryTextField(
                  hintText: "Description",
                  controller: descriptionController,
                  hasOutlined: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(275),
                  ],
                  maxLines: 6,
                  borderColor: AppColor.TRANSPARENT_COLOR,
                  // validator: (val) =>
                  //     AppValidator.validateField("Description", val!),
                  fillColor: Colors.grey.shade100,
                ),
                AppStyles.height16SizedBox(),
                PrimaryTextField(
                  // focusNode: servingFocus,
                  hintText: "Serving Size",
                  textInputAction: TextInputAction.done,
                  controller: servingSize,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  inputType: TextInputType.number,

                  // controller: titleController,
                  hasOutlined: false,
                  //  inputFormatters: [],
                  borderColor: AppColor.TRANSPARENT_COLOR,
                  fillColor: Colors.grey.shade100,
                  // validator: (val) =>
                  //     AppValidator.validateField("Serving Size", val!),
                ),
                AppStyles.height16SizedBox(),
                PrimaryTextField(
                  hintText: "Ingredients",
                  controller: ingredientsController,
                  hasOutlined: false,
                  borderColor: AppColor.TRANSPARENT_COLOR,
                  fillColor: Colors.grey.shade100,
                  hasTrailingWidget: true,
                  validator: (val) {
                    if (allIngredients.isEmpty) {
                      return "Please enter atleast 1 ingredient";
                    }
                    return null;
                  },
                  isReadOnly: true,
                  trailingWidget: AssetPath.ADD,
                  onTrailingTap: () {
                    allIngredients.add(KIngredeint(
                        itemController: TextEditingController(),
                        valueController: TextEditingController()));
                    setState(() {});

                    // if (ingredientsController.text.trim().isNotEmpty) {
                    //   ingredientsList.add(ingredientsController.text);
                    //   ingredientsController.text = "";
                    //   setState(() {});
                    // }
                  },
                ),
                if (allIngredients.isNotEmpty)
                  ...List.generate(allIngredients.length,
                      (index) => _buildController(allIngredients[index])),
                AppStyles.height16SizedBox(),
                PrimaryTextField(
                  hintText: "Instructions",
                  controller: instructionsController,
                  hasOutlined: false,
                  validator: (val) =>
                      AppValidator.validateField("Instructions", val!),
                  maxLines: 6,
                  borderColor: AppColor.TRANSPARENT_COLOR,
                  fillColor: Colors.grey.shade100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

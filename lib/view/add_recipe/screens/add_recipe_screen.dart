import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/food_container_widget.dart';
import 'package:menu_minder/utils/config.dart';
import 'package:menu_minder/utils/toast.dart';
import 'package:provider/provider.dart';

import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/common/primary_textfield.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/image_chooser.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/app_validator.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/custom_keybaord_action.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/add_recipe/data/create_reciepe_model.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';

import '../../../common/dropdown_widget.dart';
import '../data/k_ingredeitns.dart';

class AddRecipeScreen extends StatefulWidget {
  final bool? isEdit;
  final RecipeModel? recipeModel;
  final bool isMealPlan;
  final String mealType;
  final String? date;
  final String? title;
  final String? buttonText;
  final bool loadMyReciepies;

  const AddRecipeScreen(
      {super.key,
      this.isEdit = false,
      this.recipeModel,
      this.title,
      this.buttonText,
      this.loadMyReciepies = false,
      this.date,
      this.isMealPlan = false,
      required this.mealType});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  List<String> imageList = [];
  List<String> networkImages = [];
  List<String> ingredientsList = [];
  final ingredientsController = TextEditingController();
  final titleController = TextEditingController();
  final chooseRecipieContoller = TextEditingController();
  final servingSize = TextEditingController();
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();
  final _key = GlobalKey<FormState>();
  FocusNode servingFocus = FocusNode();
  final List<Map<String, TextEditingController>> ingredientsControllerList = [];

  List<KIngredeint> allIngredients = [];

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
                FilteringTextInputFormatter.deny('|'),
                // FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              controller: ingredeint.valueController,
              hasOutlined: false,
              textInputAction: TextInputAction.done,
              inputType: TextInputType.text,
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

  @override
  void initState() {
    // context.read<CoreProvider>().initState();
    if (widget.isEdit ?? false) {
      setControllers();
    }

    if (widget.isMealPlan) {
      // context.read<CoreProvider>().setMyRecipes(null, notify: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<CoreProvider>().loadMyRecipies(
              context,
              context.read<AuthProvider>().userdata!.data!.Id!,
              // onSuccess: () {},
            );
      });
    }
    super.initState();
  }

  setControllers({RecipeModel? recipeFromParams}) {
    if (widget.recipeModel != null) {
      titleController.text = widget.recipeModel?.title ?? '';
      descriptionController.text = widget.recipeModel?.discription ?? '';
      instructionsController.text = widget.recipeModel?.instruction ?? '';
      servingSize.text = widget.recipeModel?.servingSize != null
          ? widget.recipeModel!.servingSize.toString()
          : '';

      widget.recipeModel?.ingredients?.forEach((element) {
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
        // ingredientsControllerList.add({'item': key, 'value': value});
      });

      if (widget.recipeModel!.recipeImages!.isNotEmpty) {
        networkImages.addAll(widget.recipeModel!.recipeImages!);
      }
    } else if (recipeFromParams != null) {
      networkImages.clear();
      titleController.text = recipeFromParams.title ?? '';
      descriptionController.text = recipeFromParams.discription ?? '';
      instructionsController.text = recipeFromParams.instruction ?? '';
      servingSize.text = recipeFromParams.servingSize != null
          ? recipeFromParams.servingSize.toString()
          : '';

      recipeFromParams.ingredients?.forEach((element) {
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
        // ingredientsControllerList.add({'item': key, 'value': value});
      });

      if (recipeFromParams.recipeImages!.isNotEmpty) {
        networkImages.addAll(recipeFromParams.recipeImages!);
      }
      setState(() {});
    }
  }

  showRecipiePopup() {
    AppDialog.showBottomPanel(
        // Column(
        //   children: [
        //     ListView.separated(
        //         physics: NeverScrollableScrollPhysics(),
        //         itemBuilder: (context, index) {
        //           return _buildRecipeContainer(recipies![index]);
        //         },
        //         separatorBuilder: (context, index) {
        //           return SizedBox(height: 10);
        //         },
        //         itemCount: recipies?.length ?? 0)
        //   ],
        // ),
        // 'Select Recipe',
        context,
        Container(
          height: MediaQuery.of(context).size.height * 0.9,
          // decoration: const BoxDecoration(color: AppColor.BG_COLOR),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Consumer<CoreProvider>(builder: (context, val, _) {
              final recipies = val.myAllReciepies?.data
                      ?.where((element) => element.is_spooncular == 0)
                      .toList() ??
                  [];
              return Column(
                children: [
                  Container(
                    decoration: AppStyles.dialogLinearGradient(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 60,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () => AppNavigator.pop(context),
                              child: const CircleAvatar(
                                backgroundColor: AppColor.COLOR_RED1,
                                radius: 10,
                                child: Icon(Icons.close_rounded,
                                    size: 16, color: AppColor.COLOR_WHITE),
                              )),
                        ),
                        const Center(
                          child: Text(
                            'Choose Recipe',
                            style: TextStyle(
                                color: AppColor.COLOR_WHITE, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: recipies.isEmpty
                        ? const Center(
                            child: CustomText(
                              text: 'No Recipes available',
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 3.7),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return FoodContainer(
                                onTap: () {
                                  setControllers(
                                      recipeFromParams: recipies[index]);
                                  AppNavigator.pop(context);
                                },
                                index: index,
                                recipeModel: recipies![index],
                              );
                            },
                            itemCount: recipies?.length ?? 0),
                  )
                ],
              );
            }),
          ),
        ));
    // hasBack: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppStyles.pinkAppBar(
        context,
        widget.title != null
            ? widget.title!
            : widget.isEdit!
                ? "Edit Recipe"
                : "Add Recipe",
        onleadingTap: () => Navigator.pop(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimen.SCREEN_PADDING, vertical: 10),
        child: Consumer<CoreProvider>(builder: (context, val, _) {
          if (val.addReceipeSate == States.success) {
            // val.initState();
            // AppMessage.showMessage(widget.isEdit!
            //     ? 'Receipe Updated Successfully'
            //     : 'Receipe Added Successfully');

            // AppNavigator.pop(context);
          } else if (val.addReceipeSate == States.loading) {
            return Container(
              height: 40,
              decoration: const BoxDecoration(color: AppColor.COLOR_WHITE),
              child: const Center(
                // height: 40,
                // width: 40,
                child: CustomLoadingBarWidget(),
              ),
            );
          }

          return PrimaryButton(
              text: widget.buttonText != null
                  ? widget.buttonText!
                  : widget.isEdit!
                      ? "Save Details"
                      : "Add Recipe",
              onTap: () {
                if (_key.currentState!.validate()) {
                  final List<Map<String, String>> ingredients = [];

                  // log("Ingredients Result ${ingredientsControllerList.length}");

                  bool notValid = allIngredients.any((element) =>
                      element.valueController.text.isNotEmpty &&
                      element.dropdownValue == null);

                  if (notValid) {
                    CustomToast().showToast(message: 'Please Select all units');
                    return;
                  }

                  for (var e in allIngredients) {
                    final item = e.itemController.text.toString();
                    String value = e.valueController.text.toString();

                    if (value.isNotEmpty && e.dropdownValue != null) {
                      value = '$value|${e.dropdownValue}';
                    }

                    final Map<String, String> map = {item: value};

                    ingredients.add(map);
                  }

                  print(ingredients.toString());

                  Map<String, String> mergedMap = {};

                  for (var map in ingredients) {
                    mergedMap.addAll(map);
                  }

                  print(
                      "Description Yeh Ja rhii hai ${descriptionController.text}");
                  // print("Servcing SIze Yeh Ja rhii hai ${servingSize.text}");
                  final model = CreateReceipeModel(
                      title: titleController.text.trim(),
                      servingSize: servingSize.text.isNotEmpty
                          ? int.parse(servingSize.text)
                          : null,
                      descriptions: descriptionController.text == ""
                          ? " "
                          : descriptionController.text,
                      instructions: instructionsController.text,
                      images: imageList,
                      ingredients: mergedMap,
                      type: widget.isMealPlan ? 'Meal Plan' : 'Reciepe');

                  if (widget.isEdit!) {
                    print(
                        "////------------Updating Reciepy------------------//////");
                    context.read<CoreProvider>().editReciepe(
                        context, model, ingredients, onSuccess: () async {
                      // val.initState();
                      // val.initState();
                      await Future.delayed(const Duration(milliseconds: 400));
                      final userID =
                          // ignore: use_build_context_synchronously
                          context.read<AuthProvider>().userdata?.data?.Id;
                      // ignore: use_build_context_synchronously
                      context
                          .read<CoreProvider>()
                          .getReciepiesByUserID(context, userID);

                      context.read<CoreProvider>().getHomeRecipies(context, '');

                      // ignore: use_build_context_synchronously
                      AppNavigator.pop(context);
                      // ignore: use_build_context_synchronously
                      AppNavigator.pop(context);
                    },
                        editRecipeID: widget.recipeModel?.reciepieId,
                        networksImages: networkImages);
                  } else {
                    print(
                        "Adding New Meal Plan  date ${widget.date}  mealType :${widget.mealType}  ");
                    print(
                        "////------------Add Recipie------------------//////");
                    context.read<CoreProvider>().addNewReciepe(
                      context,
                      () async {
                        if (widget.isMealPlan) {
                          context.read<CoreProvider>().getAllMealPalnsByType(
                              context, widget.mealType, widget.date);
                        } else {
                          context.read<CoreProvider>().getReciepiesByUserID(
                              context,
                              context.read<AuthProvider>().userdata?.data?.Id ??
                                  '');
                          context
                              .read<CoreProvider>()
                              .getHomeRecipies(context, '');
                        }
                        AppNavigator.pop(context);
                      },
                      model,
                      ingredients,
                      isEdit: false,
                      editRecipeID: widget.recipeModel?.reciepieId,
                      type: widget.mealType != '' ? widget.mealType : 'No',
                      date: widget.date ?? '',
                      isMealPlan: widget.isMealPlan,
                      networksImages: networkImages,
                    );
                  }
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
                if (widget.isMealPlan)
                  Column(
                    children: [
                      PrimaryTextField(
                        hintText: "Choose Recipe",
                        controller: chooseRecipieContoller,
                        // controller: titleController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(256),
                        ],
                        hasOutlined: false,
                        isReadOnly: true,
                        onTap: () {
                          showRecipiePopup();
                        },
                        trailingWidget: AssetPath.ADD,
                        hasTrailingWidget: true,
                        borderColor: AppColor.TRANSPARENT_COLOR,
                        fillColor: Colors.grey.shade100,
                        // validator: (val) =>
                        //     AppValidator.validateField("Title", val!),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),

                PrimaryTextField(
                  hintText: "Add Title",
                  controller: titleController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(256),
                  ],
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
                        ////FILE IMAGES SELECTED BY USERp
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
                                          networkImages[index]
                                                  .startsWith('http')
                                              ? networkImages[index]
                                              : dotenv.get('IMAGE_URL') +
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
                  inputType: TextInputType.text,
                  maxLines: 6,
                  borderColor: AppColor.TRANSPARENT_COLOR,
                  // validator: (val) =>
                  //     AppValidator.validateField("Description", val!),
                  fillColor: Colors.grey.shade100,
                ),
                AppStyles.height16SizedBox(),
                PrimaryTextField(
                  focusNode: servingFocus,
                  hintText: "Serving Size",
                  controller: servingSize,
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  textInputAction: TextInputAction.done,
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
                    // final model = {
                    //   'item': TextEditingController(),
                    //   'value': TextEditingController()
                    // };
                    // ingredientsControllerList.add(model);

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
                // if (ingredientsControllerList.isNotEmpty)
                //   ...List.generate(
                //       ingredientsControllerList.length,
                //       (index) =>
                //           _buildController(ingredientsControllerList[index])),

                ///NEW INGREDEINTS
                if (allIngredients.isNotEmpty)
                  ...List.generate(allIngredients.length,
                      (index) => _buildController(allIngredients[index])),
                // if (ingredientsList.isNotEmpty)
                //   SizedBox(
                //       height: 50,
                //       child: ListView.builder(
                //         scrollDirection: Axis.horizontal,
                //         itemCount: ingredientsList.length,
                //         itemBuilder: (context, index) => Container(
                //           margin: const EdgeInsets.only(right: 10),
                //           child: FoodChip(
                //             label: ingredientsList[index],
                //             isDeleteable: true,
                //             onDelete: () {
                //               ingredientsList.removeAt(index);
                //               setState(() {});
                //             },
                //             color: AppColor.THEME_COLOR_SECONDARY,
                //           ),
                //         ),
                //       )),
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

                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

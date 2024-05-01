import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/grocery_list/model/grocery_list_model.dart';
import 'package:provider/provider.dart';

import '../../../common/primary_textfield.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_validator.dart';

class CreateGroceryListScreen extends StatefulWidget {
  final bool isEdit;
  final GroceryListModel? groceryListModel;
  const CreateGroceryListScreen(
      {super.key, required this.isEdit, this.groceryListModel});

  @override
  State<CreateGroceryListScreen> createState() =>
      _CreateGroceryListScreenState();
}

class _CreateGroceryListScreenState extends State<CreateGroceryListScreen> {
  final ingredientsController = TextEditingController();
  final quantityController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();
  List<GroceryModel> groceryList = [];
  final storeNameController = TextEditingController();

  @override
  void initState() {
    // if (widget.isEdit && widget.groceryListModel?.data != null) {
    // widget.groceryListModel?.data?.groceryList?.forEach((element) {
    //   final groceryModel = GroceryModel(
    //     TextEditingController(text: element.productName),
    //     TextEditingController(text: element.productQuantity.toString()),
    //     TextEditingController(text: element.productDiscription),
    //   );
    //   groceryList.add(groceryModel);
    // });
    // } else {
    groceryList.add(
      GroceryModel(
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ),
    );
    // }
    super.initState();
  }

  List<String> removedIDs = [];

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppStyles.pinkAppBar(context, "Create Grocery List"),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimen.SCREEN_PADDING, vertical: 10),
        child: Consumer<CoreProvider>(builder: (context, v, child) {
          return v.createGroceryState == States.loading
              ? Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColor.COLOR_WHITE,
                  ),
                  child: const Center(child: CustomLoadingBarWidget()))
              : PrimaryButton(
                  text: widget.isEdit ? "Save Detail" : "Create List",
                  onTap: () {
                    if (_key.currentState!.validate()) {
                      final gorceryRequestMode = groceryList
                          .map((e) => e.convertToGroceryRequestModel())
                          .toList();

                      Map<String, dynamic> requestBody = {
                        "store_name": storeNameController.text.trim(),
                        "grocery_list": gorceryRequestMode,
                      };

                      if (removedIDs.isNotEmpty) {
                        requestBody['remove_list'] = removedIDs;
                      }

                      print("Request Body $requestBody");

                      context
                          .read<CoreProvider>()
                          .createORUpdateGrocery(requestBody, () {
                        // if (widget.isEdit) {
                        //   AppNavigator.pop(context);
                        // }
                        AppNavigator.pop(context);
                        // AppNavigator.pop(context);
                        bottomIndex.value = 2;
                      });

                      // AppNavigator.pop(context);
                      // bottomIndex.value = 2;
                    }
                  });
        }),
      ),
      body: Padding(
        padding: AppStyles.screenPadding(),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
              child: Column(
            children: [
              PrimaryTextField(
                hintText: "Store Name",
                controller: storeNameController,
                hasOutlined: false,
                borderColor: AppColor.TRANSPARENT_COLOR,
                fillColor: Colors.grey.shade100,
                validator: (val) =>
                    AppValidator.validateField("Store Name", val!),
              ),
              AppStyles.height12SizedBox(),
              ...List.generate(
                groceryList.length,
                (index) => Column(
                  children: [
                    PrimaryTextField(
                      hintText: "Product Name",
                      controller: groceryList[index].name,
                      hasOutlined: false,
                      borderColor: AppColor.TRANSPARENT_COLOR,
                      fillColor: Colors.grey.shade100,
                      validator: (val) =>
                          AppValidator.validateField("Name", val!),
                    ),
                    AppStyles.height12SizedBox(),
                    PrimaryTextField(
                      hintText: "Product Quantity",
                      controller: groceryList[index].quantity,
                      hasOutlined: false,
                      isReadOnly: true,
                      borderColor: AppColor.TRANSPARENT_COLOR,
                      fillColor: Colors.grey.shade100,
                      // hasTrailingWidget: true,
                      inputType: TextInputType.number,
                      validator: (val) =>
                          AppValidator.validateField("Product Quantity", val!),
                      hasTrailingWidget: true,
                      trailingWidgetList: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (groceryList[index].quantity.text.isEmpty) {
                                groceryList[index].quantity.text = "1";
                              } else {
                                groceryList[index].quantity.text = (int.parse(
                                            groceryList[index].quantity.text) +
                                        1)
                                    .toString();
                              }
                              setState(() {});
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
                              child: Text(
                                "+",
                                style: TextStyle(
                                    color: AppColor.COLOR_WHITE, fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if (groceryList[index].quantity.text.isNotEmpty) {
                                if (groceryList[index].quantity.text != "1") {
                                  groceryList[index].quantity.text = (int.parse(
                                              groceryList[index]
                                                  .quantity
                                                  .text) -
                                          1)
                                      .toString();
                                } else {
                                  groceryList[index].quantity.clear();
                                }
                              }
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
                              child: Text(
                                "-",
                                style: TextStyle(
                                    color: AppColor.COLOR_WHITE, fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    AppStyles.height12SizedBox(),
                    PrimaryTextField(
                      hintText: "Description",
                      controller: groceryList[index].description,
                      hasOutlined: false,
                      maxLines: 6,
                      inputType: TextInputType.text,
                      borderColor: AppColor.TRANSPARENT_COLOR,
                      validator: (val) =>
                          AppValidator.validateField("Description", val!),
                      fillColor: Colors.grey.shade100,
                    ),
                    AppStyles.height12SizedBox(),
                    PrimaryButton(
                      text: "Add Another",
                      onTap: () {
                        increment();
                        setState(() {});
                      },
                      imagePath: AssetPath.ADD,
                      iconColor: AppColor.COLOR_WHITE,
                    ),
                    AppStyles.height16SizedBox(),
                    if (index != 0)
                      PrimaryButton(
                        text: "Remove",
                        onTap: () {
                          decrement(index);
                          // if (widget.isEdit &&
                          //     widget.groceryListModel?.data != null) {
                          //   if (index <
                          //       widget.groceryListModel!.data!.groceryList!
                          //           .length) {
                          //     removedIDs.add(widget.groceryListModel!.data!
                          //         .groceryList![index].sId!);
                          //   } else {
                          //     print('Not in Index');
                          //   }
                          // }
                          setState(() {});
                        },
                        imagePath: AssetPath.DELETE,
                        buttonColor: AppColor.COLOR_BLACK,
                        iconColor: AppColor.COLOR_WHITE,
                      ),
                    AppStyles.height16SizedBox()
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          )),
        ),
      ),
    );
  }

  increment() {
    groceryList.add(GroceryModel(TextEditingController(),
        TextEditingController(text: ""), TextEditingController()));
  }

  decrement(int index) {
    groceryList.removeAt(index);
  }
}

class GroceryModel {
  final TextEditingController name;
  final TextEditingController quantity;
  final TextEditingController description;

  GroceryModel(
    this.name,
    this.quantity,
    this.description,
  );
// Create a function to convert grocery items to the required structure
  Map<String, dynamic> convertToGroceryRequestModel() {
    return {
      "product_name": name.text,
      "product_quantity": quantity.text,
      "product_discription": description.text,
    };
  }
}

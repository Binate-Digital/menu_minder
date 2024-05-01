import 'package:flutter/material.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:provider/provider.dart';

import '../../common/primary_button.dart';
import '../../common/primary_textfield.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_validator.dart';
import '../../utils/styles.dart';
import '../grocery_list/model/grocery_list_model.dart';

class EditASingleGroceryItem extends StatefulWidget {
  const EditASingleGroceryItem({super.key, required this.groceryData});
  final GroceryItem groceryData;

  @override
  State<EditASingleGroceryItem> createState() => _EditASingleGroceryItemState();
}

class _EditASingleGroceryItemState extends State<EditASingleGroceryItem> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController quantity = TextEditingController();

  final TextEditingController description = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nameController.text = widget.groceryData.productName ?? '';
    description.text = widget.groceryData.productDiscription ?? '';
    quantity.text = (widget.groceryData.productQuantity ?? 1).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            PrimaryTextField(
              hintText: "Product Name",
              controller: nameController,
              hasOutlined: false,
              borderColor: AppColor.TRANSPARENT_COLOR,
              fillColor: Colors.grey.shade100,
              validator: (val) => AppValidator.validateField("Name", val!),
            ),
            AppStyles.height12SizedBox(),
            PrimaryTextField(
              hintText: "Product Quantity",
              controller: quantity,
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
                      if (quantity.text.isEmpty) {
                        quantity.text = "1";
                      } else {
                        quantity.text =
                            (int.parse(quantity.text) + 1).toString();
                      }
                      // setState(() {});
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
                      if (quantity.text.isNotEmpty) {
                        if (quantity.text != "1") {
                          quantity.text =
                              (int.parse(quantity.text) - 1).toString();
                        } else {
                          quantity.clear();
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
              controller: description,
              hasOutlined: false,
              maxLines: 5,
              borderColor: AppColor.TRANSPARENT_COLOR,
              validator: (val) =>
                  AppValidator.validateField("Description", val!),
              fillColor: Colors.grey.shade100,
            ),
            AppStyles.height12SizedBox(),
            PrimaryButton(
              text: "Save",
              onTap: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState?.save();
                  widget.groceryData.productName = nameController.text;
                  widget.groceryData.productDiscription = description.text;
                  widget.groceryData.productQuantity = int.parse(quantity.text);
                  context.read<CoreProvider>().updateGroceryItem(
                    context,
                    groceryID: widget.groceryData,
                    onSuccess: () {
                      nameController.clear();
                      description.clear();
                      quantity.clear();
                      AppNavigator.pop(context);
                    },
                  );
                }
              },
              // imagePath: AssetPath.ADD,
              iconColor: AppColor.COLOR_WHITE,
            ),
          ],
        ),
      ),
    );
  }
}

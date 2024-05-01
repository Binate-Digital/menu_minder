import 'package:flutter/material.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/view/grocery_list/model/grocery_list_model.dart';
import 'package:menu_minder/view/notifications/custom_slidable.dart';
import 'package:provider/provider.dart';

import '../../../utils/styles.dart';
import '../../create_grocery_list/edit_a_single_grocery_item.dart';
import '../widgets/grocery_list_widget.dart';

class GroceryDetailsScreen extends StatefulWidget {
  const GroceryDetailsScreen({super.key, required this.groceryData});
  final GroceryData groceryData;

  @override
  State<GroceryDetailsScreen> createState() => _GroceryDetailsScreenState();
}

class _GroceryDetailsScreenState extends State<GroceryDetailsScreen> {
  @override
  void initState() {
    widget.groceryData.groceryList
        ?.sort((a, b) => a.isCheck!.compareTo(b.isCheck!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppStyles.pinkAppBar(context, widget.groceryData.storeName ?? ''),
        body: Padding(
          padding: AppStyles.screenPadding(),
          child: Consumer<CoreProvider>(builder: (context, val, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStyles.headingStyle('Products'),
                AppStyles.height16SizedBox(),
                Expanded(
                    child: ListView.builder(
                  itemCount: widget.groceryData.groceryList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = widget.groceryData.groceryList![index];
                    return GroceryListWidget(
                      index: index,
                      onEditTap: () {
                        AppDialog.showDialogs(
                            EditASingleGroceryItem(
                              groceryData: item,
                            ),
                            'Update Product',
                            context,
                            hasBack: true);
                      },
                      onCheckTapped: () {
                        int isCheck;

                        if (item.isCheck == 1) {
                          isCheck = 0;
                        } else {
                          isCheck = 1;
                        }
                        print("Checked $isCheck");
                        val.checkUnCheckGroceryItem(context, onSuccess: () {
                          AppNavigator.pop(context);
                        },
                            isCheck: isCheck,
                            index: index,
                            groceryID: item,
                            groceryData: widget.groceryData);
                      },
                      product: item,
                      // notifier: notifier,
                    );
                  },
                ))
              ],
            );
          }),
        ));
  }
}

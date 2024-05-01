import '../../../utils/asset_paths.dart';
import '../../../utils/dummy.dart';

class GroceryDetails {
  final String image;
  final String name;
  final String desc;
  bool? isChecked;

  GroceryDetails(this.image, this.name, this.desc, this.isChecked);
}

List<GroceryDetails> groceryList = [
  GroceryDetails(AssetPath.FOOD_ICON1, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON2, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON1, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON2, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON1, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON2, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON1, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON2, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON1, "Lorem Ipsum", LOREMSMALL, false),
  GroceryDetails(AssetPath.FOOD_ICON2, "Lorem Ipsum", LOREMSMALL, false),
];

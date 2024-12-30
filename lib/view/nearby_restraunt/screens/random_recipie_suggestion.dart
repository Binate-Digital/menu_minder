import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/spooncular_provider.dart';
import 'package:menu_minder/services/network/firebase_messaging_service.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/view/spooncular/data/admin_recipes.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/custom_extended_image_with_loading.dart';
import '../../../utils/asset_paths.dart';

class RandomRecipeSuggestionWidget extends StatelessWidget {
  const RandomRecipeSuggestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print('Sjksdskd');
    return Consumer<SpoonCularProvider>(
      builder: (context, provider, _) {
        print(provider.getRandomAdminRecipieState);
        switch (provider.getRandomAdminRecipieState) {
          case States.failure:
            return const SizedBox(); // Optionally add a retry mechanism or an error message.
          case States.loading:
            return _buildLoadingShimmer();
          case States.success:
            final recipe = provider.getRandomAdminRecipe;
            if (recipe == null) {
              return const SizedBox();
            }
            return _buildRecipeContent(recipe, () {
              // provider.selectRecipe(recipe);
            });
          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildRecipeContent(AdminRecipe adminRecipe, VoidCallback onSelect) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      // height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(right: 5),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: adminRecipe.recipeImages != null &&
                    adminRecipe.recipeImages.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MyCustomExtendedImage(
                      imageUrl: adminRecipe.recipeImages[0].startsWith('http')
                          ? adminRecipe.recipeImages[0]
                          : dotenv.get('IMAGE_URL') +
                              adminRecipe.recipeImages[0],
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
          Expanded(
            child: Text(
              adminRecipe.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(  // Cheeseburger and Fries Casserole
            onTap: () {
              print("${adminRecipe.toJson()}");
              AppNavigator.popWithData(
                  StaticData.navigatorKey.currentContext!, adminRecipe.title);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColor.THEME_COLOR_SECONDARY,
                  borderRadius: BorderRadius.circular(8)),
              child: const CustomText(
                text: "Suggest",
                fontColor: AppColor.BG_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/spooncular/data/admin_recipes.dart';
import 'package:menu_minder/view/spooncular/data/spooncular_search_model.dart';
import 'package:provider/provider.dart';

import '../repo/implementation/i_core.dart';
import '../services/network/dio_client.dart';
import '../services/network/firebase_messaging_service.dart';
import '../view/spooncular/data/spooncular_random_reciepies_model.dart';

class SpoonCularProvider extends ChangeNotifier {
  final ICoreModule _coreRepo;
  SpoonCularProvider(this._coreRepo);
  initState() {
    _randomRecipiesLoadState = States.init;
    _recipiesWithDietState = States.init;
    _AdminRecipiesLoadState = States.init;
  }

  States _randomRecipiesLoadState = States.init;
  States get getRandomRecipiesLoadState => _randomRecipiesLoadState;

  States _AdminRecipiesLoadState = States.init;
  States get getAdminRecipiesLoadState => _AdminRecipiesLoadState;

  States _getRecipeDetailsState = States.init;
  States get getRecipeDetailsState => _getRecipeDetailsState;

  States _recipiesWithDietState = States.init;
  States get recipesWithDietState => _recipiesWithDietState;

  SpooncularRecipies? _getRandomRecipies;
  SpooncularRecipies? get getRandomRecipies => _getRandomRecipies;

  Recipes? _singleRecipieDetail;
  Recipes? get singleRecipieDetail => _singleRecipieDetail;

  SearchResultsSpooncular? _searchResultsSpooncular;
  SearchResultsSpooncular? get getSpooncularRecipesWithDiet =>
      _searchResultsSpooncular;

  List<Recipes?> filteredRecipies = [];
  List<RecipeSearchResult?> filteredRecipiesPref = [];
  List<AdminRecipe> adminRecipes = [];
  List<AdminRecipe> filteredAdminRecipes = [];

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int recipeType = 0;
  int get getRecipeType => recipeType;

  initSearching() {
    _isSearching = false;
    // recipeType = 0;
  }

  ///RECIPIES
  getAllRandomReceipes(BuildContext context) async {
    try {
      _changeRandomRecipiesLoadingState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getSpoonCularRecipies();

      // try {
      _getRandomRecipies = SpooncularRecipies.fromJson(response?.data);
      _changeRandomRecipiesLoadingState(States.success);
      // } catch (e) {
      // AppMessage.showMessage(NetworkStrings.SOMETHING_WENT_WRONG);
      // Utils.showToast(message: response!.statusMessage);
      // AppMessage.showMessage(response?.data['message'] ?? '');
      // initState();
      // }
    } on DioException catch (_) {
      _changeRandomRecipiesLoadingState(States.failure);
      initState();
    }
  }

  //RECIPIES
  getSingleRecipeDetail(
      BuildContext context, String id, Function()? onSuccess) async {
    try {
      _changeRecipieDetailState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getRecipeDetailsSpooncular(id);

      // try {
      _singleRecipieDetail = Recipes.fromJson(response?.data);
      _changeRecipieDetailState(States.success);
      onSuccess?.call();

      // } catch (e) {
      // AppMessage.showMessage(NetworkStrings.SOMETHING_WENT_WRONG);
      // Utils.showToast(message: response!.statusMessage);
      // AppMessage.showMessage(response?.data['message'] ?? '');
      // initState();
      // }
    } on DioException catch (_) {
      _changeRecipieDetailState(States.failure);
      initState();
    }
  }

  // Get Recipe From Admin
  getAdminRecipe(BuildContext ctx,
      {bool showLoader = false, String prefsType = "Breakfast"}) async {
    try {
      // if (showLoader) {
      //   AppDialog.showPorgressBar(ctx);
      // }
      _changeAdminRecipiesLoadingState(States.loading);
      Response? response = await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // queryParameters: {'apiKey': dotenv.get('SPOONCULAR_API_KEY')},
        endPoint: 'get-admin-recipe',
      );

      adminRecipes.clear();

      adminRecipesFromJson(response?.data).data.forEach((adRecipe) {
        if (adRecipe.preference.toLowerCase() == prefsType.toLowerCase()) {
          adminRecipes.add(adRecipe);
        }
        print("============> adminRecipes: ${adminRecipes.length}");
      });

      // adminRecipes = adminRecipesFromJson(response?.data).data;

      _changeAdminRecipiesLoadingState(States.success);

      _changeRecipiesWithDietState(States.success);

      print("admin recipes:: ${response?.data}");
      print("admin recipes length :: ${adminRecipes.length}");

      // if (showLoader) {
      //   AppNavigator.pop(ctx);
      // }
    } catch (e) {
      print("admin recipes exception :: ${e.toString()}");
      _changeAdminRecipiesLoadingState(States.failure);
      _changeRecipiesWithDietState(States.failure);
      // if (showLoader) {
      //   AppNavigator.pop(ctx);
      // }
    }
  }

  ///POLLS
  recipiesWithDiet(BuildContext context,
      {int index = 0,
      Function()? onSuccess,
      bool showLoader = false,
      required List<String?>? prefrenceList}) async {
    try {
      if (showLoader) {
        AppDialog.showPorgressBar(context);
      }
      _changeRecipiesWithDietState(States.loading);

      final foodPref = List<String>.from(prefrenceList ?? [])
          .map((e) => e.toLowerCase().toString())
          .toList();

      print("FOOF $foodPref");

      final dietPrefs = List<String>.from(
          context.read<AuthProvider>().userdata?.data?.dietPeferences ?? []);

      if (prefrenceList!.isNotEmpty &&
          context
                  .read<AuthProvider>()
                  .userdata
                  ?.data
                  ?.dietPeferences
                  ?.isNotEmpty ==
              true) {
        print("Current Food Pref $foodPref");

        final random = Random();

        final randomIndex = random.nextInt(foodPref.length);

        final randomDietIndex = random.nextInt(dietPrefs.length);

        final randomFoodPref = foodPref[randomIndex];
        final randomDiet = dietPrefs[randomDietIndex];
        adminRecipes.clear();
        _searchResultsSpooncular = null;

        print("RANDOM INDEX $randomIndex");

        final params = {
          'apiKey': dotenv.get('SPOONCULAR_API_KEY'),
          'diet': randomDiet.toLowerCase(),
          'query': randomFoodPref.toLowerCase()
        };

        Response? response = await _coreRepo.spoonCularSearch(params);

        _searchResultsSpooncular =
            SearchResultsSpooncular.fromJson(response?.data);

        _changeRecipiesWithDietState(States.success);
        if (showLoader) {
          AppNavigator.pop(context);
          await Future.delayed(const Duration(milliseconds: 200));
          onSuccess?.call();
        }
        // onSuccess?.call();
      } else {
        adminRecipes.clear();
        _searchResultsSpooncular = null;
        _changeRecipiesWithDietState(States.loading);
        //Admin
        getAdminRecipe(context, showLoader: true, prefsType: "Breakfast");
      }
    } on DioException catch (e) {
      _changeRecipiesWithDietState(States.failure);
      if (showLoader) {
        AppNavigator.pop(context);
      }
      initState();
    }
  }

  updateSearch(String query) {
    print("Updting Search");
    if (query.isNotEmpty) {
      filteredRecipies = _getRandomRecipies!.recipes!
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _isSearching = true;
      notifyListeners();
    } else {
      _isSearching = false;
      notifyListeners();
    }
  }

  updateSearchPrefRecipies(String query) {
    if (query.isNotEmpty) {
      filteredRecipiesPref = _searchResultsSpooncular!.results!
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _isSearching = true;
      notifyListeners();
    } else {
      _isSearching = false;
      notifyListeners();
    }
  }

  updateSearchAdminRecipies(String query) {
    if (query.isNotEmpty) {
      filteredAdminRecipes = adminRecipes
          .where((element) =>
              element.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // filteredRecipiesPref = _searchResultsSpooncular!.results!
      //     .where((element) =>
      //         element.title!.toLowerCase().contains(query.toLowerCase()))
      //     .toList();
      _isSearching = true;
      notifyListeners();
    } else {
      _isSearching = false;
      notifyListeners();
    }
  }

  _changeRandomRecipiesLoadingState(States states) {
    _randomRecipiesLoadState = states;
    notifyListeners();
  }

  _changeAdminRecipiesLoadingState(States states) {
    _AdminRecipiesLoadState = states;
    notifyListeners();
  }

  _changeRecipieDetailState(States states) {
    _getRecipeDetailsState = states;
    notifyListeners();
  }

  _changeRecipiesWithDietState(States states) {
    _recipiesWithDietState = states;
    notifyListeners();
  }
}

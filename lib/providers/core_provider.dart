import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/network_strings.dart';
import 'package:menu_minder/view/add_recipe/data/create_reciepe_model.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/grocery_list/model/grocery_list_model.dart';
import 'package:menu_minder/view/meal_plan/screens/data/friend_profile_model.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/my_polls/data/my_poll_response_model.dart';
import 'package:menu_minder/view/notifications/data/get_notification_model.dart';
import 'package:menu_minder/view/spooncular/data/spooncular_random_reciepies_model.dart';
import 'package:menu_minder/view/subscription/screens/subscription_screen.dart';
import 'package:provider/provider.dart';
import '../utils/enums.dart';
import '../repo/implementation/i_core.dart';
import '../utils/utils.dart';
import '../view/block_user/data/get_blocked_users_model.dart';
import '../view/family_suggestion/data/famliy_list_res.dart';
import '../view/home/data/all_pole_model.dart';
import '../view/poll_results/screens/data/poll_result_data.dart';
import '../view/recipe_details/data/get_reciepe_model.dart';

class CoreProvider extends ChangeNotifier {
  final ICoreModule _coreRepo;

  CoreProvider(this._coreRepo);

  RecipeModel? selectedRecipie;

  updateSelectedRecipe(
    RecipeModel? recipeModel, {
    bool notify = true,
  }) {
    selectedRecipie = recipeModel;
    if (notify) {
      notifyListeners();
    }
  }

  clearProvider() {
    _homeRecipes = null;
    _myPolls = null;
  }

  bool isSearching = false;

  List<String> selectedUserIds = [];
  List<String> removedUserIds = [];

  searchState(bool state) {
    isSearching = state;
    notifyListeners();
  }

  updateSelectedIds({
    required bool value,
    required String sid,
  }) {
    if (value == true) {
      selectedUserIds.add(sid);
    } else {
      selectedUserIds.remove(sid);
    }

    notifyListeners();
  }

  updateSharedList({
    required List<String> ids,
  }) {
    selectedUserIds = [];
    ids.forEach((e) {
      selectedUserIds.add(e);
    });
    notifyListeners();
  }

  updateDate(String query) {
    if (homeRecipies?.data != null) {
      if (query.isNotEmpty) {
        searchedRecipies = homeRecipies!.data!
            .where(
              (element) =>
                  element.title!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        print("Query ${query}Lemgth ${searchedRecipies.length}");
        notifyListeners();
      }
    }
  }

  ////------------------Init State of Provider---------------\\\
  initState() {
    _getAllBlockedUsersState = States.init;
    _loadContentState = States.init;
    _addReceipeSate = States.init;
    _getAllReciepesState = States.init;
    // _getMyRecipiesState = States.init;
    _getGroceryListState = States.init;
    _getMyPoleLoadState = States.init;
    _getHomeReciepiesState = States.init;
  }

  initSearch() {
    isSearching = false;
  }

  //------------BLCOKED USERS States ---------------//
  States _getAllBlockedUsersState = States.init;
  States get getAllBlockedUsersState => _getAllBlockedUsersState;

  States _getFamilyListStates = States.init;
  States get getFamilyListState => _getFamilyListStates;

  ///=======Load Content State========\\\\
  States _loadContentState = States.init;
  States get loadContentState => _loadContentState;

  ////-------------CHANGE NOTIFICATION STATUS--------------\\\\\\\
  _changeBlockedUsersStates(States state) {
    _getAllBlockedUsersState = state;
    notifyListeners();
  }

  _changeLoadContentState(States state) {
    _loadContentState = state;
    notifyListeners();
  }

  ///C-------Family----------\\\
  _changeFamilyListState(States state) {
    _getFamilyListStates = state;
    notifyListeners();
  }

  ////------------------Get Blocked Users List---------------\\\

  GetBlockedUsers? _blockedUsers;
  GetBlockedUsers? get blockedUsers => _blockedUsers;

  getBlockedUsersList() async {
    try {
      _changeBlockedUsersStates(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getBlockedUsers();

      try {
        _blockedUsers = GetBlockedUsers.fromJson(response?.data);

        // print(_getPropertiesData!.toJson());
        _changeBlockedUsersStates(States.success);
      } catch (e) {
        _changeBlockedUsersStates(States.failure);
        initState();
        // Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (_) {
      _changeBlockedUsersStates(States.failure);
      initState();
    }
  }

  ////------------------UnBlock User---------------\\\

  unBlockUser(BlockedUserData userData, BuildContext context,
      {Function()? onSuccess}) async {
    try {
      setProgressBar(context);
      Response? response =
          await _coreRepo.unBlockUser(userData.receiverId!.sId!);

      try {
        Utils.showToast(message: response?.data['message'] ?? '');
        onSuccess?.call();
      } catch (e) {
        cancelProgressBar(context);
        // Utils.showToast(message: response!.statusMessage);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  ////------------------Remove Blocked User From List---------------\\\

  removeBlockedUser(BuildContext context, BlockedUserData userData) {
    blockedUsers?.data?.remove(userData);
    notifyListeners();
  }

  ////------------------BLock Users---------------\\\

  blockUser(String id, BuildContext context, {Function()? onSuccess}) async {
    try {
      setProgressBar(context);
      Response? response = await _coreRepo.unBlockUser(id);
      try {
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);

        if (_familySuggesstionsRes?.data != null) {
          _familySuggesstionsRes?.data?.removeWhere(
              (element) => element.reciepieData?.userData?.Id == id);
        }

        if (_getAllMealPlansResponse?.data != null) {
          _getAllMealPlansResponse?.data?.removeWhere(
              (element) => element.reciepieData?.userData?.Id == id);
        }

        if (_homeRecipes?.data != null) {
          _homeRecipes?.data
              ?.removeWhere((element) => element.userData?.Id == id);
        }

        if (_getAllPoles?.data != null) {
          _getAllPoles?.data
              ?.removeWhere((element) => element.userID?.Id == id);
        }

        notifyListeners();

        onSuccess?.call();
      } catch (e) {
        cancelProgressBar(context);
        // Utils.showToast(message: response!.statusMessage);
        // AppMessage.showMessage(response?.data['message'] ?? '');
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  ////------------------Terms and Conditions and Privacy Policy---------------\\\

  String _contentUrl = '';

  String get contentUrl => _contentUrl;

  getContentScreenData(bool isPrivacy, BuildContext context) async {
    try {
      _changeLoadContentState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo
          .loadContent(isPrivacy ? 'privacy_policy' : 'terms_and_conditions');

      try {
        // _blockedUsers = GetBlockedUsers.fromJson(response?.data);
        _contentUrl = response?.data['url'];
        log(contentUrl);
        _changeLoadContentState(States.success);
        // initState();
      } catch (e) {
        print(e.toString());
        _changeLoadContentState(States.failure);
        initState();
      }
    } on DioException catch (_) {
      _changeLoadContentState(States.failure);
      initState();
    }
  }

  ///STATES

  ///=======Load Content State========\\\\
  States _getAllReciepesState = States.init;
  States get getAllReceipeState => _getAllReciepesState;

  _changeSetAllReciepeState(States state) {
    _getAllReciepesState = state;
    notifyListeners();
  }

  ///=======Load Content State========\\\\
  States _getFamilySuggestionsState = States.init;
  States get getFamilySuggestionsState => _getFamilySuggestionsState;

  _changeGetFamilySuggestionState(States state) {
    _getFamilySuggestionsState = state;
    notifyListeners();
  }

  ////------------------My MealPlans---------------\\\

  GetAllMealPlans? _getAllMealPlansResponse;

  GetAllMealPlans? get getAllMealPlans => _getAllMealPlansResponse;

  getFamilySuggestions(
    BuildContext context,
    String type, {
    required String currentDate,
  }) async {
    try {
      _changeGetFamilySuggestionState(States.loading); //--- (STEP 5) ---//
      Response? response =
          await _coreRepo.getFamilySuggestions(type, currentDate);

      try {
        print("Data Loaded Successfully");
        _familySuggesstionsRes = GetAllMealPlans.fromJson(response?.data);
        // print("MEAL PLANS Suggestions ${_familySuggesstionsRes!.data!.length}");
        _changeGetFamilySuggestionState(States.success);

        // initState();
      } catch (e) {
        // Utils.showToast(message: response!.statusMessage);
        initState();
      }
    } on DioException catch (_) {
      _changeGetFamilySuggestionState(States.failure);
      initState();
    }
  }

  ////------------------Get Family Members Suggesstions---------------\\\

  GetAllMealPlans? _familySuggesstionsRes;
  GetAllMealPlans? get familySuggesstionsRes => _familySuggesstionsRes;

  getAllMealPalnsByType(BuildContext context, String type, String? date) async {
    try {
      _changeSetAllReciepeState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getAllMealPlans(type, date ?? '');

      try {
        print("Data Loaded Successfully");
        _getAllMealPlansResponse = GetAllMealPlans.fromJson(response?.data);
        print("MEAL PLANS  ${_getAllMealPlansResponse!.data!.length}");
        _changeSetAllReciepeState(States.success);
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        initState();
      }
    } on DioException catch (_) {
      _changeSetAllReciepeState(States.failure);
      initState();
    }
  }

  ////------------------My Recipies---------------\\\

  GetReciepiesList? _myRecipiesResponse;
  GetReciepiesList? get getMyRecipies => _myRecipiesResponse;

  States _getMyRecipiesState = States.init;
  States get getMyReciepiesState => _getMyRecipiesState;

  RecipeModel? _selectedPollRecipie;
  RecipeModel? get selectedPollRecipie => _selectedPollRecipie;

  changeSelectedPollRecipie(RecipeModel recipeModel, {bool isNotify = true}) {
    _selectedPollRecipie = recipeModel;
    if (isNotify) {
      notifyListeners();
    }
  }

  _changeMyReciepiesState(States state) {
    _getMyRecipiesState = state;
    notifyListeners();
  }

  getReciepiesByUserID(BuildContext context, String? userID,
      {Function()? onSuccess}) async {
    try {
      log("USER ID OF USER $userID");
      _changeMyReciepiesState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getReciepiesByUserID(
        userID ?? '',
      );

      try {
        _myRecipiesResponse = GetReciepiesList.fromJson(response?.data);

        _changeMyReciepiesState(States.success);
        onSuccess?.call();
      } catch (e) {
        // Utils.showToast(message: response!.statusMessage);
        initState();
        log("Excpeiton Chang$e"); // }
      }
    } on DioException catch (_) {
      _changeMyReciepiesState(States.failure);
      initState();
    }
  }

  setMyRecipes(GetReciepiesList? myRecipiesResponse, {bool notify = true}) {
    _myRecipiesResponse = myRecipiesResponse;
    if (notify) {
      notifyListeners();
    }
  }

  ////------------------HOME Recipies---------------\\\
  GetReciepiesList? _homeRecipes;
  GetReciepiesList? get homeRecipies => _homeRecipes;

  List<RecipeModel> searchedRecipies = [];

  States _getHomeReciepiesState = States.init;
  States get getHomeReciepeSate => _getHomeReciepiesState;

  States _homePollState = States.init;
  States get getHomePoleLoadState => _homePollState;

  _changeHomeReciepeSate(States state) {
    _getHomeReciepiesState = state;
    notifyListeners();
  }

  _changeHomePoleLoadState(States state) {
    _homePollState = state;
    notifyListeners();
  }

  int subscribed = 1;

  getHomeRecipies(BuildContext context, String type,
      {bool isRefresh = false, Function()? onPollLoaded}) async {
    try {
      _changeHomeReciepeSate(States.loading); //--- (STEP 5) ---//

      Response? response = await _coreRepo.homeRecipies();

      try {
        // if (response?.data['subscribed']) {
        //   AppNavigator.pushAndRemoveUntil(
        //       context, SubscriptionScreen(isTrial: false));

        //   return;
        // }
        _homeRecipes = GetReciepiesList.fromJson(response?.data);
        _changeHomeReciepeSate(States.success);

        if (response?.data['subscribe'] == 0) {
          subscribed = response?.data['subscribe'];
          AppNavigator.pushAndRemoveUntil(
              context,
              SubscriptionScreen(
                isTrial: false,
                showLogout: true,
              ));
        } else {
          subscribed = 1;
          getFamilyPoles(context, type, onPollLoaded: onPollLoaded);
        }
        // getFamilyPoles(context, type);

        // controller?.refreshCompleted();

        // initState();
      } catch (e) {
        // Utils.showToast(message: response!.statusMessage);
        // AppMessage.showMessage(response?.data['message'] ?? '');
        initState();
      }
    } on DioException catch (_) {
      _changeHomeReciepeSate(States.failure);
      initState();
    }
  }

  // getAllRandomReceipes(BuildContext context) async {
  //   try {
  //     _changeRandomRecipiesLoadingState(States.loading); //--- (STEP 5) ---//
  //     // Response? response = await _coreRepo.getSpoonCularRecipies();

  //     // try {
  //     // _getRandomRecipies = SpooncularRecipies.fromJson(response?.data);
  //     _changeRandomRecipiesLoadingState(States.success);
  //     // } catch (e) {
  //     // AppMessage.showMessage(NetworkStrings.SOMETHING_WENT_WRONG);
  //     // Utils.showToast(message: response!.statusMessage);
  //     // AppMessage.showMessage(response?.data['message'] ?? '');
  //     // initState();
  //     // }
  //   } on DioException catch (_) {
  //     _changeRandomRecipiesLoadingState(States.failure);
  //     initState();
  //   }
  // }

  _changeRandomRecipiesLoadingState(States states) {}

  AllPoles? _getAllPoles;
  AllPoles? get allPoles => _getAllPoles;

  getFamilyPoles(BuildContext context, String type,
      {Function()? onPollLoaded}) async {
    try {
      _changeHomePoleLoadState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getFamilyPolls();

      try {
        _getAllPoles = AllPoles.fromJson(response?.data);
        _changeHomePoleLoadState(States.success);
        onPollLoaded?.call();
      } catch (e) {
        initState();
      }
    } on DioException catch (_) {
      _changeHomePoleLoadState(States.failure);
      initState();
    }
  }

  ///=======Load Content State========\\\\
  States _addReceipeSate = States.init;
  States get addReceipeSate => _addReceipeSate;

  _changeaddReceipeSate(States state) {
    _addReceipeSate = state;
    notifyListeners();
  }

  addNewReciepe(
    BuildContext context,
    Function()? onSuccess,
    CreateReceipeModel createReceipeModel,
    List<Map<String, dynamic>> ingredeits, {
    bool isEdit = false,
    String? editRecipeID,
    List<String> networksImages = const [],
    bool isMealPlan = false,
    required String date,
    required String type,
  }) async {
    try {
      _changeaddReceipeSate(States.loading); //--- (STEP 5) ---//
      var map = createReceipeModel.toMap();

      final List<MultipartFile> images = [];
      if (createReceipeModel.images.isNotEmpty) {
        for (String imagePath in createReceipeModel.images) {
          MultipartFile file = await MultipartFile.fromFile(
            imagePath,
            // filename: 'recipe_image.png',
          );
          images.add(file);
        }
      }

      map['recipe_images'] = images;
      map['ingredients'] = jsonEncode(ingredeits);
      map['previous_paths'] = jsonEncode(networksImages);

      final formData = FormData.fromMap(map);

      Response? response;

      response = await _coreRepo.addNewReceipe(formData);

      if (!isEdit && isMealPlan) {
        final mealPlan = response?.data['data'];

        if (mealPlan['_id'] != null) {
          final data = {
            'date': date,
            'type': type,
            'recipe_id': mealPlan['_id'],
          };
          final meal = await _coreRepo.addMealPlan(data);
        }
      }

      log("Adding New Reciepe With ID ");

      try {
        if (isEdit) {
          final data = RecipeModel.fromJson(response?.data);

          getReciepiesByUserID(context, data.userData!.Id!);
          AppNavigator.pushAndRemoveUntil(context, const BottomBar());

          log("Reciepe Added Successfully");
        }
        _changeaddReceipeSate(States.success);

        onSuccess?.call();

        // initState();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        _changeaddReceipeSate(States.failure);
        initState();
      }
    } on DioException catch (_) {
      _changeaddReceipeSate(States.failure);
      initState();
    }
  }

  addRecipieToProfile(
    BuildContext context,
    Function()? onSuccess,
    CreateReceipeModel createReceipeModel,
    List<Map<String, dynamic>> ingredeits, {
    bool showLoader = false,
    String? date,
    Function()? onFailure,
    required String type,
  }) async {
    try {
      _changeaddReceipeSate(States.loading); //--- (STEP 5) ---//
      if (showLoader) {
        AppDialog.showPorgressBar(context);
      }
      var map = createReceipeModel.toMap();

      map['ingredients'] = jsonEncode(ingredeits);

      final formData = FormData.fromMap(map);

      Response? response;

      response = await _coreRepo.addNewReceipe(formData);

      log("Adding New Reciepe With ID ");

      try {
        _changeaddReceipeSate(States.success);

        onSuccess?.call();

        Utils.showToast(message: 'Recipe added to profile successfully');

        _changeMyReciepiesState(States.loading); //--- (STEP 5) --
        // ignore: use_build_context_synchronously
        getReciepiesByUserID(
            context, context.read<AuthProvider>().userdata!.data!.Id!);

        // initState();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        _changeaddReceipeSate(States.failure);
        initState();
        if (showLoader) {
          AppNavigator.pop(context);
          onFailure?.call();
        }
      }
    } on DioException catch (_) {
      _changeaddReceipeSate(States.failure);
      initState();
      if (showLoader) {
        AppNavigator.pop(context);
        onFailure?.call();
      }
    }
  }

  editReciepe(
    BuildContext context,
    CreateReceipeModel createReceipeModel,
    List<Map<String, dynamic>> ingredeits, {
    Function()? onSuccess,
    String? editRecipeID,
    List<String> networksImages = const [],
  }) async {
    try {
      _changeaddReceipeSate(States.loading); //--- (STEP 5) ---//
      var map = createReceipeModel.toMap();

      final List<MultipartFile> images = [];
      if (createReceipeModel.images.isNotEmpty) {
        for (String imagePath in createReceipeModel.images) {
          MultipartFile file = await MultipartFile.fromFile(
            imagePath,
            // filename: 'recipe_image.png',
          );
          images.add(file);
        }

        map['recipe_images'] = images;
      } else {}

      map['ingredients'] = jsonEncode(ingredeits);
      map['previous_paths'] = jsonEncode(networksImages);

      // if (isEdit) {
      log("Key Remove Hogaee${map['recipe_id']}");

      map['recipe_id'] = editRecipeID;
      map.removeWhere((key, value) => key == 'type');
      // }

      final formData = FormData.fromMap(map);

      Response? response;

      response = await _coreRepo.editReciepe(formData);
      log("Updating The Reciepe With ID $editRecipeID");

      try {
        final data = RecipeModel.fromJson(response?.data);
        // getReciepiesByUserID(context, data.userData!.Id!);
        Utils.showToast(message: response?.data['message'] ?? '');

        // _getAllReceipesResponse = GetAllReciepeModel.fromJson(response?.data);
        _changeaddReceipeSate(States.success);

        onSuccess?.call();
        // initState();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        _changeaddReceipeSate(States.failure);
        initState();
      }
    } on DioException catch (_) {
      _changeaddReceipeSate(States.failure);
      initState();
    }
  }

  //////-----------------------DELETE RECIEPE---------------------\\\\\\\\\
  ///=======Load Content State========\\\\
  deleteReiciepe(BuildContext context, RecipeModel mealData,
      {Function()? onSuccess}) async {
    try {
      setProgressBar(context);
      Response? response = await _coreRepo.deleteReceipe(mealData.reciepieId!);

      try {
        _myRecipiesResponse?.data?.remove(mealData);
        _homeRecipes?.data?.remove(mealData);
        context.read<CoreProvider>().searchedRecipies.remove(mealData);
        Utils.showToast(message: response?.data['message'] ?? '');
        onSuccess?.call();

        notifyListeners();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
    }
  }

  ///POST a Suggestions
  postSuggesstion({
    Function()? onSuccess,
    required BuildContext context,
    required String mealPlanID,
    required String text,
    required MealPlanModel mealPlanModel,
  }) async {
    try {
      setProgressBar(context);
      final Map<String, dynamic> data = {
        'meal_plan_id': mealPlanID,
        'text': text
      };
      Response? response = await _coreRepo.postSuggesstion(data);

      try {
        // blockedUsers?.data?.remove(userData);
        Utils.showToast(message: response?.data['message'] ?? '');

        cancelProgressBar(context);

        onSuccess?.call();
      } catch (e) {
        cancelProgressBar(context);
        AppNavigator.pop(context);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  askSuggesstion({
    Function()? onSuccess,
    required BuildContext context,
    required String postUserID,
    required String mealPlanID,
  }) async {
    try {
      setProgressBar(context);
      final Map<String, dynamic> data = {
        'meal_plan_id': mealPlanID,
        'user_id': postUserID
      };
      Response? response = await _coreRepo.askForSuggesstion(data);

      try {
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);
        onSuccess?.call();
      } catch (e) {
        cancelProgressBar(context);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
    }
  }

  addMealPlanReciepie(
    BuildContext context,
    CreateReceipeModel createReceipeModel,
    List<Map<String, dynamic>> ingredeits, {
    bool isEdit = false,
    String? editRecipeID,
  }) async {
    try {
      _changeaddReceipeSate(States.loading); //--- (STEP 5) ---//
      var map = createReceipeModel.toMap();

      final List<MultipartFile> images = [];
      if (createReceipeModel.images.isNotEmpty) {
        for (String imagePath in createReceipeModel.images) {
          MultipartFile file = await MultipartFile.fromFile(
            imagePath,
            // filename: 'recipe_image.png',
          );
          images.add(file);
        }
      }

      map['recipe_images'] = images;
      map['ingredients'] = jsonEncode(ingredeits);

      final formData = FormData.fromMap(map);

      Response? response;

      response = await _coreRepo.addNewReceipe(formData);

      try {
        _changeaddReceipeSate(States.success);
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        initState();
      }
    } on DioException catch (_) {
      _changeaddReceipeSate(States.failure);
      initState();
    }
  }

  deleteMealPlan(BuildContext context, MealPlanModel mealPlanModel,
      {Function()? onSuccess}) async {
    try {
      setProgressBar(context);
      Response? response =
          await _coreRepo.deleteMealPlan(mealPlanModel.mealPlanID ?? '');

      try {
        _getAllMealPlansResponse?.data?.remove(mealPlanModel);
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
    }
  }

  postMealPlan({
    Function()? onSuccess,
    required BuildContext context,
    required String type,
    required String date,
    required String reciepieID,
  }) async {
    try {
      setProgressBar(context);
      final Map<String, dynamic> data = {
        'recipe_id': reciepieID,
        'type': type,
        'date': date
      };
      log({'recipe_id': reciepieID, 'type': type, 'date': date}.toString());
      Response? response = await _coreRepo.addMealPlan(data);

      try {
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);
        onSuccess?.call();
      } catch (e) {
        cancelProgressBar(context);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  FriendData? _userModelData;
  FriendData? get friendProfile => _userModelData;

  //////-----------------------Load Frined Profile---------------------\\\\\\\\\
  loadFriendsProfile(BuildContext context, String userID,
      {Function()? onSuccess}) async {
    try {
      setProgressBar(context);
      Response? response = await _coreRepo.getFriendProfile(userID);

      try {
        _userModelData = FriendData.fromJson(response?.data['data'][0]);
        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        Utils.showToast(
            message:
                response?.statusMessage ?? NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar(context);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
    }
  }

  GetReciepiesList? freindsReciepies;
  loadFriendRecipies(BuildContext context, String userID,
      {Function()? onSuccess}) async {
    try {
      freindsReciepies = null;
      notifyListeners();
      setProgressBar(context);
      Response? response = await _coreRepo.getReciepiesByUserID(userID);

      try {
        freindsReciepies = GetReciepiesList.fromJson(response?.data);
        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        cancelProgressBar(context);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
    }
  }

  GetReciepiesList? mutualRecipes;
  loadMutualRecipes(BuildContext context, String userID, String pollID,
      {Function()? onSuccess}) async {
    try {
      mutualRecipes = null;
      notifyListeners();
      setProgressBar(context);
      Response? response = await _coreRepo.getMutualRecipes(userID, pollID);
      cancelProgressBar(context);
      /// YEH

      try {
        mutualRecipes = GetReciepiesList.fromJson(response?.data);

        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        print(e.toString());
        // cancelProgressBar(context);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
    }
  }

  GetReciepiesList? myAllReciepies;
  loadMyRecipies(BuildContext context, String userID,
      {Function()? onSuccess}) async {
    try {
      // freindsReciepies = null;
      // notifyListeners();
      setProgressBar(context);
      Response? response = await _coreRepo.getReciepiesByUserID(userID);

      try {
        myAllReciepies = GetReciepiesList.fromJson(response?.data);
        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        cancelProgressBar(context);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
    }
  }

  ///Accept or Reject Friend Reuqest
  acceptOrRejectRequest(
      NotificationModel notificationModel, BuildContext context,
      {Function()? onSuccess, required String status}) async {
    try {
      setProgressBar(context);
      Response? response = await _coreRepo.acceptRejectRequest(
          status, notificationModel.senderId!.sId!, notificationModel.sId!);

      try {
        Utils.showToast(message: response?.data['message'] ?? '');
        // notifyListeners();
        onSuccess?.call();
        cancelProgressBar(context);
      } catch (e) {
        cancelProgressBar(context);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  ///--------------Get Family --------------\\\\
  FamilyList? _familyList;
  FamilyList? get familyList => _familyList;

  getFamliyMembers({Function()? onSucecess}) async {
    try {
      _changeFamilyListState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getFamilyMembersList();

      try {
        _familyList = FamilyList.fromJson(response?.data);

        // print(_getPropertiesData!.toJson());

        _changeFamilyListState(States.success);
        onSucecess?.call();
        // onSuccess?.call();
      } catch (e) {
        _changeFamilyListState(States.failure);
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        initState();
      }
    } on DioException catch (_) {
      _changeFamilyListState(States.failure);
      initState();
    }
  }

  ///------------------GROCERY------------------\\\

  GroceryListModel? _groceryListRes;
  GroceryListModel? get getGroceryyList => _groceryListRes;

  getGroceryList() async {
    try {
      _changeGroceryListState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getGroceryList();
      try {
        _groceryListRes = GroceryListModel.fromJson(response?.data);
        _changeGroceryListState(States.success);
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        _changeGroceryListState(States.failure);
        initState();
      }
    } on DioException catch (_) {
      _changeFamilyListState(States.failure);
      initState();
    }
  }

  // GroceryListModel? _groceryListRes;
  // GroceryListModel? get getGroceryyList => _groceryListRes;

  createORUpdateGrocery(
      Map<String, dynamic> data, Function()? onSuccess) async {
    try {
      _changeCreateGroceryState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.createOrUpdateGrocery(data);
      try {
        // _groceryListRes?.data
        //     ?.add(GroceryData.fromJson(response?.data['data']));

        // _groceryListRes = GroceryListModel.fromJson(response?.data);
        getGroceryList();
        _changeCreateGroceryState(States.success);
        onSuccess?.call();
      } catch (e) {
        print('Failuree' + e.toString());
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        _changeCreateGroceryState(States.failure);
        initState();
      }
    } on DioException catch (_) {
      _changeCreateGroceryState(States.failure);
      initState();
    }
  }

  ///CHECK UN CHECK GROCERY ITEM
  checkUnCheckGroceryItem(BuildContext context,
      {Function()? onSuccess,
      required int isCheck,
      required int index,
      GroceryData? groceryData,
      required GroceryItem groceryID}) async {
    try {
      setProgressBar(context);
      final data = {
        'is_check': isCheck.toString(),
        'grocery_id': groceryID.sId,
      };
      Response? response = await _coreRepo.checkUnCheckGroceryItem(data);

      try {
        groceryID.isCheck = isCheck;
        groceryData!.groceryList
            ?.sort((a, b) => a.isCheck!.compareTo(b.isCheck!));
        cancelProgressBar(context);

        notifyListeners();
      } catch (e) {
        cancelProgressBar(context);
        // Utils.showToast(message: response!.statusMessage);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  updateGroceryItem(BuildContext context,
      {Function()? onSuccess, required GroceryItem groceryID}) async {
    try {
      setProgressBar(context);
      final data = {
        'product_id': groceryID.sId,
        'product_name': groceryID.productName,
        'product_discription': groceryID.productDiscription,
        'product_quantity': groceryID.productQuantity,
      };
      Response? response = await _coreRepo.updateGroceryProduct(data);

      try {
        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        cancelProgressBar(context);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  deleteGrocery(BuildContext context,
      {Function()? onSuccess, required GroceryData groceryID}) async {
    try {
      setProgressBar(context);
      Response? response = await _coreRepo.deleleGroceryList(groceryID.sId!);

      try {
        Utils.showToast(message: response?.data['message'] ?? '');
        _groceryListRes?.data?.remove(groceryID);
        // cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        cancelProgressBar(context);
        // Utils.showToast(message: response!.statusMessage);
      }
    } on DioException catch (_) {
      cancelProgressBar(context);
      // AppMessage.showMessage(e.message ?? '');
    }
  }

  //------------MyPoll States ---------------//
  States _getMyPoleLoadState = States.init;
  States get getMyPoleLoadState => _getMyPoleLoadState;

  MyPollsRes? _myPolls;
  MyPollsRes? get getMyPolles => _myPolls;

  ///POLLS
  getMyPoles(BuildContext context) async {
    try {
      _changeMyPoleLoadState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getMyPoles();

      try {
        _myPolls = MyPollsRes.fromJson(response?.data, myPoll: true);
        _changeMyPoleLoadState(States.success);
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        // Utils.showToast(message: response!.statusMessage);
        // AppMessage.showMessage(response?.data['message'] ?? '');
        initState();
      }
    } on DioException catch (_) {
      _changeMyPoleLoadState(States.failure);
      initState();
    }
  }

  //------------View Voters  ---------------//
  States _pollResultState = States.init;
  States get getPollResultState => _pollResultState;

  SinglePollResult? _singlePollResult;
  SinglePollResult? get singlePoleResult => _singlePollResult;

  ///POLLS
  getPoleResults(BuildContext context, String pollID) async {
    try {
      _changeViewVotersState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.viewVoters(pollID);

      try {
        _singlePollResult = SinglePollResult.fromJson(response?.data);
        _changeViewVotersState(States.success);
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        // Utils.showToast(message: response!.statusMessage);
        // AppMessage.showMessage(response?.data['message'] ?? '');
        // initState();
      }
    } on DioException catch (_) {
      _changeViewVotersState(States.failure);
      initState();
    }
  }

  States _createPollLoadingState = States.init;
  States get createPollState => _createPollLoadingState;

  createPoll(Map<String, dynamic> data, Function()? onSuccess,
      BuildContext context) async {
    try {
      _changeCreatePollState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.createPoll(data);
      try {
        // _groceryListRes?.data
        //     ?.add(GroceryData.fromJson(response?.data['data']));

        // _groceryListRes = GroceryListModel.fromJson(response?.data);
        getMyPoles(context);
        _changeCreatePollState(States.success);
        onSuccess?.call();
      } catch (e) {
        print('Failuree$e');
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        _changeCreatePollState(States.failure);
        initState();
      }
    } on DioException catch (_) {
      _changeCreatePollState(States.failure);
      initState();
    }
  }

  editPole(Map<String, dynamic> data, Function()? onSuccess,
      BuildContext context) async {
    try {
      _changeCreatePollState(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.editPoll(data);
      try {
        getMyPoles(context);
        _changeCreatePollState(States.success);
        onSuccess?.call();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        _changeCreatePollState(States.failure);
        initState();
      }
    } on DioException catch (_) {
      _changeCreatePollState(States.failure);
      initState();
    }
  }

  deletePoll(BuildContext context, PollData mealData,
      {Function()? onSuccess}) async {
    try {
      setProgressBar(context);
      Response? response = await _coreRepo.deletePoll(mealData.sId!);

      try {
        _myPolls?.data?.remove(mealData);
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
    }
  }

  acceptRejectSuggestion(BuildContext context, Voters voters,
      {Function()? onSuccess,
      String? suggestionStatus,
      String? another_suggestion}) async {
    try {
      setProgressBar(context);

      print(suggestionStatus);
      final data = {
        'vote_id': voters.sId,
        'suggestion_status': suggestionStatus,
      };

      if (another_suggestion != null) {
        data['another_suggestion'] = another_suggestion;
      }
      Response? response = await _coreRepo.acceptORRejectSuggestion(data);

      try {
        // _myPolls?.data?.remove(mealData);
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);
        onSuccess?.call();
        voters.suggestionStatus = suggestionStatus;
        voters.anotherSuggestion = another_suggestion;
        notifyListeners();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
    }
  }

  shareRecipe(BuildContext context,
      {Function()? onSuccess, required RecipeModel recipeModel}) async {
    try {
      final data = {
        'recipe_id': recipeModel.reciepieId,
        'share': selectedUserIds,
      };
      setProgressBar(context);
      Response? response = await _coreRepo.shareRecipe(data);
      try {
        // final shareRespnse = ShareReponse.fromJson(response?.data);
        recipeModel.sharedMembers = List.from(selectedUserIds);
        print(recipeModel.sharedMembers.toString());
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
    }
  }

  subscription(
    BuildContext context, {
    Function()? onSuccess,
    required String reciept,
    required String userDeviceType,
    required String packageName,
    required String productID,
    required String purchaseToken,
  }) async {
    try {
      final data = {
        'reciept': reciept,
        'user_device_type': userDeviceType,
      };
      setProgressBar(context);
      Response? response = await _coreRepo.subcriptionApi(data);
      try {
        Utils.showToast(message: response?.data['message'] ?? '');
        cancelProgressBar(context);
        AppNavigator.pushAndRemoveUntil(context, BottomBar());
        notifyListeners();
      } catch (e) {
        Utils.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
    }
  }

  giveVote(
    BuildContext context, {
    Function()? onSuccess,
    required String buttonID,
    required String pollID,
    required Button buttonData,
    Recipes? recipeObject,
    String? receipieName,
    // required String suggestionID,
  }) async {
    try {
      final data = {
        "pole_id": pollID,
        "button_id": buttonID,
        "suggestion": receipieName,
        "final_recipe": recipeObject?.toJson(),
      };
      log("***** ${data}");
      setProgressBar(context);

      Response? response = await _coreRepo.giveVote(data);

      try {
        // _myPolls?.data?.remove(mealData);
        // buttonData.myVote = 1;
        // AppMessage.showMessage(response?.data['message'] ?? '');
        getFamilyPoles(
          context,
          '',
        );

        cancelProgressBar(context);
        onSuccess?.call();
        notifyListeners();
      } catch (e) {
        // Utils.showToast(message: response!.statusMessage);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      cancelProgressBar(context);
    }
  }

  _changeCreatePollState(States state) {
    _createPollLoadingState = state;
    notifyListeners();
  }

  _changeViewVotersState(States state) {
    _pollResultState = state;
    notifyListeners();
  }

  _changeMyPoleLoadState(States state) {
    _getMyPoleLoadState = state;
    notifyListeners();
  }

  //------------Grocery States ---------------//
  States _getGroceryListState = States.init;
  States get getGroceryListState => _getGroceryListState;

  States _createGroceryState = States.init;
  States get createGroceryState => _createGroceryState;

  _changeGroceryListState(States states) {
    _getGroceryListState = states;
    notifyListeners();
  }

  _changeCreateGroceryState(States states) {
    _createGroceryState = states;
    notifyListeners();
  }

  void setProgressBar(BuildContext context) {
    AppDialog.showPorgressBar(context);
  }

  void cancelProgressBar(BuildContext context) {
    AppNavigator.pop(context);
  }
}

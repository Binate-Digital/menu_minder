import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/utils/app_navigator.dart';
import 'package:menu_minder/repo/implementation/i_core.dart';

import '../services/network/dio_client.dart';
import '../services/network/firebase_messaging_service.dart';

class CoreRepo implements ICoreModule {
//---------------------- Notifcations ----------------/
  ////Load Notifications
  @override
  Future<Response?> loaddAllNotifcations(Map data) async {
    return await DioClient().getRequest(
      isHeaderRequire: true,
      context: StaticData.navigatorKey.currentContext,
      queryParameters: {},
      endPoint: dotenv.get('GETALL_NOTIFICATIONS'),
    );
  }

  ////DELETE NOTIFICATION by its ID
  @override
  Future<Response?> deleteNotificaion(String id) async {
    return await DioClient().getRequest(
      isHeaderRequire: true,
      context: StaticData.navigatorKey.currentContext,
      queryParameters: {},
      endPoint: dotenv.get('DELETE_NOTIFICATION') + id,
    );
  }

  ////TERMS AND CONDITIONS URL GET
  @override
  Future<Response?> loadContent(String data) async {
    return await DioClient().getRequest(
      isHeaderRequire: true,
      context: StaticData.navigatorKey.currentContext,
      queryParameters: {},
      endPoint: dotenv.get('CONTENT_ROUTE') + data,
    );
  }

  ///GET ALL BLOCKED USERS
  @override
  Future<Response?> getBlockedUsers() async => await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('BLOCKED_USERS'),
      );

  ///BLOCK OR UNBLOCK USER
  @override
  Future<Response?> unBlockUser(String userID) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('BLOCK_UBLOCK_USER') + userID,
      );

  ///MEAL PLAN BY TYPE
  @override
  Future<Response?> getAllMealPlans(String type, String date) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {'type': type, 'date': date},
        endPoint: dotenv.get('GET_MEAL_PLAN_RECEIPES'),
      );

  @override
  Future<Response?> addNewReceipe(dynamic formData) async =>
      await DioClient().postFileRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: formData,
        endPoint: dotenv.get('CREATE_RECIEPE'),
      );

  @override
  Future<Response?> deleteReceipe(String rID) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        endPoint: '${dotenv.get('DELETE_RECIEPT')}$rID',
      );

  @override
  Future<Response?> editReciepe(FormData receipeModel) async =>
      await DioClient().postFileRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: receipeModel,
        endPoint: dotenv.get('EDIT_RECIEPT'),
      );

  @override
  Future<Response?> addMealPlan(Map<String, dynamic> data) async {
    return await DioClient().postRequest(
      isHeaderRequire: true,
      data: data,
      context: StaticData.navigatorKey.currentContext,
      endPoint: dotenv.get('ADD_MEAL_PLAN'),
    );
  }

  @override
  Future<Response?> getReciepiesByUserID(String type) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('GET_ALL_RECIEPIES_BY_USER_ID') + type,
      );

  @override
  Future<Response?> getMutualRecipes(String type, String pollID) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // queryParameters: {'poll_id': pollID},
        endPoint: '${dotenv.get('GET_MUTUAL_RECIPES')}$type/$pollID',
      );

  @override
  Future<Response?> getFamilySuggestions(
          String type, String currentDate) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {'type': type, 'date': currentDate},
        endPoint: dotenv.get('GET_MEAL_PLAN_SUGGESTIONS'),
      );

  @override
  Future<Response?> postSuggesstion(Map<String, dynamic> data) async =>
      await DioClient().postFileRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: data,
        queryParameters: {},
        endPoint: dotenv.get('GIVE_SUGGESTION_TO_MEA_PLAN'),
      );

  @override
  Future<Response?> acceptORRejectSuggestion(Map<String, dynamic> data) async =>
      await DioClient().postRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: data,
        queryParameters: {},
        endPoint: dotenv.get('ACCEPT_OR_REJECT_SUGGESTION'),
      );

  @override
  Future<Response?> askForSuggesstion(Map<String, dynamic> data) async =>
      await DioClient().postFileRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: data,
        queryParameters: {},
        endPoint: dotenv.get('ASK_FOR_SUGGESSTION'),
      );

  @override
  Future<Response?> shareRecipe(Map<String, dynamic> data) async =>
      await DioClient().postRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: data,
        queryParameters: {},
        endPoint: dotenv.get('SHARE_RECIPE'),
      );

  @override
  Future<Response?> deleteMealPlan(String id) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // data: data,
        queryParameters: {},
        endPoint: dotenv.get('DELETE_MEAL_PLAN') + id,
      );

  @override
  Future<Response?> getFriendProfile(String rID) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // data: data,
        queryParameters: {},
        endPoint: dotenv.get('GET_OTHER_USER_DETAIL') + rID,
      );

  @override
  Future<Response?> homeRecipies() async => await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // data: data,
        queryParameters: {},
        endPoint: dotenv.get('GET_FAMILY_MEAL_PLAN'),
      );

  @override
  Future<Response?> acceptRejectRequest(
          String status, String senderID, String notificationID) async =>
      await DioClient().postFileRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // data: data,
        data: {
          "status": status,
          "sender_id": senderID,
          "notification_id": notificationID
        },
        endPoint: dotenv.get('ACCEPT_REJECT_FOLLOW_REQUEST'),
      );

  @override
  Future<Response?> getFamilyMembersList() async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // data: data,
        queryParameters: {},
        endPoint: dotenv.get('GET_FAMILY_LIST'),
      );

  @override
  Future<Response?> deleleGroceryList(String id) async =>
      await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        // data: data,
        queryParameters: {},
        endPoint: '${dotenv.get('DELETE_GROCERY_LIST')}/$id',
      );

  @override
  Future<Response?> getGroceryList() async => await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('GET_GROCERY_LIST'),
      );

  @override
  Future<Response?> checkUnCheckGroceryItem(Map<String, dynamic> data) async =>
      await DioClient().postRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: data,
        isLoader: false,
        isToast: false,
        endPoint: dotenv.get('CHECK_UNCHECK_GROCERY'),
      );

  @override
  Future<Response?> createOrUpdateGrocery(Map<String, dynamic> data) async =>
      await DioClient().postRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: data,
        isLoader: false,
        isToast: false,
        endPoint: dotenv.get('CREATE_UPDATE_GROCERY'),
      );

  @override
  Future<Response?> getChatList() async => await DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        isLoader: false,
        isToast: false,
        endPoint: dotenv.get('GET_CHAT_LIST'),
      );

  @override
  Future<Response?> deleteChat(String chatId) async {
    return await DioClient().getRequest(
      isHeaderRequire: true,
      context: StaticData.navigatorKey.currentContext,
      queryParameters: {},
      endPoint: dotenv.get('DELETE_CHAT') + chatId,
    );
  }

  @override
  Future<Response?> updateGroceryProduct(Map<String, dynamic> data) async =>
      await DioClient().postRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        data: data,
        isLoader: false,
        isToast: false,
        endPoint: dotenv.get('UPDATE_GROCERY_PROCUT'),
      );

  @override
  Future<Response?> sendImage(dynamic formData) async =>
      await DioClient().postFileRequest(
        isHeaderRequire: false,
        context: StaticData.navigatorKey.currentContext,
        data: formData,
        endPoint: dotenv.get('SEND_IMAGE_API'),
      );

  ///POLLS

  @override
  Future<Response?> getMyPoles() async => DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('GET_MY_POLLS'),
      );

  @override
  Future<Response?> viewVoters(String pollID) async => DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: '${dotenv.get('VIEW_VOTERS')}/$pollID',
      );

  @override
  Future<Response?> createPoll(Map<String, dynamic> data) async =>
      DioClient().postRequest(
        isHeaderRequire: true,
        data: data,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('CREATE_POLL'),
      );

  @override
  Future<Response?> editPoll(Map<String, dynamic> data) async =>
      DioClient().postRequest(
        isHeaderRequire: true,
        data: data,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('EDIT_POLL'),
      );

  @override
  Future<Response?> deletePoll(String id) async => DioClient().getRequest(
        isHeaderRequire: true,
        // data: data,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: '${dotenv.get('DELETE_POLL')}/$id',
      );

  @override
  Future<Response?> giveVote(Map<String, dynamic> pollData) async =>
      DioClient().postRequest(
        isHeaderRequire: true,
        data: pollData,
        isToast: false,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('GIVE_VOTE'),
      );

  @override
  Future<Response?> getFamilyPolls() async => DioClient().getRequest(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('GET_FAMLIY_POLLS'),
      );

  ///SUBSCRIPTION
  @override
  Future<Response?> subcriptionApi(Map<String, dynamic> data) async =>
      DioClient().postRequest(
        isHeaderRequire: true,
        data: data,
        isToast: false,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('SUBSCRIPTION'),
      );

  @override
  Future<Response?> getSpoonCularRecipies() async =>
      DioClient().getSpoonCularApi(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {},
        endPoint: dotenv.get('SPOONCULAR_RANDOM_RECIEPIES'),
      );

  @override
  Future<Response?> spoonCularSearch(Map<String, dynamic> queryParamss) async =>
      DioClient().getSpoonCularApi(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: queryParamss,
        endPoint: dotenv.get('SPOONCULAR_SEARCH_RECIPES'),
      );

  @override
  Future<Response?> getRecipeDetailsSpooncular(String id) async =>
      DioClient().getSpoonCularApi(
        isHeaderRequire: true,
        context: StaticData.navigatorKey.currentContext,
        queryParameters: {'apiKey': dotenv.get('SPOONCULAR_API_KEY')},
        endPoint: '${dotenv.get('RECIPIE_DETAILS')}$id/information',
      );

  // @override
  // Future<Response?> getAdminRecipies() {
  //   // TODO: implement getAdminRecipies
  //   return DioClient().getRequest(
  //     isHeaderRequire: true,
  //     context: StaticData.navigatorKey.currentContext,
  //     endPoint: 'get-admin-recipe',
  //   );
  // }
}

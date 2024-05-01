import 'package:dio/dio.dart';

abstract class ICoreModule {
  Future<Response?> loaddAllNotifcations(Map data);
  Future<Response?> deleteNotificaion(String data);
  Future<Response?> loadContent(String endPoint);
  Future<Response?> getBlockedUsers();
  Future<Response?> unBlockUser(String userID);
  Future<Response?> getAllMealPlans(String type, String date);
  Future<Response?> getFamilySuggestions(String type, String currentDate);
  Future<Response?> getReciepiesByUserID(String type);
  Future<Response?> getMutualRecipes(String type, String pollID);
  Future<Response?> addNewReceipe(FormData receipeModel);
  Future<Response?> editReciepe(FormData receipeModel);
  Future<Response?> deleteReceipe(String rID);
  Future<Response?> addMealPlan(Map<String, dynamic> data);
  Future<Response?> sendImage(dynamic imageData);
  Future<Response?> shareRecipe(Map<String, dynamic> data);

  Future<Response?> postSuggesstion(Map<String, dynamic> data);
  Future<Response?> deleteMealPlan(String id);
  Future<Response?> askForSuggesstion(Map<String, dynamic> data);

  Future<Response?> getFriendProfile(String rID);

  Future<Response?> homeRecipies();
  Future<Response?> getFamilyMembersList();

  Future<Response?> acceptRejectRequest(
      String status, String senderId, String notificaionID);

  Future<Response?> getGroceryList();
  Future<Response?> deleleGroceryList(String id);
  Future<Response?> checkUnCheckGroceryItem(Map<String, dynamic> data);
  Future<Response?> createOrUpdateGrocery(Map<String, dynamic> data);
  Future<Response?> updateGroceryProduct(Map<String, dynamic> data);

  ///CHAT
  Future<Response?> getChatList();
  Future<Response?> deleteChat(String chatId);

  ///SUbscription
  Future<Response?> subcriptionApi(Map<String, dynamic> data);

  ///POLLS
  Future<Response?> getMyPoles();
  Future<Response?> viewVoters(String pollID);
  Future<Response?> createPoll(Map<String, dynamic> pollID);
  Future<Response?> deletePoll(String pollID);
  Future<Response?> editPoll(Map<String, dynamic> pollData);
  Future<Response?> giveVote(Map<String, dynamic> pollData);

  Future<Response?> acceptORRejectSuggestion(Map<String, dynamic> data);

  Future<Response?> getFamilyPolls();
  Future<Response?> getSpoonCularRecipies();
  Future<Response?> getRecipeDetailsSpooncular(String id);
  Future<Response?> spoonCularSearch(Map<String, dynamic> queryParams);
}

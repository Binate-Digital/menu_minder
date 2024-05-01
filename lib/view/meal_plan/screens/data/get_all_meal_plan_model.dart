import '../../../auth/bloc/models/user_model.dart';

class GetAllMealPlans {
  int? status;
  String? message;
  List<MealPlanModel>? data;

  GetAllMealPlans({this.status, this.message, this.data});

  GetAllMealPlans.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MealPlanModel>[];
      json['data'].forEach((v) {
        data!.add(MealPlanModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealPlanModel {
  String? mealPlanID;
  RecipeModel? reciepieData;
  String? date;
  String? type;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? myMealPlan;
  UserModelData? mealPlanCreatorModel;
  List<FamilyMemberModel>? familyMembers;

  MealPlanModel(
      {this.mealPlanID,
      this.reciepieData,
      this.date,
      this.type,
      this.familyMembers,
      this.isDelete,
      this.mealPlanCreatorModel,
      this.createdAt,
      this.myMealPlan,
      this.updatedAt,
      this.iV});

  MealPlanModel.fromJson(Map<String, dynamic> json) {
    mealPlanID = json['_id'];
    reciepieData = json['recipe_id'] != null
        ? RecipeModel.fromJson(json['recipe_id'])
        : null;
    date = json['date'];
    type = json['type'];
    isDelete = json['is_delete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    myMealPlan = json['myMealPlan'];
    if (json['familyMembers'] != null) {
      familyMembers = <FamilyMemberModel>[];
      json['familyMembers'].forEach((v) {
        familyMembers!.add(FamilyMemberModel.fromJson(v));
      });
    }
    mealPlanCreatorModel =
        json['user'] != null ? UserModelData.fromJson(json['user']) : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = mealPlanID;
    if (reciepieData != null) {
      data['recipe_id'] = reciepieData!.toJson();
    }
    data['date'] = date;
    data['type'] = type;
    data['is_delete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (familyMembers != null) {
      data['familyMembers'] = familyMembers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecipeModel {
  String? reciepieId;
  String? title;
  List<String>? recipeImages;
  String? discription;
  String? type;
  List<Map<String, dynamic>>? ingredients;
  // dynamic ingredients;
  String? instruction;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? is_spooncular;
  int? iV;
  int? servingSize;
  int? myRecipe;
  UserModelData? userData;
  List<String>? sharedMembers;

  RecipeModel(
      {this.reciepieId,
      this.title,
      this.recipeImages,
      this.discription,
      this.is_spooncular,
      this.type,
      this.servingSize,
      this.ingredients,
      this.instruction,
      this.isDelete,
      this.sharedMembers,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.myRecipe,
      this.userData});

  RecipeModel.fromJson(Map<String, dynamic> json) {
    reciepieId = json['_id'];
    title = json['title'];

    is_spooncular = json['is_spooncular'];
    if (json['recipe_images'] != null) {
      recipeImages = <String>[];
      json['recipe_images'].forEach((v) {
        recipeImages!.add(v);
      });
    }
    discription = json['discription'];
    type = json['type'];
    // ingredients = json['ingredients'];

    if (json['ingredients'] != null) {
      ingredients = <Map<String, dynamic>>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(v);
      });
    }
    instruction = json['instruction'];
    servingSize = json['serving_size'];
    isDelete = json['is_delete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['share'] != null) {
      sharedMembers = <String>[];
      json['share'].forEach((v) {
        sharedMembers!.add(v);
      });
    } else {
      sharedMembers = [];
    }
    myRecipe = json['myRecipe'];
    userData = json['user_data'] != null
        ? UserModelData.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = reciepieId;
    data['title'] = title;
    if (recipeImages != null) {
      data['recipe_images'] = recipeImages!.map((v) => v).toList();
    }
    data['discription'] = discription;
    data['type'] = type;

    data['instruction'] = instruction;
    data['is_delete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['is_spooncular'] = is_spooncular;
    data['__v'] = iV;
    data['myRecipe'] = myRecipe;
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    return data;
  }
}

class FamilyMemberModel {
  String? relation;
  String? status;
  String? userId;
  String? userName;
  String? userImage;
  SuggestionData? suggestionData;

  FamilyMemberModel(
      {this.relation,
      this.status,
      this.userId,
      this.userName,
      this.userImage,
      this.suggestionData});

  FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    relation = json['relation'];
    status = json['status'];
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    suggestionData = json['suggestion_data'] != null
        ? SuggestionData.fromJson(json['suggestion_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['relation'] = relation;
    data['status'] = status;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    if (suggestionData != null) {
      data['suggestion_data'] = suggestionData!.toJson();
    }
    return data;
  }
}

class SuggestionData {
  String? sId;
  String? userId;
  String? mealPlanId;
  String? text;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SuggestionData(
      {this.sId,
      this.userId,
      this.mealPlanId,
      this.text,
      this.isDelete,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SuggestionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    mealPlanId = json['meal_plan_id'];
    text = json['text'];
    isDelete = json['is_delete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['meal_plan_id'] = mealPlanId;
    data['text'] = text;
    data['is_delete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ShareMembersData {
  String? userId;
  String? userName;
  String? userImage;

  ShareMembersData({this.userId, this.userName, this.userImage});

  ShareMembersData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    return data;
  }
}

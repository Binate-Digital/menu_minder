class MealPlanSuggestionRes {
  int? status;
  String? message;
  List<Data>? data;

  MealPlanSuggestionRes({this.status, this.message, this.data});

  MealPlanSuggestionRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  RecipeId? recipeId;
  String? date;
  String? type;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<FamilyMembers>? familyMembers;
  int? myMealPlan;
  UserData? user;

  Data(
      {this.sId,
      this.recipeId,
      this.date,
      this.type,
      this.isDelete,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.familyMembers,
      this.myMealPlan,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    recipeId =
        json['recipe_id'] != null ? RecipeId.fromJson(json['recipe_id']) : null;
    date = json['date'];
    type = json['type'];
    isDelete = json['is_delete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['familyMembers'] != null) {
      familyMembers = <FamilyMembers>[];
      json['familyMembers'].forEach((v) {
        familyMembers!.add(FamilyMembers.fromJson(v));
      });
    }
    myMealPlan = json['myMealPlan'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (recipeId != null) {
      data['recipe_id'] = recipeId!.toJson();
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
    data['myMealPlan'] = myMealPlan;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class RecipeId {
  String? sId;
  String? title;
  List<String>? recipeImages;
  String? discription;
  String? type;
  List<Ingredients>? ingredients;
  String? instruction;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? myRecipe;
  UserData? userData;

  RecipeId(
      {this.sId,
      this.title,
      this.recipeImages,
      this.discription,
      this.type,
      this.ingredients,
      this.instruction,
      this.isDelete,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.myRecipe,
      this.userData});

  RecipeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    recipeImages = json['recipe_images'].cast<String>();
    discription = json['discription'];
    type = json['type'];
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }
    instruction = json['instruction'];
    isDelete = json['is_delete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    myRecipe = json['myRecipe'];
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['recipe_images'] = recipeImages;
    data['discription'] = discription;
    data['type'] = type;
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    data['instruction'] = instruction;
    data['is_delete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['myRecipe'] = myRecipe;
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    return data;
  }
}

class Ingredients {
  String? a;
  String? sad;

  Ingredients({this.a, this.sad});

  Ingredients.fromJson(Map<String, dynamic> json) {
    a = json['A'];
    sad = json['sad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['A'] = a;
    data['sad'] = sad;
    return data;
  }
}

class UserData {
  String? userId;
  String? userName;
  String? userImage;
  UserLocation? userLocation;
  List<String>? foodPeferences;
  List<String>? dietPeferences;

  UserData(
      {this.userId,
      this.userName,
      this.userImage,
      this.userLocation,
      this.foodPeferences,
      this.dietPeferences});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userLocation = json['user_location'] != null
        ? UserLocation.fromJson(json['user_location'])
        : null;
    foodPeferences = json['food_peferences'].cast<String>();
    dietPeferences = json['diet_peferences'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    if (userLocation != null) {
      data['user_location'] = userLocation!.toJson();
    }
    data['food_peferences'] = foodPeferences;
    data['diet_peferences'] = dietPeferences;
    return data;
  }
}

class UserLocation {
  Null? address;
  Null? state;
  Null? city;
  Null? country;
  String? type;
  List<int>? coordinates;

  UserLocation(
      {this.address,
      this.state,
      this.city,
      this.country,
      this.type,
      this.coordinates});

  UserLocation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    state = json['state'];
    city = json['city'];
    country = json['country'];
    type = json['type'];
    coordinates = json['coordinates'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['state'] = state;
    data['city'] = city;
    data['country'] = country;
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class FamilyMembers {
  String? relation;
  String? status;
  String? userId;
  String? userName;
  String? userImage;
  SuggestionData? suggestionData;

  FamilyMembers(
      {this.relation,
      this.status,
      this.userId,
      this.userName,
      this.userImage,
      this.suggestionData});

  FamilyMembers.fromJson(Map<String, dynamic> json) {
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

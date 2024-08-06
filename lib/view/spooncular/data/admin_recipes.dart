// To parse this JSON data, do
//
//     final adminRecipes = adminRecipesFromJson(jsonString);

import 'dart:convert';

AdminRecipes adminRecipesFromJson(Map<String, dynamic> str) =>
    AdminRecipes.fromJson(str);

String adminRecipesToJson(AdminRecipes data) => json.encode(data.toJson());

class AdminRecipes {
  int status;
  String message;
  List<AdminRecipe> data;

  AdminRecipes({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AdminRecipes.fromJson(Map<String, dynamic> json) => AdminRecipes(
        status: json["status"],
        message: json["message"],
        data: List<AdminRecipe>.from(
            json["data"].map((x) => AdminRecipe.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AdminRecipe {
  String id;
  String title;
  int? servingSize;
  List<String> recipeImages;
  String? discription;
  String type;
  String preference;
  List<Map<String, String>> ingredients;
  String instruction;
  int isDelete;
  int isSpooncular;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? description;

  AdminRecipe({
    required this.id,
    required this.title,
    required this.servingSize,
    required this.recipeImages,
    this.discription,
    required this.type,
    required this.preference,
    required this.ingredients,
    required this.instruction,
    required this.isDelete,
    required this.isSpooncular,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.description,
  });

  factory AdminRecipe.fromJson(Map<String, dynamic> json) => AdminRecipe(
        id: json["_id"],
        title: json["title"],
        servingSize: json["serving_size"],
        recipeImages: List<String>.from(json["recipe_images"].map((x) => x)),
        discription: json["discription"],
        type: json["type"],
        preference: json["preference"],
        ingredients: List<Map<String, String>>.from(json["ingredients"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
        instruction: json["instruction"],
        isDelete: json["is_delete"],
        isSpooncular: json["is_spooncular"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "serving_size": servingSize,
        "recipe_images": List<dynamic>.from(recipeImages.map((x) => x)),
        "discription": discription,
        "type": type,
        "preference": preference,
        "ingredients": List<dynamic>.from(ingredients.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "instruction": instruction,
        "is_delete": isDelete,
        "is_spooncular": isSpooncular,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "description": description,
      };
}

// enum Preference {
//     BREAKFAST,
//     DINNER,
//     LUNCH,
//     PREFERENCE_BREAKFAST
// }

// final preferenceValues = EnumValues({
//     "Breakfast": Preference.BREAKFAST,
//     "Dinner": Preference.DINNER,
//     "Lunch": Preference.LUNCH,
//     "breakfast": Preference.PREFERENCE_BREAKFAST
// });

// enum Type {
//     RECIEPE,
//     RECIPE,
//     UNDEFINED
// }

// final typeValues = EnumValues({
//     "Reciepe": Type.RECIEPE,
//     "Recipe": Type.RECIPE,
//     "undefined": Type.UNDEFINED
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }

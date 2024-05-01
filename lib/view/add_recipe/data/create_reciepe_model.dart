import 'dart:convert';

class CreateReceipeModel {
  final String title;
  final String? descriptions;
  final String instructions;
  final String type;
  final int? servingSize;
  final List<String> images;
  String? networkImages;
  String? preference;
  int is_spooncular;
  final Map<String, String> ingredients;
  CreateReceipeModel({
    required this.title,
    this.descriptions,
    required this.instructions,
    this.servingSize,
    this.networkImages,
    required this.images,
    required this.ingredients,
    this.preference,
    this.is_spooncular = 0,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'discription': descriptions,
      'instruction': instructions,
      'recipe_images': images,
      'ingredients': ingredients,
      'preference': preference,
      'serving_size': servingSize,
      'is_spooncular': is_spooncular,
      'previous_paths': networkImages,
      'type': type
    };
  }
}

class IngredientModel {
  final String ingrdeintKey;
  final String ingredientValue;
  IngredientModel({
    required this.ingrdeintKey,
    required this.ingredientValue,
  });

  Map<String, dynamic> toMap() {
    return {
      ingrdeintKey: ingredientValue,
    };
  }

  String toJson() => json.encode(toMap());
}

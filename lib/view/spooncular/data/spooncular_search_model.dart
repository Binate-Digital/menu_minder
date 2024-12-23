import 'spooncular_random_reciepies_model.dart';

class SearchResultsSpooncular {
  List<Recipes>? results;
  int? offset;
  int? number;
  int? totalResults;

  SearchResultsSpooncular(
      {this.results, this.offset, this.number, this.totalResults});

  SearchResultsSpooncular.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Recipes>[];
      json['results'].forEach((v) {
        results!.add(Recipes.fromJson(v));
      });
    }
    offset = json['offset'];
    number = json['number'];
    totalResults = json['totalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    data['number'] = number;
    data['totalResults'] = totalResults;
    return data;
  }
}

// class RecipeSearchResult {
//   int? id;
//   String? title;
//   String? image;
//   String? imageType;
//
//   RecipeSearchResult({this.id, this.title, this.image, this.imageType});
//
//   RecipeSearchResult.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     image = json['image'];
//     imageType = json['imageType'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['image'] = image;
//     data['imageType'] = imageType;
//     return data;
//   }
// }

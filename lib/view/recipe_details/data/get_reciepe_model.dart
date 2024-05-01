import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';

class GetReciepiesList {
  int? status;
  String? message;
  List<RecipeModel>? data;

  GetReciepiesList({this.status, this.message, this.data});

  GetReciepiesList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RecipeModel>[];
      json['data'].forEach((v) {
        data!.add(RecipeModel.fromJson(v));
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

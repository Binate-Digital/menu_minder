import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';

class SinglePollResult {
  int? status;
  String? message;
  List<Data>? data;

  SinglePollResult({this.status, this.message, this.data});

  SinglePollResult.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? title;
  String? startTime;
  RecipeModel? recipeModel;
  String? endTime;
  List<String>? familyMembers;
  List<PollButton>? button;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.userId,
      this.title,
      this.startTime,
      this.endTime,
      this.familyMembers,
      this.button,
      this.isDelete,
      this.recipeModel,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    title = json['title'];
    //TODO: NEED RECIPIE ID HERE
    recipeModel = json['recipe_id'] != null
        ? RecipeModel.fromJson(json['recipe_id'])
        : null;
    startTime = json['start_time'];
    endTime = json['end_time'];
    familyMembers = json['family_members'].cast<String>();
    if (json['button'] != null) {
      button = <PollButton>[];
      json['button'].forEach((v) {
        button!.add(PollButton.fromJson(v));
      });
    }
    isDelete = json['is_delete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['title'] = title;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['family_members'] = familyMembers;
    if (button != null) {
      data['button'] = button!.map((v) => v.toJson()).toList();
    }
    data['is_delete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PollButton {
  String? sId;
  String? text;
  List<Voters>? voters;

  PollButton({this.sId, this.text, this.voters});

  PollButton.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'];
    if (json['voters'] != null) {
      voters = <Voters>[];
      json['voters'].forEach((v) {
        voters!.add(Voters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['text'] = text;
    if (voters != null) {
      data['voters'] = voters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Voters {
  String? sId;
  String? userId;
  String? poleId;
  String? buttonId;
  String? createdAt;
  String? updatedAt;
  String? suggestion;
  String? suggestionStatus;
  String? anotherSuggestion;
  int? iV;
  UserData? userData;

  Voters(
      {this.sId,
      this.userId,
      this.poleId,
      this.buttonId,
      this.createdAt,
      this.updatedAt,
      this.suggestion,
      this.iV,
      this.userData});

  Voters.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    poleId = json['pole_id'];
    buttonId = json['button_id'];
    anotherSuggestion = json['another_suggestion'];
    suggestionStatus = json['suggestion_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    suggestion = json['suggestion'];
    iV = json['__v'];
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['pole_id'] = poleId;
    data['button_id'] = buttonId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? sId;
  String? userName;
  String? userImage;

  UserData({this.sId, this.userName, this.userImage});

  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    return data;
  }
}

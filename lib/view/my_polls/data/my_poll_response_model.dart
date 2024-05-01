import 'package:menu_minder/view/family_suggestion/data/famliy_list_res.dart';
import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';
import 'package:menu_minder/view/meal_plan/screens/data/meal_plan_suggestion.dart';

import '../../auth/bloc/models/user_model.dart';

class MyPollsRes {
  int? status;
  String? message;
  List<PollData>? data;

  MyPollsRes({this.status, this.message, this.data});

  MyPollsRes.fromJson(Map<String, dynamic> json, {bool myPoll = false}) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PollData>[];
      json['data'].forEach((v) {
        data!.add(PollData.fromJson(v, myPoll));
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

class PollData {
  String? sId;
  UserModelData? userID;
  RecipeModel? recipeModel;
  String? userId;
  // ReceiverId? recciverID;
  String? title;
  String? startTime;
  String? endTime;
  List<FamilyMembers>? familyMembers;
  List<Button>? button;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PollData(
      {this.sId,
      this.userID,
      // this.recciverID,
      this.title,
      this.userId,
      this.startTime,
      this.endTime,
      this.recipeModel,
      this.familyMembers,
      this.button,
      this.isDelete,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PollData.fromJson(Map<String, dynamic> json, bool myPoll) {
    sId = json['_id'];
    // recciverID = json['receiver_id'] != null
    //     ? ReceiverId.fromJson(json['receiver_id'])
    //     : null;

    userId = myPoll ? json['user_id'] : null;
    userID = myPoll
        ? null
        : json['user_id'] != null
            ? UserModelData.fromJson(json['user_id'])
            : null;

    recipeModel = json['recipe_id'] != null
        ? RecipeModel.fromJson(json['recipe_id'])
        : null;
    title = json['title'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['family_members'] != null) {
      familyMembers = <FamilyMembers>[];
      json['family_members'].forEach((v) {
        familyMembers!.add(FamilyMembers.fromJson(v));
      });
    }
    if (json['button'] != null) {
      button = <Button>[];
      json['button'].forEach((v) {
        button!.add(Button.fromJson(v));
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
    // data['user_id'] = userId;
    data['title'] = title;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    if (familyMembers != null) {
      data['family_members'] = familyMembers!.map((v) => v.toJson()).toList();
    }
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

class FamilyMembers {
  String? sId;
  String? userName;
  String? userImage;

  FamilyMembers({this.sId, this.userName, this.userImage});

  FamilyMembers.fromJson(Map<String, dynamic> json) {
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

class Button {
  String? text;
  String? sId;
  List<Votes>? votes;
  int? totalVotes;
  int? buttonVotes;
  double? percentage;
  int? myVote;

  Button(
      {this.text,
      this.sId,
      this.votes,
      this.totalVotes,
      this.buttonVotes,
      this.percentage,
      this.myVote});

  Button.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    sId = json['_id'];
    if (json['votes'] != null) {
      votes = <Votes>[];
      json['votes'].forEach((v) {
        votes!.add(Votes.fromJson(v));
      });
    }
    totalVotes = json['total_votes'];
    buttonVotes = json['button_votes'];
    percentage = json['percentage'] != null
        ? double.parse(json['percentage'].toString())
        : 0.0;
    myVote = json['my_vote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['_id'] = sId;
    if (votes != null) {
      data['votes'] = votes!.map((v) => v.toJson()).toList();
    }
    data['total_votes'] = totalVotes;
    data['button_votes'] = buttonVotes;
    data['percentage'] = percentage;
    data['my_vote'] = myVote;
    return data;
  }
}

class Votes {
  String? sId;
  String? userId;
  String? poleId;
  String? buttonId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Votes(
      {this.sId,
      this.userId,
      this.poleId,
      this.buttonId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Votes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    poleId = json['pole_id'];
    buttonId = json['button_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
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
    return data;
  }
}

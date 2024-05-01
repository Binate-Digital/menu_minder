class ShareReponse {
  int? status;
  String? message;
  ShareData? data;

  ShareReponse({this.status, this.message, this.data});

  ShareReponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ShareData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ShareData {
  String? sId;
  String? userId;
  String? recipeId;
  List<String>? share;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ShareData(
      {this.sId,
      this.userId,
      this.recipeId,
      this.share,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ShareData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    recipeId = json['recipe_id'];
    share = json['share'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['recipe_id'] = recipeId;
    data['share'] = share;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

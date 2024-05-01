class FamilyList {
  int? status;
  String? message;
  List<FamilyData>? data;

  FamilyList({this.status, this.message, this.data});

  FamilyList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FamilyData>[];
      json['data'].forEach((v) {
        data!.add(FamilyData.fromJson(v));
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

class FamilyData {
  String? sId;
  ReceiverId? senderId;
  ReceiverId? receiverId;
  String? relation;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FamilyData(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.relation,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  FamilyData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'] != null
        ? ReceiverId.fromJson(json['sender_id'])
        : null;
    receiverId = json['receiver_id'] != null
        ? ReceiverId.fromJson(json['receiver_id'])
        : null;
    relation = json['relation'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['sender_id'] = senderId;
    if (receiverId != null) {
      data['receiver_id'] = receiverId!.toJson();
    }
    data['relation'] = relation;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ReceiverId {
  String? sId;
  String? userImage;
  String? userName;

  ReceiverId({this.sId, this.userImage, this.userName});

  ReceiverId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userImage = json['user_image'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_image'] = userImage;
    data['user_name'] = userName;
    return data;
  }
}

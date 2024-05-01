class ChatModel {
  String? objectType;
  List<ChatData>? data;

  ChatModel({this.objectType, this.data});

  ChatModel.fromJson(Map<String, dynamic> json) {
    objectType = json['object_type'];
    if (json['data'] != null) {
      data = <ChatData>[];
      json['data'].forEach((v) {
        data!.add(ChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['object_type'] = objectType;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatData {
  String? sId;
  UserInfo? senderId;
  UserInfo? receiverId;
  String? groupId;
  String? message;
  dynamic attachment;
  String? isRead;
  String? isBlocked;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ChatData(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.groupId,
      this.message,
      this.attachment,
      this.isRead,
      this.isBlocked,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ChatData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId =
        json['sender_id'] != null ? UserInfo.fromJson(json['sender_id']) : null;
    receiverId = json['receiver_id'] != null
        ? UserInfo.fromJson(json['receiver_id'])
        : null;
    groupId = json['group_id'];
    message = json['message'];
    attachment = json['attachment'];
    isRead = json['is_read'];
    isBlocked = json['is_blocked'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (senderId != null) {
      data['sender_id'] = senderId!.toJson();
    }
    if (receiverId != null) {
      data['receiver_id'] = receiverId!.toJson();
    }
    data['group_id'] = groupId;
    data['message'] = message;
    data['attachment'] = attachment;
    data['is_read'] = isRead;
    data['is_blocked'] = isBlocked;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class UserInfo {
  String? sId;
  String? userImage;
  String? userName;
  String? userEmail;

  UserInfo({this.sId, this.userImage, this.userName, this.userEmail});

  UserInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userImage = json['user_image'];
    userName = json['user_name'];
    userEmail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_image'] = userImage;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    return data;
  }
}

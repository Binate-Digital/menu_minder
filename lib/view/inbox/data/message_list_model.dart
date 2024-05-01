class RecentChatsList {
  int? status;
  List<RecentMessage>? data;

  RecentChatsList({this.status, this.data});

  RecentChatsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RecentMessage>[];
      json['data'].forEach((v) {
        data!.add(RecentMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentMessage {
  String? sId;
  RecentMesssageUserData? senderId;
  RecentMesssageUserData? receiverId;
  String? message;
  String? isRead;
  String? isBlocked;
  String? createdAt;
  String? updatedAt;

  RecentMessage(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.message,
      this.isRead,
      this.isBlocked,
      this.createdAt,
      this.updatedAt});

  RecentMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'] != null
        ? RecentMesssageUserData.fromJson(json['sender_id'])
        : null;
    receiverId = json['receiver_id'] != null
        ? RecentMesssageUserData.fromJson(json['receiver_id'])
        : null;
    message = json['message'];
    isRead = json['is_read'];
    isBlocked = json['is_blocked'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['message'] = message;
    data['is_read'] = isRead;
    data['is_blocked'] = isBlocked;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class RecentMesssageUserData {
  String? sId;
  String? userName;
  String? userImage;

  RecentMesssageUserData({this.sId, this.userName, this.userImage});

  RecentMesssageUserData.fromJson(Map<String, dynamic> json) {
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

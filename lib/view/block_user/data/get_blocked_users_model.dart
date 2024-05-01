class GetBlockedUsers {
  int? status;
  String? message;
  List<BlockedUserData>? data;

  GetBlockedUsers({this.status, this.message, this.data});

  GetBlockedUsers.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BlockedUserData>[];
      json['data'].forEach((v) {
        data!.add(BlockedUserData.fromJson(v));
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

class BlockedUserData {
  String? sId;
  String? senderId;
  ReceiverId? receiverId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  BlockedUserData(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  BlockedUserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'] != null
        ? ReceiverId.fromJson(json['receiver_id'])
        : null;
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
  String? userEmail;
  String? userPhone;
  List<String>? foodPeferences;
  List<String>? dietPeferences;
  String? userRole;
  int? userIsVerified;
  int? userIsNotification;
  int? userIsBlocked;
  int? userIsDelete;
  int? userIsComplete;
  String? userSocialToken;
  String? userSocialType;
  String? userDeviceType;
  String? userDeviceToken;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ReceiverId(
      {this.sId,
      this.userImage,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.foodPeferences,
      this.dietPeferences,
      this.userRole,
      this.userIsVerified,
      this.userIsNotification,
      this.userIsBlocked,
      this.userIsDelete,
      this.userIsComplete,
      this.userSocialToken,
      this.userSocialType,
      this.userDeviceType,
      this.userDeviceToken,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ReceiverId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userImage = json['user_image'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    foodPeferences = json['food_peferences'].cast<String>();
    dietPeferences = json['diet_peferences'].cast<String>();
    userRole = json['user_role'];
    userIsVerified = json['user_is_verified'];
    userIsNotification = json['user_is_notification'];
    userIsBlocked = json['user_is_blocked'];
    userIsDelete = json['user_is_delete'];
    userIsComplete = json['user_is_complete'];
    userSocialToken = json['user_social_token'];
    userSocialType = json['user_social_type'];
    userDeviceType = json['user_device_type'];
    userDeviceToken = json['user_device_token'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['user_image'] = userImage;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    data['food_peferences'] = foodPeferences;
    data['diet_peferences'] = dietPeferences;
    data['user_role'] = userRole;
    data['user_is_verified'] = userIsVerified;
    data['user_is_notification'] = userIsNotification;
    data['user_is_blocked'] = userIsBlocked;
    data['user_is_delete'] = userIsDelete;
    data['user_is_complete'] = userIsComplete;
    data['user_social_token'] = userSocialToken;
    data['user_social_type'] = userSocialType;
    data['user_device_type'] = userDeviceType;
    data['user_device_token'] = userDeviceToken;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

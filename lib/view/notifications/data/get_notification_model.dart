class GetNotification {
  int? status;
  String? message;
  List<NotificationModel>? data;

  GetNotification({this.status, this.message, this.data});

  GetNotification.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationModel>[];
      json['data'].forEach((v) {
        data!.add(NotificationModel.fromJson(v));
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

class NotificationModel {
  String? sId;
  SenderId? senderId;
  String? receiverId;
  String? notificationTitle;
  String? notificationBody;
  String? notificationType;
  String? notificationRoute;
  int? notificationIsBlock;
  dynamic? date;
  String? createdAt;
  String? pollID;
  String? updatedAt;
  int? iV;

  NotificationModel(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.notificationTitle,
      this.notificationBody,
      this.notificationType,
      this.notificationRoute,
      this.notificationIsBlock,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId =
        json['sender_id'] != null ? SenderId.fromJson(json['sender_id']) : null;
    receiverId = json['receiver_id'];
    notificationTitle = json['notification_title'];
    notificationBody = json['notification_body'];
    notificationType = json['notification_type'];
    notificationRoute = json['notification_route'];
    pollID = json['pole_id'];
    notificationIsBlock = json['notification_is_block'];
    date = json['date'];
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
    data['receiver_id'] = receiverId;
    data['notification_title'] = notificationTitle;
    data['notification_body'] = notificationBody;
    data['pole_id'] = pollID;
    data['notification_type'] = notificationType;
    data['notification_route'] = notificationRoute;
    data['notification_is_block'] = notificationIsBlock;
    data['date'] = date;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class SenderId {
  String? sId;
  dynamic userImage;
  dynamic userName;

  SenderId({this.sId, this.userImage, this.userName});

  SenderId.fromJson(Map<String, dynamic> json) {
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

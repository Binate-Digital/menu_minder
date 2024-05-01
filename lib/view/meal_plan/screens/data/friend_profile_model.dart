class FriendProfile {
  int? status;
  String? message;
  List<FriendData>? data;

  FriendProfile({this.status, this.message, this.data});

  FriendProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FriendData>[];
      json['data'].forEach((v) {
        data!.add(FriendData.fromJson(v));
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

class FriendData {
  String? sId;
  UserLocation? userLocation;
  String? userImage;
  String? userName;
  String? userEmail;
  String? userPhone;
  int? following;
  int? followers;

  FriendData(
      {this.sId,
      this.userLocation,
      this.userImage,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.following,
      this.followers});

  FriendData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userLocation = json['user_location'] != null
        ? UserLocation.fromJson(json['user_location'])
        : null;
    userImage = json['user_image'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    following = json['following'];
    followers = json['followers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (userLocation != null) {
      data['user_location'] = userLocation!.toJson();
    }
    data['user_image'] = userImage;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    data['following'] = following;
    data['followers'] = followers;
    return data;
  }
}

class UserLocation {
  dynamic address;
  dynamic state;
  dynamic city;
  dynamic country;
  String? type;
  List<int>? coordinates;

  UserLocation(
      {this.address,
      this.state,
      this.city,
      this.country,
      this.type,
      this.coordinates});

  UserLocation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    state = json['state'];
    city = json['city'];
    country = json['country'];
    type = json['type'];
    coordinates = json['coordinates'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['state'] = state;
    data['city'] = city;
    data['country'] = country;
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

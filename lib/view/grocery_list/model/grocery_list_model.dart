class GroceryListModel {
  int? status;
  String? message;
  List<GroceryData>? data;

  GroceryListModel({this.status, this.message, this.data});

  GroceryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GroceryData>[];
      json['data'].forEach((v) {
        data!.add(GroceryData.fromJson(v));
      });
    }
    // data = json['data'] != null ? GroceryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    // if (this.data != null) {
    // data['data'] = this.data!.toJson();

    // }
    return data;
  }
}

class GroceryData {
  String? sId;
  String? userId;
  String? storeName;
  List<GroceryItem>? groceryList;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GroceryData(
      {this.sId,
      this.userId,
      this.groceryList,
      this.createdAt,
      this.storeName,
      this.updatedAt,
      this.iV});

  GroceryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    if (json['grocery_list'] != null) {
      groceryList = <GroceryItem>[];
      json['grocery_list'].forEach((v) {
        groceryList!.add(GroceryItem.fromJson(v));
      });
    }
    storeName = json['store_name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    if (groceryList != null) {
      data['grocery_list'] = groceryList!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['store_name'] = storeName;
    data['__v'] = iV;
    return data;
  }
}

class GroceryItem {
  String? productName;
  int? productQuantity;
  String? productDiscription;
  int? isCheck;
  int? isDelete;
  String? sId;

  GroceryItem(
      {this.productName,
      this.productQuantity,
      this.productDiscription,
      this.isCheck,
      this.isDelete,
      this.sId});

  GroceryItem.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productQuantity = json['product_quantity'];
    productDiscription = json['product_discription'];
    isCheck = json['is_check'];
    isDelete = json['is_delete'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['product_quantity'] = productQuantity;
    data['product_discription'] = productDiscription;
    data['is_check'] = isCheck;
    data['is_delete'] = isDelete;
    data['_id'] = sId;
    return data;
  }
}

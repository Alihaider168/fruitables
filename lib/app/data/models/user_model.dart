class UserModel {
  User? customer;
  String? token;

  UserModel({
    this.customer,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    customer = (json['customer'] as Map<String,dynamic>?) != null ? User.fromJson(json['customer'] as Map<String,dynamic>) : null;
    token = json['token'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['customer'] = customer?.toJson();
    json['token'] = token;
    return json;
  }
}

class User {
  String? name;
  String? mobile;
  String? email;
  num? balance;
  num? points;
  List<dynamic>? favorites;
  List<dynamic>? addresses;
  String? createdAt;
  String? updatedAt;
  String? id;

  User({
    this.name,
    this.mobile,
    this.email,
    this.balance,
    this.points,
    this.favorites,
    this.addresses,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    mobile = json['mobile'] as String?;
    email = json['email'] as String?;
    balance = json['balance'] as int?;
    points = json['points'] as int?;
    favorites = json['favorites'] as List?;
    addresses = json['addresses'] as List?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['mobile'] = mobile;
    json['email'] = email;
    json['balance'] = balance;
    json['points'] = points;
    json['favorites'] = favorites;
    json['addresses'] = addresses;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['id'] = id;
    return json;
  }
}
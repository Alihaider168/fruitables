class OrdersModel {
  dynamic totalPages;
  num? totalResults;
  List<Orders>? orders;

  OrdersModel({
    this.totalPages,
    this.totalResults,
    this.orders,
  });

  OrdersModel.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'];
    totalResults = json['totalResults'] as num?;
    orders = (json['results'] as List?)?.map((dynamic e) => Orders.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['totalPages'] = totalPages;
    json['totalResults'] = totalResults;
    json['results'] = orders?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Orders {
  String? saleId;
  // OrderCustomer? customer;
  OrderBranch? branch;
  String? instructions;
  List<OrderProduct>? products;
  num? tax;
  num? discount;
  num? totalAmount;
  String? status;
  String? type;
  String? address;
  String? completedAt;
  String? preparingAt;
  String? deliveredAt;
  String? cancelledAt;
  String? createdAt;
  String? updatedAt;
  String? id;

  Orders({
    this.saleId,
    // this.customer,
    this.branch,
    this.instructions,
    this.products,
    this.tax,
    this.totalAmount,
    this.discount,
    this.status,
    this.type,
    this.address,
    this.completedAt,
    this.preparingAt,
    this.deliveredAt,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    saleId = json['saleId'] as String?;
    // customer = (json['customer'] as Map<String,dynamic>?) != null ? OrderCustomer.fromJson(json['customer'] as Map<String,dynamic>) : null;
    branch = (json['branch'] as Map<String,dynamic>?) != null ? OrderBranch.fromJson(json['branch'] as Map<String,dynamic>) : null;
    instructions = json['instructions'] as String?;
    products = (json['products'] as List?)?.map((dynamic e) => OrderProduct.fromJson(e as Map<String,dynamic>)).toList();
    tax = json['tax'] as num?;
    discount = json['discount'] as num?;
    totalAmount = json['totalAmount'] as num?;
    status = json['status'] as String?;
    type = json['type'] as String?;
    address = json['address'] as String?;
    completedAt = json['completedAt'];
    preparingAt = json['preparingAt'] as String?;
    deliveredAt = json['deliveredAt'];
    cancelledAt = json['cancelledAt'];
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    id = json['id'] ?? json['_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['saleId'] = saleId;
    // json['customer'] = customer?.toJson();
    json['branch'] = branch?.toJson();
    json['instructions'] = instructions;
    json['products'] = products?.map((e) => e.toJson()).toList();
    json['tax'] = tax;
    json['discount'] = discount;
    json['totalAmount'] = totalAmount;
    json['status'] = status;
    json['type'] = type;
    json['address'] = address;
    json['completedAt'] = completedAt;
    json['preparingAt'] = preparingAt;
    json['deliveredAt'] = deliveredAt;
    json['cancelledAt'] = cancelledAt;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['id'] = id;
    return json;
  }
}

class OrderCustomer {
  String? name;
  String? mobile;
  String? email;
  num? balance;
  num? points;
  // List<String>? favorites;
  // List<dynamic>? addresses;
  String? createdAt;
  String? updatedAt;
  String? id;

  OrderCustomer({
    this.name,
    this.mobile,
    this.email,
    this.balance,
    this.points,
    // this.favorites,
    // this.addresses,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  OrderCustomer.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    mobile = json['mobile'] as String?;
    email = json['email'] as String?;
    balance = json['balance'] as num?;
    points = json['points'] as num?;
    // favorites = (json['favorites'] as List?)?.map((dynamic e) => e as String).toList();
    // addresses = json['addresses'] as List?;
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
    // json['favorites'] = favorites;
    // json['addresses'] = addresses;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['id'] = id;
    return json;
  }
}

class OrderBranch {
  String? address;
  String? phone;
  OrderCity? city;
  String? map;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? englishAddress;
  String? englishCity;
  String? extNo;
  String? englishName;
  String? name;
  OrderRegion? region;
  bool? comingSoon;
  String? comingSoonDate;
  bool? bookings;
  List<dynamic>? sittingImage;
  String? companyId;
  bool? branchClosed;
  String? id;

  OrderBranch({
    this.address,
    this.phone,
    this.city,
    this.map,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.englishAddress,
    this.englishCity,
    this.extNo,
    this.englishName,
    this.name,
    this.region,
    this.comingSoon,
    this.comingSoonDate,
    this.bookings,
    this.sittingImage,
    this.companyId,
    this.branchClosed,
    this.id,
  });

  OrderBranch.fromJson(Map<String, dynamic> json) {
    address = json['address'] as String?;
    phone = json['phone'] as String?;
    city = (json['city'] as Map<String,dynamic>?) != null ? OrderCity.fromJson(json['city'] as Map<String,dynamic>) : null;
    map = json['map'] as String?;
    image = json['image'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    englishAddress = json['englishAddress'] as String?;
    englishCity = json['englishCity'] as String?;
    extNo = json['extNo'] as String?;
    englishName = json['englishName'] as String?;
    name = json['name'] as String?;
    region = (json['region'] as Map<String,dynamic>?) != null ? OrderRegion.fromJson(json['region'] as Map<String,dynamic>) : null;
    comingSoon = json['comingSoon'] as bool?;
    comingSoonDate = json['comingSoonDate'] as String?;
    bookings = json['bookings'] as bool?;
    sittingImage = json['sittingImage'] as List?;
    companyId = json['companyId'] as String?;
    branchClosed = json['branchClosed'] as bool?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['address'] = address;
    json['phone'] = phone;
    json['city'] = city?.toJson();
    json['map'] = map;
    json['image'] = image;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['englishAddress'] = englishAddress;
    json['englishCity'] = englishCity;
    json['extNo'] = extNo;
    json['englishName'] = englishName;
    json['name'] = name;
    json['region'] = region?.toJson();
    json['comingSoon'] = comingSoon;
    json['comingSoonDate'] = comingSoonDate;
    json['bookings'] = bookings;
    json['sittingImage'] = sittingImage;
    json['companyId'] = companyId;
    json['branchClosed'] = branchClosed;
    json['id'] = id;
    return json;
  }
}

class OrderCity {
  String? name;
  String? englishName;

  OrderCity({
    this.name,
    this.englishName,
  });

  OrderCity.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    englishName = json['englishName'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['englishName'] = englishName;
    return json;
  }
}

class OrderRegion {
  String? name;
  String? englishName;

  OrderRegion({
    this.name,
    this.englishName,
  });

  OrderRegion.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    englishName = json['englishName'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['englishName'] = englishName;
    return json;
  }
}

class OrderProduct {
  String? productId;
  String? name;
  String? size;
  num? quantity;
  num? price;
  String? id;

  OrderProduct({
    this.productId,
    this.name,
    this.size,
    this.quantity,
    this.price,
    this.id,
  });

  OrderProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] as String?;
    name = json['name'] as String?;
    size = json['size'] as String?;
    quantity = json['quantity'] as num?;
    price = json['price'] as num?;
    id = json['_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['productId'] = productId;
    json['name'] = name;
    json['size'] = size;
    json['quantity'] = quantity;
    json['price'] = price;
    json['_id'] = id;
    return json;
  }
}
class MenuModel {
  int? status;
  Data? data;

  MenuModel({
    this.status,
    this.data,
  });

  MenuModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as int?;
    data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['data'] = data?.toJson();
    return json;
  }
}

class Data {
  List<Categories>? categories;
  List<Items>? items;
  List<Banners>? banners;

  Data({
    this.categories,
    this.items,
    this.banners,
  });

  Data.fromJson(Map<String, dynamic> json) {
    categories = (json['categories'] as List?)?.map((dynamic e) => Categories.fromJson(e as Map<String,dynamic>)).toList();
    items = (json['items'] as List?)?.map((dynamic e) => Items.fromJson(e as Map<String,dynamic>)).toList();
    banners = (json['banners'] as List?)?.map((dynamic e) => Banners.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['categories'] = categories?.map((e) => e.toJson()).toList();
    json['items'] = items?.map((e) => e.toJson()).toList();
    json['banners'] = banners?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Categories {
  String? englishName;
  String? urduName;
  String? id;

  Categories({
    this.englishName,
    this.urduName,
    this.id,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    englishName = json['englishName'] as String?;
    urduName = json['urduName'] as String?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['englishName'] = englishName;
    json['urduName'] = urduName;
    json['id'] = id;
    return json;
  }
}

class Items {
  String? id;
  String? name;
  String? englishName;
  String? image;
  String? description;
  int? smallPrice;
  int? mediumPrice;
  int? largePrice;
  int? smallDiscountedPrice;
  int? mediumDiscountedPrice;
  int? largeDiscountedPrice;
  String? categoryId;
  int? smallDiscountedPercentage;
  int? mediumDiscountedPercentage;
  int? largeDiscountedPercentage;
  bool? isNew;
  bool? isTrending;
  bool? isHot;

  Items({
    this.id,
    this.name,
    this.englishName,
    this.image,
    this.description,
    this.smallPrice,
    this.mediumPrice,
    this.largePrice,
    this.smallDiscountedPrice,
    this.mediumDiscountedPrice,
    this.largeDiscountedPrice,
    this.categoryId,
    this.smallDiscountedPercentage,
    this.mediumDiscountedPercentage,
    this.largeDiscountedPercentage,
    this.isNew,
    this.isTrending,
    this.isHot,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    name = json['name'] as String?;
    englishName = json['englishName'] as String?;
    image = json['image'] as String?;
    description = json['description'] as String?;
    smallPrice = json['smallPrice'] as int?;
    mediumPrice = json['mediumPrice'] as int?;
    largePrice = json['largePrice'] as int?;
    smallDiscountedPrice = json['smallDiscountedPrice'] as int?;
    mediumDiscountedPrice = json['mediumDiscountedPrice'] as int?;
    largeDiscountedPrice = json['largeDiscountedPrice'] as int?;
    categoryId = json['categoryId'] as String?;
    smallDiscountedPercentage = json['smallDiscountedPercentage'] as int?;
    mediumDiscountedPercentage = json['mediumDiscountedPercentage'] as int?;
    largeDiscountedPercentage = json['largeDiscountedPercentage'] as int?;
    isNew = json['isNew'] as bool?;
    isTrending = json['isTrending'] as bool?;
    isHot = json['isHot'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['englishName'] = englishName;
    json['image'] = image;
    json['description'] = description;
    json['smallPrice'] = smallPrice;
    json['mediumPrice'] = mediumPrice;
    json['largePrice'] = largePrice;
    json['smallDiscountedPrice'] = smallDiscountedPrice;
    json['mediumDiscountedPrice'] = mediumDiscountedPrice;
    json['largeDiscountedPrice'] = largeDiscountedPrice;
    json['categoryId'] = categoryId;
    json['smallDiscountedPercentage'] = smallDiscountedPercentage;
    json['mediumDiscountedPercentage'] = mediumDiscountedPercentage;
    json['largeDiscountedPercentage'] = largeDiscountedPercentage;
    json['isNew'] = isNew;
    json['isTrending'] = isTrending;
    json['isHot'] = isHot;
    return json;
  }
}

class Banners {
  String? image;
  String? id;

  Banners({
    this.image,
    this.id,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    image = json['image'] as String?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['image'] = image;
    json['id'] = id;
    return json;
  }
}
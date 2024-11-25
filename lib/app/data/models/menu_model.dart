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
  List<Banners>? popups;
    List<HomePageWidgets>? homePageWidgets;


  Data({
    this.categories,
    this.items,
    this.banners,
    this.popups,
    this.homePageWidgets,
  });

  Data.fromJson(Map<String, dynamic> json) {
    categories = (json['categories'] as List?)?.map((dynamic e) => Categories.fromJson(e as Map<String,dynamic>)).toList();
    items = (json['items'] as List?)?.map((dynamic e) => Items.fromJson(e as Map<String,dynamic>)).toList();
    banners = (json['banners'] as List?)?.map((dynamic e) => Banners.fromJson(e as Map<String,dynamic>)).toList();
    popups = (json['popUps'] as List?)?.map((dynamic e) => Banners.fromJson(e as Map<String,dynamic>)).toList();
    homePageWidgets = (json['HomePageWidgets'] as List?)?.map((dynamic e)=>HomePageWidgets.fromMap(e as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['categories'] = categories?.map((e) => e.toJson()).toList();
    json['items'] = items?.map((e) => e.toJson()).toList();
    json['banners'] = banners?.map((e) => e.toJson()).toList();
    json['popUps'] = popups?.map((e) => e.toJson()).toList();
    json['HomePageWidgets'] = homePageWidgets?.map((e) => e.toMap()).toList();

    return json;
  }
}
class HomePageWidgets {
  final String title;
  final List<String> products;
  final String englishName;

  HomePageWidgets({
    required this.title,
    required this.products,
    required this.englishName,
  });

  // Converts the object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'products': products,
      'englishName': englishName,
    };
  }

  // Creates an object from a Map
  factory HomePageWidgets.fromMap(Map<String, dynamic> map) {
    return HomePageWidgets(
      title: map['title'] ?? '',
      products: List<String>.from(map['products'] ?? []),
      englishName: map['englishName'] ?? '',
    );
  }
}


class Categories {
  String? englishName;
  String? arabicName;
  AppImage? appImage;
  String? id;

  Categories({
    this.englishName,
    this.arabicName,
    this.appImage,
    this.id,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    englishName = json['englishName'] as String?;
    arabicName = json['arabicName'] as String?;
    appImage = (json['appImage'] as Map<String,dynamic>?) != null ? AppImage.fromJson(json['appImage'] as Map<String,dynamic>) : null;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['englishName'] = englishName;
    json['arabicName'] = arabicName;
    json['appImage'] = appImage?.toJson();
    json['id'] = id;
    return json;
  }
}

class AppImage {
  String? name;
  String? key;
  String? type;
  int? size;
  bool? private;
  String? createdAt;
  String? updatedAt;
  String? id;

  AppImage({
    this.name,
    this.key,
    this.type,
    this.size,
    this.private,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  AppImage.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    key = json['key'] as String?;
    type = json['type'] as String?;
    size = json['size'] as int?;
    private = json['private'] as bool?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['key'] = key;
    json['type'] = type;
    json['size'] = size;
    json['private'] = private;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['id'] = id;
    return json;
  }
}
// class Categories {
//   String? englishName;
//   String? arabicName;
//   Image? image;
//   String? id;
//
//   Categories({
//     this.englishName,
//     this.arabicName,
//     this.image,
//     this.id,
//   });
//
//   Categories.fromJson(Map<String, dynamic> json) {
//     englishName = json['englishName'] as String?;
//     arabicName = json['arabicName'] as String?;
//     image = (json['appImage'] as Map<String,dynamic>?) != null ? Image.fromJson(json['image'] as Map<String,dynamic>) : null;
//     id = json['id'] as String?;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['englishName'] = englishName;
//     json['arabicName'] = arabicName;
//     json['image'] = image?.toJson();
//     json['id'] = id;
//     return json;
//   }
// }

class Image {
  String? name;
  String? key;
  String? type;
  int? size;
  bool? private;
  String? createdAt;
  String? updatedAt;
  String? id;

  Image({
    this.name,
    this.key,
    this.type,
    this.size,
    this.private,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  Image.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    key = json['key'] as String?;
    type = json['type'] as String?;
    size = json['size'] as int?;
    private = json['private'] as bool?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['key'] = key;
    json['type'] = type;
    json['size'] = size;
    json['private'] = private;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['id'] = id;
    return json;
  }
}

class Items {
  String? id;
  String? name;
  Image? image;
  String? englishName;
  String? description;
  String? englishDescription;
  bool? isNew;
  bool? isHot;
  bool? isTrending;
  num? smallPrice;
  num? mediumPrice;
  num? largePrice;
  num? bottlePrice;
  num? mobileSmall;
  num? mobileMedium;
  num? mobileLarge;
  num? mobileBottle;
  String? categoryId;
    int? calories;


  Items({
    this.id,
    this.name,
    this.image,
    this.englishName,
    this.description,
    this.englishDescription,
    this.isNew,
    this.isHot,
    this.isTrending,
    this.smallPrice,
    this.mediumPrice,
    this.largePrice,
    this.bottlePrice,
    this.mobileSmall,
    this.mobileMedium,
    this.mobileLarge,
    this.mobileBottle,
    this.calories,
    this.categoryId,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    name = json['name'] as String?;
    image = (json['image'] as Map<String,dynamic>?) != null ? Image.fromJson(json['image'] as Map<String,dynamic>) : null;
    englishName = json['englishName'] as String?;
    description = json['description'] as String?;
    englishDescription = json['englishDescription'] as String?;
    isNew = json['isNew'] as bool?;
    isHot = json['isHot'] as bool?;
    isTrending = json['isTrending'] as bool?;
    smallPrice = json['smallPrice'];
    mediumPrice = json['mediumPrice'];
    largePrice = json['largePrice'];
    bottlePrice = json['bottlePrice'];
    mobileSmall = json['mobileSmall'];
    mobileMedium = json['mobileMedium'];
    mobileLarge = json['mobileLarge'];
    mobileBottle = json['mobileBottle'];
    categoryId = json['categoryId'] as String?;
    calories= json['calories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_id'] = id;
    json['name'] = name;
    json['image'] = image?.toJson();
    json['englishName'] = englishName;
    json['description'] = description;
    json['englishDescription'] = englishDescription;
    json['isNew'] = isNew;
    json['isHot'] = isHot;
    json['isTrending'] = isTrending;
    json['smallPrice'] = smallPrice;
    json['mediumPrice'] = mediumPrice;
    json['largePrice'] = largePrice;
    json['bottlePrice'] = bottlePrice;
    json['mobileSmall'] = mobileSmall;
    json['mobileMedium'] = mobileMedium;
    json['mobileLarge'] = mobileLarge;
    json['mobileBottle'] = mobileBottle;
    json['categoryId'] = categoryId;
    json['calories']= calories;
    return json;
  }
}

class Banners {
  Image? image;
  String? id;

  Banners({
    this.image,
    this.id,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    image = (json['image'] as Map<String,dynamic>?) != null ? Image.fromJson(json['image'] as Map<String,dynamic>) : null;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['image'] = image?.toJson();
    json['id'] = id;
    return json;
  }
}
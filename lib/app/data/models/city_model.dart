class CityModel {
  int? status;
  int? totalBranches;
  Data? data;

  CityModel({
    this.status,
    this.totalBranches,
    this.data,
  });

  CityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as int?;
    totalBranches = json['totalBranches'] as int?;
    data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['totalBranches'] = totalBranches;
    json['data'] = data?.toJson();
    return json;
  }
}

class Data {
  List<Cities>? cities;
  List<Branches>? branches;

  Data({
    this.cities,
    this.branches,
  });

  Data.fromJson(Map<String, dynamic> json) {
    cities = (json['cities'] as List?)?.map((dynamic e) => Cities.fromJson(e as Map<String,dynamic>)).toList();
    branches = (json['branches'] as List?)?.map((dynamic e) => Branches.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['cities'] = cities?.map((e) => e.toJson()).toList();
    json['branches'] = branches?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Cities {
  String? name;
  String? englishName;

  Cities({
    this.name,
    this.englishName,
  });

  Cities.fromJson(Map<String, dynamic> json) {
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

class Branches {
  String? address;
  City? city;
  String? phone;
  String? image;
  String? name;
  String? englishName;
  Region? region;
  String? id;

  Branches({
    this.address,
    this.city,
    this.phone,
    this.image,
    this.name,
    this.englishName,
    this.region,
    this.id,
  });

  Branches.fromJson(Map<String, dynamic> json) {
    address = json['address'] as String?;
    city = (json['city'] as Map<String,dynamic>?) != null ? City.fromJson(json['city'] as Map<String,dynamic>) : null;
    phone = json['phone'] as String?;
    image = json['image'] as String?;
    name = json['name'] as String?;
    englishName = json['englishName'] as String?;
    region = (json['region'] as Map<String,dynamic>?) != null ? Region.fromJson(json['region'] as Map<String,dynamic>) : null;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['address'] = address;
    json['city'] = city?.toJson();
    json['phone'] = phone;
    json['image'] = image;
    json['name'] = name;
    json['englishName'] = englishName;
    json['region'] = region?.toJson();
    json['id'] = id;
    return json;
  }
}

class City {
  String? name;
  String? englishName;

  City({
    this.name,
    this.englishName,
  });

  City.fromJson(Map<String, dynamic> json) {
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

class Region {
  String? name;
  String? englishName;

  Region({
    this.name,
    this.englishName,
  });

  Region.fromJson(Map<String, dynamic> json) {
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
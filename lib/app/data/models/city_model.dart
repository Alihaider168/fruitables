class CityModel {
  int? status;
  int? totalBranches;
  List<Branches>? branches;
  List<Cities>? cities;

  CityModel({
    this.status,
    this.totalBranches,
    this.branches,
    this.cities,
  });

  CityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as int?;
    totalBranches = json['totalBranches'] as int?;
    branches = (json['branches'] as List?)?.map((dynamic e) => Branches.fromJson(e as Map<String,dynamic>)).toList();
    cities = (json['cities'] as List?)?.map((dynamic e) => Cities.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['totalBranches'] = totalBranches;
    json['branches'] = branches?.map((e) => e.toJson()).toList();
    json['cities'] = cities?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Branches {
  String? address;
  String? phone;
  City? city;
  String? image;
  String? englishName;
  String? name;
  String? id;

  Branches({
    this.address,
    this.phone,
    this.city,
    this.image,
    this.englishName,
    this.name,
    this.id,
  });

  Branches.fromJson(Map<String, dynamic> json) {
    address = json['address'] as String?;
    phone = json['phone'] as String?;
    city = (json['city'] as Map<String,dynamic>?) != null ? City.fromJson(json['city'] as Map<String,dynamic>) : null;
    image = json['image'] as String?;
    englishName = json['englishName'] as String?;
    name = json['name'] as String?;
    id = json['id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['address'] = address;
    json['phone'] = phone;
    json['city'] = city?.toJson();
    json['image'] = image;
    json['englishName'] = englishName;
    json['name'] = name;
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
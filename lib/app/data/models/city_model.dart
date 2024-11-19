import 'package:rexsa_cafe/app/data/models/orders_model.dart';

class CityModel {
  int? status;
  int? totalBranches;
  List<OrderBranch>? branches;
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
    branches = (json['branches'] as List?)?.map((dynamic e) => OrderBranch.fromJson(e as Map<String,dynamic>)).toList();
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
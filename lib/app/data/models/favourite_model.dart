import 'package:fruitables/app/data/models/menu_model.dart';

class FavouriteModel {
  int? code;
  String? status;
  List<Items>? products;

  FavouriteModel({
    this.code,
    this.status,
    this.products,
  });

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] as int?;
    status = json['status'] as String?;
    // products = (json['products'] as Items?)?.map((dynamic e) => e as Items).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['code'] = code;
    json['status'] = status;
    // json['products'] = products;
    return json;
  }
}
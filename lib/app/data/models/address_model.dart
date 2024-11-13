class AddressModel {
  int? code;
  String? status;
  List<Addresses>? addresses;

  AddressModel({
    this.code,
    this.status,
    this.addresses,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] as int?;
    status = json['status'] as String?;
    addresses = (json['addresses'] as List?)?.map((dynamic e) => Addresses.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['code'] = code;
    json['status'] = status;
    json['addresses'] = addresses?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Addresses {
  String? label;
  String? street;
  String? floor;
  String? address;
  String? id;

  Addresses({
    this.label,
    this.street,
    this.floor,
    this.address,
    this.id,
  });

  Addresses.fromJson(Map<String, dynamic> json) {
    label = json['label'] as String?;
    street = json['street'] as String?;
    floor = json['floor'] as String?;
    address = json['address'] as String?;
    id = json['_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['label'] = label;
    json['street'] = street;
    json['floor'] = floor;
    json['address'] = address;
    json['_id'] = id;
    return json;
  }
}
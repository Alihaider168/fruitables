class VoucherModel {
  String? voucherNo;
  String? title;
  String? code;
  double? minimumAmount;
  int? howManyTimesCanUse;
  int? used;
  String? customer;
  double? discount;
  String? type;
  DateTime? expiryDate;
  DateTime? startDate;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  VoucherModel({
    this.voucherNo,
    this.title,
    this.code,
    this.minimumAmount,
    this.howManyTimesCanUse,
    this.used,
    this.customer,
    this.discount,
    this.type,
    this.expiryDate,
    this.startDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  // Convert a Voucher to a Map
  Map<String, dynamic> toMap() {
    return {
      'voucherNo': voucherNo,
      'title': title,
      'code': code,
      'minimumAmount': minimumAmount,
      'howManyTimesCanUse': howManyTimesCanUse,
      'used': used,
      'customer': customer,
      'discount': discount,
      'type': type,
      'expiryDate': expiryDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'id': id,
    };
  }

  // Create a Voucher from a Map
  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    return VoucherModel(
      voucherNo: map['voucherNo']?.toString() ??'',
      title: map['title'] as String?,
      code: map['code'] as String?,
      minimumAmount: (map['minimumAmount'] as num?)?.toDouble(),
      howManyTimesCanUse: map['howManyTimesCanUse'] as int?,
      used: map['used'] as int?,
      customer: map['customer'] as String?,
      discount: (map['discount'] as num?)?.toDouble(),
      type: map['type'] as String?,
      expiryDate: map['expiryDate'] != null ? DateTime.parse(map['expiryDate']) : null,
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      isActive: map['isActive'] as bool?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      id: map['id'] as String?,
    );
  }
}

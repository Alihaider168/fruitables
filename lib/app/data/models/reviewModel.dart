class ReviewModel {
  String? name;
  String? email;
  String? phone;
  DateTime? date;
  String? review;
  double? rating;
  String? branch;

  ReviewModel({
    this.name,
    this.email,
    this.phone,
    this.date,
    this.review,
    this.rating,
    this.branch,
  });

  /// Converts a `ReviewModel` instance to a `Map<String, dynamic>`
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'date': date?.toIso8601String(),
      'review': review,
      'rating': rating,
      'branch': branch,
    };
  }

  /// Creates a `ReviewModel` instance from a `Map<String, dynamic>`
  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : null,
      review: map['review'] as String?,
      rating: (map['rating'] as num?)?.toDouble(),
      branch: map['branch'] as String?,
    );
  }
}

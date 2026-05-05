import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int? productId;
  String? name;
  double? price;
  dynamic description;
  int? categoryId;
  List<dynamic>? colorsList;
  List<dynamic>? imagesList;
  DateTime? createdAt;
  List<Review>? reviews;

  ProductModel({
    this.productId,
    this.name,
    this.price,
    this.description,
    this.categoryId,
    this.colorsList,
    this.imagesList,
    this.createdAt,
    this.reviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // 🔥 handle string "[]" or real array
    List<dynamic> parseList(dynamic value) {
      if (value == null) return [];
      if (value is String) {
        return jsonDecode(value);
      }
      return List<dynamic>.from(value);
    }

    return ProductModel(
      productId: json["product_id"],
      name: json["Name"],
      price: json["price"] == null
          ? null
          : double.tryParse(json["price"].toString()),
      description: json["description"],
      categoryId: json["categoryId"],
      colorsList: parseList(json["colorsList"]),
      imagesList: parseList(json["imagesList"]),
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      reviews: json["reviews"] == null
          ? []
          : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "Name": name,
    "price": price,
    "description": description,
    "categoryId": categoryId,
    "colorsList": colorsList ?? [],
    "imagesList": imagesList ?? [],
    "created_at": createdAt?.toIso8601String(),
    "reviews": reviews?.map((x) => x.toJson()).toList() ?? [],
  };
}

class Review {
  int? reviewId;
  int? rating;
  String? review;
  DateTime? createdAt;

  Review({this.reviewId, this.rating, this.review, this.createdAt});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    reviewId: json["review_id"],
    rating: json["rating"],
    review: json["review"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "review_id": reviewId,
    "rating": rating,
    "review": review,
    "created_at": createdAt?.toIso8601String(),
  };
}

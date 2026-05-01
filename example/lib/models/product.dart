// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  int? id;
  String? title;
  String? description;
  String? category;
  double? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  List<String>? tags;
  String? brand;
  String? sku;
  int? weight;
  Dimensions? dimensions;
  String? warrantyInformation;
  String? shippingInformation;
  String? availabilityStatus;
  List<Review>? reviews;
  String? returnPolicy;
  int? minimumOrderQuantity;
  Meta? meta;
  List<String>? images;
  String? thumbnail;

  Product({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.images,
    this.thumbnail,
  });

  // Null-safe factory — handles partial responses (e.g. POST /products/add
  // returns a stripped-down object without dimensions/reviews/meta).
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        price: (json["price"] as num?)?.toDouble(),
        discountPercentage:
            (json["discountPercentage"] as num?)?.toDouble(),
        rating: (json["rating"] as num?)?.toDouble(),
        stock: json["stock"],
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        brand: json["brand"],
        sku: json["sku"],
        weight: json["weight"],
        dimensions: json["dimensions"] == null
            ? null
            : Dimensions.fromJson(json["dimensions"]),
        warrantyInformation: json["warrantyInformation"],
        shippingInformation: json["shippingInformation"],
        availabilityStatus: json["availabilityStatus"],
        reviews: json["reviews"] == null
            ? null
            : List<Review>.from(
                json["reviews"].map((x) => Review.fromJson(x))),
        returnPolicy: json["returnPolicy"],
        minimumOrderQuantity: json["minimumOrderQuantity"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (title != null) "title": title,
        if (description != null) "description": description,
        if (category != null) "category": category,
        if (price != null) "price": price,
        if (discountPercentage != null) "discountPercentage": discountPercentage,
        if (rating != null) "rating": rating,
        if (stock != null) "stock": stock,
        if (tags != null) "tags": List<dynamic>.from(tags!.map((x) => x)),
        if (brand != null) "brand": brand,
        if (sku != null) "sku": sku,
        if (weight != null) "weight": weight,
        if (dimensions != null) "dimensions": dimensions!.toJson(),
        if (warrantyInformation != null)
          "warrantyInformation": warrantyInformation,
        if (shippingInformation != null)
          "shippingInformation": shippingInformation,
        if (availabilityStatus != null)
          "availabilityStatus": availabilityStatus,
        if (reviews != null)
          "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        if (returnPolicy != null) "returnPolicy": returnPolicy,
        if (minimumOrderQuantity != null)
          "minimumOrderQuantity": minimumOrderQuantity,
        if (meta != null) "meta": meta!.toJson(),
        if (images != null) "images": List<dynamic>.from(images!.map((x) => x)),
        if (thumbnail != null) "thumbnail": thumbnail,
      };
}

class Dimensions {
  double? width;
  double? height;
  double? depth;

  Dimensions({this.width, this.height, this.depth});

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        width: (json["width"] as num?)?.toDouble(),
        height: (json["height"] as num?)?.toDouble(),
        depth: (json["depth"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "depth": depth,
      };
}

class Meta {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? barcode;
  String? qrCode;

  Meta({this.createdAt, this.updatedAt, this.barcode, this.qrCode});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        barcode: json["barcode"],
        qrCode: json["qrCode"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "barcode": barcode,
        "qrCode": qrCode,
      };
}

class Review {
  int? rating;
  String? comment;
  DateTime? date;
  String? reviewerName;
  String? reviewerEmail;

  Review({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json["rating"],
        comment: json["comment"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        reviewerName: json["reviewerName"],
        reviewerEmail: json["reviewerEmail"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "comment": comment,
        "date": date?.toIso8601String(),
        "reviewerName": reviewerName,
        "reviewerEmail": reviewerEmail,
      };
}

class ProductResponse {
  List<Product> products;
  int total;
  int skip;
  int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: List<Product>.from(
        json['products'].map((x) => Product.fromJson(x)),
      ),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}

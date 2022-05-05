import 'package:json_annotation/json_annotation.dart';

part 'Product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String permaLink;
  final String title;
  final String thumbnail;
  final double price;
  final int quantity;
  final bool isActive;

  Product({
    required this.id,
    required this.permaLink,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class ProductDiscardRequest {
  final List<ProductDiscard> products;

  ProductDiscardRequest({
    required this.products,
  });

  factory ProductDiscardRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductDiscardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDiscardRequestToJson(this);
}

@JsonSerializable()
class ProductDiscard {
  final String id;

  ProductDiscard({
    required this.id,
  });

  factory ProductDiscard.fromJson(Map<String, dynamic> json) =>
      _$ProductDiscardFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDiscardToJson(this);
}

@JsonSerializable()
class ProductResponse {
  final int total;
  final List<Product> products;

  ProductResponse({
    required this.total,
    required this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

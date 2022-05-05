import 'package:json_annotation/json_annotation.dart';

part 'ProductNotification.g.dart';

@JsonSerializable()
class ProductNotification {
  final int id;
  final String productId;
  final String permaLink;
  final String title;
  final String thumbnail;
  final double price;
  final int quantity;
  final DateTime lastUpdated;
  final bool isActive;

  ProductNotification({
    required this.id,
    required this.productId,
    required this.permaLink,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
    required this.lastUpdated,
    required this.isActive,
  });

  factory ProductNotification.fromJson(Map<String, dynamic> json) =>
      _$ProductNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$ProductNotificationToJson(this);
}



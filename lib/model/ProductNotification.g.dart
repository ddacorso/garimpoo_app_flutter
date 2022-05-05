// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductNotification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductNotification _$ProductNotificationFromJson(Map<String, dynamic> json) =>
    ProductNotification(
      id: json['id'] as int,
      productId: json['productId'] as String,
      permaLink: json['permaLink'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      quantity: json['quantity'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ProductNotificationToJson(
        ProductNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'permaLink': instance.permaLink,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'price': instance.price,
      'quantity': instance.quantity,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isActive': instance.isActive,
    };

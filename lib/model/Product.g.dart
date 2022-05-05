// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      permaLink: json['permaLink'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      quantity: json['quantity'] as int,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'permaLink': instance.permaLink,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'price': instance.price,
      'quantity': instance.quantity,
      'isActive': instance.isActive,
    };

ProductDiscardRequest _$ProductDiscardRequestFromJson(
        Map<String, dynamic> json) =>
    ProductDiscardRequest(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductDiscard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductDiscardRequestToJson(
        ProductDiscardRequest instance) =>
    <String, dynamic>{
      'products': instance.products,
    };

ProductDiscard _$ProductDiscardFromJson(Map<String, dynamic> json) =>
    ProductDiscard(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ProductDiscardToJson(ProductDiscard instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      total: json['total'] as int,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'total': instance.total,
      'products': instance.products,
    };

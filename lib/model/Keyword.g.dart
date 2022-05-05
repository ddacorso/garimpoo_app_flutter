// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Keyword.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Keyword _$KeywordFromJson(Map<String, dynamic> json) => Keyword(
      id: json['id'] as int?,
      value: json['value'] as String,
      isActive: json['isActive'] as bool,
      type: json['type'] as String,
    );

Map<String, dynamic> _$KeywordToJson(Keyword instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'isActive': instance.isActive,
      'type': instance.type,
    };

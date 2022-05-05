// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
      id: json['id'] as int,
      isPublishedToday: json['isPublishedToday'] as bool,
      isFinishingToday: json['isFinishingToday'] as bool,
      maxNotifications: json['maxNotifications'] as int,
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) =>
              const KeywordSerialiser().fromJson(e as Map<String, dynamic>))
          .toList(),
      maxKeywords: json['maxKeywords'] as int,
    );

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'id': instance.id,
      'isPublishedToday': instance.isPublishedToday,
      'isFinishingToday': instance.isFinishingToday,
      'maxNotifications': instance.maxNotifications,
      'maxKeywords': instance.maxKeywords,
      'keywords':
          instance.keywords?.map(const KeywordSerialiser().toJson).toList(),
    };

import 'package:garimpoo/model/Filter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'KeywordSerialiser.dart';

class FilterSerialiser implements JsonConverter<Filter, Map<String, dynamic>> {
  const FilterSerialiser();

  @override
  Filter fromJson(Map<String, dynamic> json) => Filter(
        maxNotifications: json['maxNotifications'] as int,
        maxKeywords: json['maxKeywords'] as int,
        id: json['id'] as int,
        isFinishingToday: json['isFinishingToday'] as bool,
        isPublishedToday: json['isPublishedToday'] as bool,
        keywords: json['keywords'] == null ? [] : (json['keywords'] as List<dynamic>)
            .map((e) =>
                const KeywordSerialiser().fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson(Filter filter) => {
        "id": filter.id,
        "isPublishedToday": filter.isPublishedToday,
        "isFinishingToday": filter.isFinishingToday,
        "maxNotifications": filter.maxNotifications,
        "maxKeywords": filter.maxKeywords
      };
}

import 'package:garimpoo/model/Keyword.dart';
import 'package:json_annotation/json_annotation.dart';

class KeywordSerialiser implements JsonConverter<Keyword, Map<String, dynamic>> {
  const KeywordSerialiser();

  @override
  Keyword fromJson(Map<String, dynamic> json) => Keyword(
        value: json['value'] as String,
        isActive: json['isActive'] as bool,
        id: json['id'] != null ? json['id'] as int : null,
        type: json['type'] as String,
      );

  @override
  Map<String, dynamic> toJson(Keyword keyword) => {"id" : keyword.id, "value" : keyword.value, "isActive" : keyword.isActive, "type" : keyword.type};

}

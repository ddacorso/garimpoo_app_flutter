import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Keyword.g.dart';

@JsonSerializable()
class Keyword extends Equatable{
  final int? id;
  final String value;
  final bool isActive;
  final String type;

  const Keyword({
    required this.id,
    required this.value,
    required this.isActive,
    required this.type,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);

  Map<String, dynamic> toJson() => _$KeywordToJson(this);

  @override
  List<Object?> get props => [id, value, isActive, type];
}

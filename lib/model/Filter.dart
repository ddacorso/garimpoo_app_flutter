import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Keyword.dart';
import 'jsonconverter/KeywordSerialiser.dart';
part 'Filter.g.dart';

//flutter pub run build_runner build --delete-conflicting-outputs
@JsonSerializable()
@KeywordSerialiser()
class Filter extends Equatable {
  final int id;
  final bool isPublishedToday;
  final bool isFinishingToday;
  final int maxNotifications;
  final int maxKeywords;
  final List<Keyword>? keywords;

  const Filter(
      {required this.id,
      required this.isPublishedToday,
      required this.isFinishingToday,
      required this.maxNotifications,
      required this.keywords,
      required this.maxKeywords});

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);


  Map<String, dynamic> toJson() => _$FilterToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [id, isPublishedToday, isFinishingToday, maxNotifications, keywords, maxKeywords];
}

class FilterScreen extends Equatable {

  final int id;
  final bool isPublishedToday;
  final bool isFinishingToday;
  final int maxNotifications;
  final int maxKeywords;
  final List<Keyword> keywords;
  final List<FocusNode>? keywordFocus;
  final List<TextEditingController>? keywordController;
  final List<FocusNode>? notificationFocus;
  final List<TextEditingController>? notificationController;

  const FilterScreen(
      {required this.id,
        required this.isPublishedToday,
        required this.isFinishingToday,
        required this.maxNotifications,
        required this.keywords,
        required this.maxKeywords,
         this.keywordFocus,
         this.keywordController,
         this.notificationFocus,
         this.notificationController,
      });


  @override
  // TODO: implement props
  List<Object?> get props => [id, isPublishedToday, isFinishingToday, maxNotifications, keywords, maxKeywords, keywords, keywordFocus,notificationFocus, notificationController ];
}

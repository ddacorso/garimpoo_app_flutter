import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Filter.dart';
import 'jsonconverter/FilterSerialiser.dart';

part 'User.g.dart';

@FilterSerialiser()
@JsonSerializable()
class User extends Equatable {
  final String uid;
  final String username;
  final String planType;
  final Filter filter;

  const User(
      {required this.uid,
      required this.username,
      required this.planType,
      required this.filter});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [uid, username, filter, planType];
}

@JsonSerializable()
class UserRequest {
  String? username;
  String? fcmToken;

  UserRequest({
    this.username,
     required this.fcmToken
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRequestToJson(this);
}

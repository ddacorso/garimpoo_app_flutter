// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String,
      username: json['username'] as String,
      planType: json['planType'] as String,
      filter: const FilterSerialiser()
          .fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'planType': instance.planType,
      'filter': const FilterSerialiser().toJson(instance.filter),
    };

UserRequest _$UserRequestFromJson(Map<String, dynamic> json) => UserRequest(
      username: json['username'] as String?,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$UserRequestToJson(UserRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'fcmToken': instance.fcmToken,
    };

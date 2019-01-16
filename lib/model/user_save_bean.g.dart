// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_save_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSaveBean _$UserSaveBeanFromJson(Map<String, dynamic> json) {
  return UserSaveBean(
      json['code'] as int, json['msg'] as String, json['success'] as bool);
}

Map<String, dynamic> _$UserSaveBeanToJson(UserSaveBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'success': instance.success
    };

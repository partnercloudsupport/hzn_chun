// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogoutBean _$LogoutBeanFromJson(Map<String, dynamic> json) {
  return LogoutBean(
      json['code'] as int, json['msg'] as String, json['success'] as bool);
}

Map<String, dynamic> _$LogoutBeanToJson(LogoutBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'success': instance.success
    };

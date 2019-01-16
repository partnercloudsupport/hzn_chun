// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_open_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceOpenBean _$DeviceOpenBeanFromJson(Map<String, dynamic> json) {
  return DeviceOpenBean(
      json['code'] as int, json['msg'] as String, json['success'] as bool);
}

Map<String, dynamic> _$DeviceOpenBeanToJson(DeviceOpenBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'success': instance.success
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBean _$DeviceBeanFromJson(Map<String, dynamic> json) {
  return DeviceBean(
      json['code'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Device.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$DeviceBeanToJson(DeviceBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

Device _$DeviceFromJson(Map<String, dynamic> json) {
  return Device(
      json['batteryValue'] as int,
      json['compileVer'] as String,
      json['deviceNo'] as String,
      json['status'] as int,
      json['version'] as String,
      json['deviceName'] as String);
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'batteryValue': instance.batteryValue,
      'compileVer': instance.compileVer,
      'deviceNo': instance.deviceNo,
      'status': instance.status,
      'version': instance.version,
      'deviceName': instance.deviceName
    };

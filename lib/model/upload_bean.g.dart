// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadBean _$UploadBeanFromJson(Map<String, dynamic> json) {
  return UploadBean(json['code'] as int, json['data'] as String,
      json['msg'] as String, json['success'] as bool);
}

Map<String, dynamic> _$UploadBeanToJson(UploadBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

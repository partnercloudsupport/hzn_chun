// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bean _$BeanFromJson(Map<String, dynamic> json) {
  return Bean(
      json['code'] as int, json['msg'] as String, json['success'] as bool);
}

Map<String, dynamic> _$BeanToJson(Bean instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'success': instance.success
    };

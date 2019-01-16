// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reg_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegBean _$RegBeanFromJson(Map<String, dynamic> json) {
  return RegBean(
      json['code'] as int, json['msg'] as String, json['success'] as bool);
}

Map<String, dynamic> _$RegBeanToJson(RegBean instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'success': instance.success
    };

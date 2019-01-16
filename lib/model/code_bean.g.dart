// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeBean _$CodeBeanFromJson(Map<String, dynamic> json) {
  return CodeBean(json['code'] as int, json['data'] as String,
      json['msg'] as String, json['success'] as bool);
}

Map<String, dynamic> _$CodeBeanToJson(CodeBean instance) => <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

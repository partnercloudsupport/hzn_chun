// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleBean _$ModuleBeanFromJson(Map<String, dynamic> json) {
  return ModuleBean(
      json['code'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Module.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$ModuleBeanToJson(ModuleBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

Module _$ModuleFromJson(Map<String, dynamic> json) {
  return Module(
      json['content'] as String,
      json['extend'] as String,
      json['linkUrl'] as String,
      json['picUrl'] as String,
      json['title'] as String);
}

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
      'content': instance.content,
      'extend': instance.extend,
      'linkUrl': instance.linkUrl,
      'picUrl': instance.picUrl,
      'title': instance.title
    };

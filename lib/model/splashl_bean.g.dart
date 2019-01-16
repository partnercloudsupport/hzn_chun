// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splashl_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplashBean _$SplashBeanFromJson(Map<String, dynamic> json) {
  return SplashBean(
      json['code'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Splash.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$SplashBeanToJson(SplashBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

Splash _$SplashFromJson(Map<String, dynamic> json) {
  return Splash(
      json['content'] as String,
      json['extend'] as String,
      json['linkUrl'] as String,
      json['picUrl'] as String,
      json['title'] as String);
}

Map<String, dynamic> _$SplashToJson(Splash instance) => <String, dynamic>{
      'content': instance.content,
      'extend': instance.extend,
      'linkUrl': instance.linkUrl,
      'picUrl': instance.picUrl,
      'title': instance.title
    };

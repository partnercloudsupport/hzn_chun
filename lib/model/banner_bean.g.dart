// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerBean _$BannerBeanFromJson(Map<String, dynamic> json) {
  return BannerBean(
      json['code'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : BannerData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$BannerBeanToJson(BannerBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

BannerData _$BannerDataFromJson(Map<String, dynamic> json) {
  return BannerData(
      json['content'] as String,
      json['extend'] as String,
      json['linkUrl'] as String,
      json['picUrl'] as String,
      json['title'] as String);
}

Map<String, dynamic> _$BannerDataToJson(BannerData instance) =>
    <String, dynamic>{
      'content': instance.content,
      'extend': instance.extend,
      'linkUrl': instance.linkUrl,
      'picUrl': instance.picUrl,
      'title': instance.title
    };

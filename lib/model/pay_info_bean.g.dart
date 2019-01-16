// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_info_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayInfoBean _$PayInfoBeanFromJson(Map<String, dynamic> json) {
  return PayInfoBean(
      json['code'] as int,
      json['data'] == null
          ? null
          : PayInfo.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$PayInfoBeanToJson(PayInfoBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

PayInfo _$PayInfoFromJson(Map<String, dynamic> json) {
  return PayInfo(json['payType'] as int, json['orderString'] as String);
}

Map<String, dynamic> _$PayInfoToJson(PayInfo instance) => <String, dynamic>{
      'payType': instance.payType,
      'orderString': instance.orderString
    };

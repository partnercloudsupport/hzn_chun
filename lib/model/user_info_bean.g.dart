// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoBean _$UserInfoBeanFromJson(Map<String, dynamic> json) {
  return UserInfoBean(
      json['code'] as int,
      json['data'] == null
          ? null
          : UserInfo.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$UserInfoBeanToJson(UserInfoBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
      json['deviceNo'] as String,
      json['id'] as int,
      json['mobile'] as String,
      json['realName'] as String,
      json['status'] as int,
      json['supplierId'] as int,
      json['headImg'] as String);
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'deviceNo': instance.deviceNo,
      'id': instance.id,
      'mobile': instance.mobile,
      'realName': instance.realName,
      'status': instance.status,
      'supplierId': instance.supplierId,
      'headImg': instance.avatar
    };

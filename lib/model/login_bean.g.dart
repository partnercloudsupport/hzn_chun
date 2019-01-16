// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginBean _$LoginBeanFromJson(Map<String, dynamic> json) {
  return LoginBean(json['data'] as String)
    ..code = json['code'] as int
    ..msg = json['msg'] as String
    ..success = json['success'] as bool;
}

Map<String, dynamic> _$LoginBeanToJson(LoginBean instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.data
    };

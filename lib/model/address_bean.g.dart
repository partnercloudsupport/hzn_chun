// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressBean _$AddressBeanFromJson(Map<String, dynamic> json) {
  return AddressBean(
      json['code'] as int,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$AddressBeanToJson(AddressBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['count'] as int,
      (json['list'] as List)
          ?.map((e) =>
              e == null ? null : Address.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'count': instance.count, 'list': instance.list};

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      json['address'] as String,
      json['area'] as String,
      json['city'] as String,
      json['createTime'] as int,
      json['id'] as int,
      json['linkman'] as String,
      json['province'] as String,
      json['telephone'] as String,
      json['userId'] as int);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address': instance.address,
      'area': instance.area,
      'city': instance.city,
      'createTime': instance.createTime,
      'id': instance.id,
      'linkman': instance.linkman,
      'province': instance.province,
      'telephone': instance.telephone,
      'userId': instance.userId
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersBean _$OrdersBeanFromJson(Map<String, dynamic> json) {
  return OrdersBean(
      json['code'] as int,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$OrdersBeanToJson(OrdersBean instance) =>
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
          ?.map((e) => e == null
              ? null
              : OrderDetail.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'count': instance.count, 'list': instance.details};

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return OrderDetail(
      json['createTime'] as int,
      json['goodsName'] as String,
      json['id'] as int,
      json['num'] as int,
      json['orderNo'] as String,
      (json['price'] as num)?.toDouble(),
      (json['money'] as num)?.toDouble(),
      json['status'] as int);
}

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'goodsName': instance.goodsName,
      'id': instance.id,
      'num': instance.num,
      'orderNo': instance.orderNo,
      'price': instance.price,
      'money': instance.money,
      'status': instance.status
    };

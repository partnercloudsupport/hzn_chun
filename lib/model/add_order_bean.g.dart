// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_order_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOrderBean _$AddOrderBeanFromJson(Map<String, dynamic> json) {
  return AddOrderBean(
      json['code'] as int,
      json['data'] == null
          ? null
          : Order.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$AddOrderBeanToJson(AddOrderBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
      json['createTime'] as int,
      json['goodsId'] as int,
      json['goodsName'] as String,
      json['id'] as int,
      json['num'] as int,
      json['orderNo'] as String,
      (json['price'] as num)?.toDouble(),
      (json['realPrice'] as num)?.toDouble(),
      json['status'] as int,
      json['supplierId'] as int,
      json['userId'] as int);
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'createTime': instance.createTime,
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'id': instance.id,
      'num': instance.num,
      'orderNo': instance.orderNo,
      'price': instance.price,
      'realPrice': instance.realPrice,
      'status': instance.status,
      'supplierId': instance.supplierId,
      'userId': instance.userId
    };

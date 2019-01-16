// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailBean _$ProductDetailBeanFromJson(Map<String, dynamic> json) {
  return ProductDetailBean(
      json['code'] as int,
      json['data'] == null
          ? null
          : ProductDetail.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$ProductDetailBeanToJson(ProductDetailBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
      'success': instance.success
    };

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) {
  return ProductDetail(
      json['createTime'] as int,
      json['goodsDescribe'] as String,
      json['goodsName'] as String,
      json['id'] as int,
      json['limitNum'] as int,
      (json['originalPrice'] as num)?.toDouble(),
      json['saleNum'] as int,
      (json['salePrice'] as num)?.toDouble(),
      json['status'] as int,
      json['supplierId'] as int,
      json['updateTime'] as int);
}

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'goodsDescribe': instance.goodsDescribe,
      'goodsName': instance.goodsName,
      'id': instance.id,
      'limitNum': instance.limitNum,
      'originalPrice': instance.originalPrice,
      'saleNum': instance.saleNum,
      'salePrice': instance.salePrice,
      'status': instance.status,
      'supplierId': instance.supplierId,
      'updateTime': instance.updateTime
    };

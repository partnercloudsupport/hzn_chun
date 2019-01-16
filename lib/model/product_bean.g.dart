// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBean _$ProductBeanFromJson(Map<String, dynamic> json) {
  return ProductBean(
      json['code'] as int,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String,
      json['success'] as bool);
}

Map<String, dynamic> _$ProductBeanToJson(ProductBean instance) =>
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
              e == null ? null : Product.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'count': instance.count, 'list': instance.products};

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
      json['goodsDescribe'] as String,
      json['goodsName'] as String,
      json['id'] as int,
      (json['originalPrice'] as num)?.toDouble(),
      (json['salePrice'] as num)?.toDouble())
    ..url = json['h5Url'] as String
    ..picUrl = json['pcUrl'] as String;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'goodsDescribe': instance.goodsDescribe,
      'goodsName': instance.goodsName,
      'id': instance.id,
      'originalPrice': instance.originalPrice,
      'h5Url': instance.url,
      'pcUrl': instance.picUrl,
      'salePrice': instance.salePrice
    };

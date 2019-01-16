import 'package:json_annotation/json_annotation.dart';

part 'product_detail_bean.g.dart';


@JsonSerializable()
class ProductDetailBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  ProductDetail data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  ProductDetailBean(this.code,this.data,this.msg,this.success,);

  factory ProductDetailBean.fromJson(Map<String, dynamic> srcJson) => _$ProductDetailBeanFromJson(srcJson);

}


@JsonSerializable()
class ProductDetail{

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'goodsDescribe')
  String goodsDescribe;

  @JsonKey(name: 'goodsName')
  String goodsName;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'limitNum')
  int limitNum;

  @JsonKey(name: 'originalPrice')
  double originalPrice;

  @JsonKey(name: 'saleNum')
  int saleNum;

  @JsonKey(name: 'salePrice')
  double salePrice;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'supplierId')
  int supplierId;

  @JsonKey(name: 'updateTime')
  int updateTime;

  ProductDetail(this.createTime,this.goodsDescribe,this.goodsName,this.id,this.limitNum,this.originalPrice,this.saleNum,this.salePrice,this.status,this.supplierId,this.updateTime,);

  factory ProductDetail.fromJson(Map<String, dynamic> srcJson) => _$ProductDetailFromJson(srcJson);

}



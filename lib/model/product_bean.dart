import 'package:json_annotation/json_annotation.dart';

part 'product_bean.g.dart';


@JsonSerializable()
class ProductBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  ProductBean(this.code,this.data,this.msg,this.success,);

  factory ProductBean.fromJson(Map<String, dynamic> srcJson) => _$ProductBeanFromJson(srcJson);

}


@JsonSerializable()
class Data {

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'list')
  List<Product> products;

  Data(this.count,this.products,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

}


@JsonSerializable()
class Product{

  @JsonKey(name: 'goodsDescribe')
  String goodsDescribe;

  @JsonKey(name: 'goodsName')
  String goodsName;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'originalPrice')
  double originalPrice;

  @JsonKey(name: 'h5Url')
  String url;

  @JsonKey(name: 'pcUrl')
  String picUrl;


  @JsonKey(name: 'salePrice')
  double salePrice;

  Product(this.goodsDescribe,this.goodsName,this.id,this.originalPrice,this.salePrice,);

  factory Product.fromJson(Map<String, dynamic> srcJson) => _$ProductFromJson(srcJson);

}



import 'package:json_annotation/json_annotation.dart';

part 'add_order_bean.g.dart';


@JsonSerializable()
class AddOrderBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  Order data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  AddOrderBean(this.code,this.data,this.msg,this.success,);

  factory AddOrderBean.fromJson(Map<String, dynamic> srcJson) => _$AddOrderBeanFromJson(srcJson);

}


@JsonSerializable()
class Order{

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'goodsId')
  int goodsId;

  @JsonKey(name: 'goodsName')
  String goodsName;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'num')
  int num;

  @JsonKey(name: 'orderNo')
  String orderNo;

  @JsonKey(name: 'price')
  double price;

  @JsonKey(name: 'realPrice')
  double realPrice;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'supplierId')
  int supplierId;

  @JsonKey(name: 'userId')
  int userId;

  Order(this.createTime,this.goodsId,this.goodsName,this.id,this.num,this.orderNo,this.price,this.realPrice,this.status,this.supplierId,this.userId,);

  factory Order.fromJson(Map<String, dynamic> srcJson) => _$OrderFromJson(srcJson);

}



import 'package:json_annotation/json_annotation.dart';

part 'orders_bean.g.dart';


@JsonSerializable()
class OrdersBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  OrdersBean(this.code,this.data,this.msg,this.success,);

  factory OrdersBean.fromJson(Map<String, dynamic> srcJson) => _$OrdersBeanFromJson(srcJson);

}


@JsonSerializable()
class Data {

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'list')
  List<OrderDetail> details;

  Data(this.count,this.details,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

}


@JsonSerializable()
class OrderDetail {

  @JsonKey(name: 'createTime')
  int createTime;

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

  @JsonKey(name: 'money')
  double money;

  @JsonKey(name: 'status')
  int status;

  OrderDetail(this.createTime,this.goodsName,this.id,this.num,this.orderNo,this.price,this.money,this.status,);

  factory OrderDetail.fromJson(Map<String, dynamic> srcJson) => _$OrderDetailFromJson(srcJson);

}



import 'package:json_annotation/json_annotation.dart';

part 'address_bean.g.dart';


@JsonSerializable()
class AddressBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  AddressBean(this.code,this.data,this.msg,this.success,);

  factory AddressBean.fromJson(Map<String, dynamic> srcJson) => _$AddressBeanFromJson(srcJson);

}


@JsonSerializable()
class Data{

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'list')
  List<Address> list;

  Data(this.count,this.list,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

}


@JsonSerializable()
class Address {

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'area')
  String area;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'linkman')
  String linkman;

  @JsonKey(name: 'province')
  String province;

  @JsonKey(name: 'telephone')
  String telephone;

  @JsonKey(name: 'userId')
  int userId;

  Address(this.address,this.area,this.city,this.createTime,this.id,this.linkman,this.province,this.telephone,this.userId,);

  factory Address.fromJson(Map<String, dynamic> srcJson) => _$AddressFromJson(srcJson);

}



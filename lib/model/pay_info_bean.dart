import 'package:json_annotation/json_annotation.dart';

part 'pay_info_bean.g.dart';


@JsonSerializable()
class PayInfoBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  PayInfo data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  PayInfoBean(this.code,this.data,this.msg,this.success,);

  factory PayInfoBean.fromJson(Map<String, dynamic> srcJson) => _$PayInfoBeanFromJson(srcJson);

}


@JsonSerializable()
class PayInfo{

  @JsonKey(name: 'payType')
  int payType;

  @JsonKey(name: 'orderString')
  String orderString;

  PayInfo(this.payType,this.orderString,);

  factory PayInfo.fromJson(Map<String, dynamic> srcJson) => _$PayInfoFromJson(srcJson);

}



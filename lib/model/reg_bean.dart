import 'package:json_annotation/json_annotation.dart';

part 'reg_bean.g.dart';


@JsonSerializable()
class RegBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  RegBean(this.code,this.msg,this.success,);

  factory RegBean.fromJson(Map<String, dynamic> srcJson) => _$RegBeanFromJson(srcJson);

}



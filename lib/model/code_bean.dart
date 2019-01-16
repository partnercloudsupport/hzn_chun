/** 获取验证码***/
import 'package:json_annotation/json_annotation.dart';

part 'code_bean.g.dart';


@JsonSerializable()
class CodeBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  String data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  CodeBean(this.code,this.data,this.msg,this.success,);

  factory CodeBean.fromJson(Map<String, dynamic> srcJson) => _$CodeBeanFromJson(srcJson);

}

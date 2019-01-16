import 'package:json_annotation/json_annotation.dart';

part 'logout_bean.g.dart';


@JsonSerializable()
class LogoutBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  LogoutBean(this.code,this.msg,this.success,);

  factory LogoutBean.fromJson(Map<String, dynamic> srcJson) => _$LogoutBeanFromJson(srcJson);

}

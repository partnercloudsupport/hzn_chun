
import 'package:json_annotation/json_annotation.dart';

part 'login_bean.g.dart';


@JsonSerializable()
class LoginBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'data')
  String data;

  LoginBean(this.data):super();

  factory LoginBean.fromJson(Map<String, dynamic> srcJson) => _$LoginBeanFromJson(srcJson);

}

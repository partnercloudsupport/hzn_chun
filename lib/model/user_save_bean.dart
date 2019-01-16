import 'package:json_annotation/json_annotation.dart';

part 'user_save_bean.g.dart';


@JsonSerializable()
class UserSaveBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  UserSaveBean(this.code,this.msg,this.success,);

  factory UserSaveBean.fromJson(Map<String, dynamic> srcJson) => _$UserSaveBeanFromJson(srcJson);

}




import 'package:json_annotation/json_annotation.dart';

part 'user_info_bean.g.dart';


@JsonSerializable()
class UserInfoBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  UserInfo data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  UserInfoBean(this.code,this.data,this.msg,this.success,);

  factory UserInfoBean.fromJson(Map<String, dynamic> srcJson) => _$UserInfoBeanFromJson(srcJson);

}


@JsonSerializable()
class UserInfo{

  @JsonKey(name: 'deviceNo')
  String deviceNo;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'mobile')
  String mobile;

  @JsonKey(name: 'realName')
  String realName;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'supplierId')
  int supplierId;

  @JsonKey(name:'headImg')
  String avatar;


  UserInfo(this.deviceNo,this.id,this.mobile,this.realName,this.status,this.supplierId,this.avatar,);

  factory UserInfo.fromJson(Map<String, dynamic> srcJson) => _$UserInfoFromJson(srcJson);

}



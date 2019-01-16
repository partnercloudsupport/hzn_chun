import 'package:json_annotation/json_annotation.dart';

part 'device_open_bean.g.dart';


@JsonSerializable()
class DeviceOpenBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  DeviceOpenBean(this.code,this.msg,this.success,);

  factory DeviceOpenBean.fromJson(Map<String, dynamic> srcJson) => _$DeviceOpenBeanFromJson(srcJson);

}



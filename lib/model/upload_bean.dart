import 'package:json_annotation/json_annotation.dart';

part 'upload_bean.g.dart';


@JsonSerializable()
class UploadBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  String data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  UploadBean(this.code,this.data,this.msg,this.success,);

  factory UploadBean.fromJson(Map<String, dynamic> srcJson) => _$UploadBeanFromJson(srcJson);

}



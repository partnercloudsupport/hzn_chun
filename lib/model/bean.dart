import 'package:json_annotation/json_annotation.dart';

part 'bean.g.dart';


@JsonSerializable()
class Bean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  Bean(this.code,this.msg,this.success,);

  factory Bean.fromJson(Map<String, dynamic> srcJson) => _$BeanFromJson(srcJson);

}
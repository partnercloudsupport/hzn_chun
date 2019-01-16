import 'package:json_annotation/json_annotation.dart';

part 'module_bean.g.dart';


@JsonSerializable()
class ModuleBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<Module> data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  ModuleBean(this.code,this.data,this.msg,this.success,);

  factory ModuleBean.fromJson(Map<String, dynamic> srcJson) => _$ModuleBeanFromJson(srcJson);

}


@JsonSerializable()
class Module{

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'extend')
  String extend;

  @JsonKey(name: 'linkUrl')
  String linkUrl;

  @JsonKey(name: 'picUrl')
  String picUrl;

  @JsonKey(name: 'title')
  String title;

  Module(this.content,this.extend,this.linkUrl,this.picUrl,this.title,);

  factory Module.fromJson(Map<String, dynamic> srcJson) => _$ModuleFromJson(srcJson);

}



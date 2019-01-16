import 'package:json_annotation/json_annotation.dart';

part 'splashl_bean.g.dart';


@JsonSerializable()
class SplashBean {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<Splash> data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  SplashBean(this.code,this.data,this.msg,this.success,);

  factory SplashBean.fromJson(Map<String, dynamic> srcJson) => _$SplashBeanFromJson(srcJson);

}


@JsonSerializable()
class Splash{

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

  Splash(this.content,this.extend,this.linkUrl,this.picUrl,this.title,);

  factory Splash.fromJson(Map<String, dynamic> srcJson) => _$SplashFromJson(srcJson);

}



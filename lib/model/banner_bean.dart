import 'package:json_annotation/json_annotation.dart';

part 'banner_bean.g.dart';


@JsonSerializable()
class BannerBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<BannerData> data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  BannerBean(this.code,this.data,this.msg,this.success,);

  factory BannerBean.fromJson(Map<String, dynamic> srcJson) => _$BannerBeanFromJson(srcJson);

}


@JsonSerializable()
class BannerData {

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

  BannerData(this.content,this.extend,this.linkUrl,this.picUrl,this.title,);

  factory BannerData.fromJson(Map<String, dynamic> srcJson) => _$BannerDataFromJson(srcJson);

}



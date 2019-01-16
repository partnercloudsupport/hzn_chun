import 'package:json_annotation/json_annotation.dart';

part 'device_bean.g.dart';


@JsonSerializable()
class DeviceBean{

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  List<Device> data;

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'success')
  bool success;

  DeviceBean(this.code,this.data,this.msg,this.success,);

  factory DeviceBean.fromJson(Map<String, dynamic> srcJson) => _$DeviceBeanFromJson(srcJson);

}


@JsonSerializable()
class Device {

  @JsonKey(name: 'batteryValue')
  int batteryValue;

  @JsonKey(name: 'compileVer')
  String compileVer;

  @JsonKey(name: 'deviceNo')
  String deviceNo;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'version')
  String version;

  @JsonKey(name: 'deviceName')
  String deviceName;

  Device(this.batteryValue,this.compileVer,this.deviceNo,this.status,this.version,this.deviceName);

  factory Device.fromJson(Map<String, dynamic> srcJson) => _$DeviceFromJson(srcJson);

}



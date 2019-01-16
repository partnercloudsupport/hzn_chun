import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hzn/model/bean.dart';
import 'package:hzn/model/device_bean.dart';
import 'package:hzn/model/device_open_bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';

import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:tip_dialog/tip_dialog.dart';

import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';




class DevicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Page();
  }
}

class Page extends State<DevicePage>  with AutomaticKeepAliveClientMixin{
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  final deviceNoController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var items = List<Widget>();
  var devices = List<Device>();

  TipDialogController tipController;

  Device currentDevice;


  @override
  void initState() {
    loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return new TipDialogConnector(
      builder: (context, tipController) {
        this.tipController = tipController;
        return layout(context);
      },
    );
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(context),
      body: EasyRefresh(
        key: _easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: _headerKey,
        ),
        refreshFooter: MaterialFooter(
          key: _footerKey,
        ),
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            return _buildActionsItem(context, index);
          },
        ),
        onRefresh: () async {
          devices.clear();
          loadDevices();
        },
        loadMore: () async {},
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: barColor,
      title: const Text('设备',textAlign: TextAlign.center),
      actions: <Widget>[
        GestureDetector(
          child: Container(
            height: 45,
            width: 45,
            margin: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
          onTap: () {
            showAddDialog();
          },
        )
      ],
    );
  }

  Widget _buildAddForm() {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 160,
          height: 35,
          child: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid) //没什么卵效果
                    ),
                labelText: '请输入设备编号'),
            controller: deviceNoController,
            maxLines: 1,
            autocorrect: true,
            autofocus: true,
            obscureText: false,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
            keyboardType: TextInputType.text,
            enabled: true, //是否禁用
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child:  GestureDetector(
              child: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset("images/qr_code.png"),
              ),
              onTap: () {
                  scan();
              }),
        )

      ],
    ));
  }




  void showAddDialog() {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '添加设备',
          ),
          content: _buildAddForm(),
          actions: <Widget>[
            FlatButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(true);
                var deviceNo = deviceNoController.text;
                addDevice(deviceNo);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildIcon(bool isOpen) {
    if (isOpen) {
      return Icon(Icons.lock_open, color: Colors.green, size: 24);
    } else {
      return Icon(Icons.lock, color: Colors.grey, size: 24);
    }
  }

  Widget _buildActionsItem(BuildContext context, int index) {
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: itemBuild(context, index),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => showAlertDialog(context,devices.elementAt(index).deviceNo),
        ),
      ],
    );
  }


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() =>
          deviceNoController.text = barcode
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showToast("用户取消了授权");
      } else {
        showToast("$e");
      }
    } on FormatException{
    } catch (e) {
      showToast("$e");
    }
  }




  Widget itemBuild(BuildContext context, int index) {
    var _value = false;
    if (devices.elementAt(index).status == 0) {
      _value = true;
    } else {
      _value = false;
    }

    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 15),
            height: 60,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  buildIcon(_value),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        getDeviceName(index),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    child: Switch(
                        value: _value, //这里初始值为false
                        activeColor: Colors.green,
                        onChanged: (b) {
                          if(!_value){
                            currentDevice = devices.elementAt(index);
                            openLock(currentDevice.deviceNo);
                          }else{
                            showToast("锁已经打开");
                          }
                        }),
                  )
                ],
              ),
            )),
        Divider(
          height: 1,
          color: Colors.grey,
        )
      ],
    );
  }

  String getDeviceName(int index){
    String deviceName = devices.elementAt(index).deviceName;
    if(deviceName == null || deviceName.isEmpty){
      deviceName = devices.elementAt(index).deviceNo;
    }
    return deviceName;
  }


  Future<Null> loadDevices() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
    FormData formData = new FormData.from({});
    var resData = await HttpUtil.getInstance().get(I_DEVICES, context,data: formData,tip:tipController);
    var deviceBean = DeviceBean.fromJson(resData);
    if (deviceBean != null && deviceBean.success) {
      setState(() {
        devices = deviceBean.data;
      });
    }
  }

  Future<Null> openLock(String deviceNo) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({"deviceNo": "$deviceNo"});

    var resData = await HttpUtil.getInstance().post(I_OPEN_LOCK,context, data: formData,tip:tipController);
    var deviceOpenBean = DeviceOpenBean.fromJson(resData);
    if (deviceOpenBean.success) {
      showToast("开锁成功");
      //todo 刷新界面
//      devices.clear();
//      loadDevices();

      setState(() {
        currentDevice.status = 0;
      });


    } else {
      showToast(deviceOpenBean.msg);
    }
  }

  Future<Null> addDevice(String deviceNo) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({"deviceNo": "$deviceNo"});
    var resData = await HttpUtil.getInstance().post(I_ADD_LOCK,context, data: formData,tip:tipController);
    var bean = Bean.fromJson(resData);
    if (bean.success) {
      showToast("添加成功");
      //todo 刷新界面
      devices.clear();
      loadDevices();
    } else {
      showToast(bean.msg);
    }
  }


  void showAlertDialog(BuildContext context , String deviceNo) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text(
            '删除设备',
          ),
          content: Text("确定删除这个设备吗？"),
          actions: <Widget>[
            FlatButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: const Text('确定'),
              onPressed: () {
                removeDevice(deviceNo);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }




  Future<Null> removeDevice(String deviceNo) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({"deviceNo": "$deviceNo"});
    var resData =
        await HttpUtil.getInstance().post(I_REMOVE_LOCK,context, data: formData,tip:tipController);
    var bean = Bean.fromJson(resData);
    if (bean.success) {
      showToast("删除成功");
      //todo 刷新界面
      devices.clear();
      loadDevices();
    } else {
      showToast(bean.msg);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hzn/model/address_bean.dart';
import 'package:hzn/model/bean.dart';
import 'package:hzn/model/device_bean.dart';
import 'package:hzn/model/device_open_bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';

import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:hzn/widget/SelectAddressWidget.dart';
import 'package:tip_dialog/tip_dialog.dart';

import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:contact_picker/contact_picker.dart';




class AddressesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Addresses();
  }
}

class Addresses extends State<AddressesPage>  with AutomaticKeepAliveClientMixin{
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  final deviceNoController = TextEditingController();

  final personNameController = TextEditingController();
  final phoneController = TextEditingController();
  final ssqController = TextEditingController();
  final detailontroller = TextEditingController();


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var items = List<Widget>();
  var addresses = List<Address>();

  TipDialogController tipController;

  Address currentAddress;


  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;


  @override
  void initState() {

    loadAddress();
  }


  Future<dynamic> _handler(MethodCall methodCall){

    if(methodCall.method == "provinceResult"){
      Map<dynamic, dynamic> result = methodCall.arguments;
      var type = result["type"];
      if(type == "province"){
        setState(() {
          Map<dynamic, dynamic> info = result["value"];
          showToast("$info");
        });
      }
    }
    return Future.value(true);
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
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            return _buildActionsItem(context, index);
          },
        ),
        onRefresh: () async {
          addresses.clear();
          loadAddress();
        },
        loadMore: () async {},
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: barColor,
      title: const Text("收货地址",textAlign: TextAlign.center),
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
            showAddOrEditDialog(context);
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


  void pickContact() async{
    Contact contact = await _contactPicker.selectContact();
    setState(() {
      _contact = contact;
      showToast("${_contact.fullName}, ${_contact.phoneNumber.number}");
    });
  }

  ///显示选择所在地址弹窗
  void _showSelectAddrDialog() {
    ///显示一个BottomSheet
    showModalBottomSheet(
      context: context,
      ///_handleLocal是被回调页面的方法 用于接收选择的地址
      builder: (context) => new SelectAddressWidget(valueCb: _handleLocal,),
    );
  }

  void _handleLocal(Map<String, String> selectMap , String localStr){
    showToast("${selectMap.toString()} , $localStr");
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
          caption: '修改',
          color: lightBlue,
          icon: Icons.edit,
          onTap: () =>
//              pickContact(),
          _showSelectAddrDialog()
        ),
        new IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => showDelDialog(context,addresses.elementAt(index).id),
        ),
      ],
    );
  }


  Widget _buildAddressDialogContent(){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.person,color: lightBlue,size: 20,),
              _buildTextField(personNameController,"请输入收货人姓名" , 1),
              Icon(Icons.perm_contact_calendar,color: lightBlue,size: 20,),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.phone_android,color: lightBlue,size: 20,),
              _buildTextField(phoneController,"请输入收货人联系电话" , 1),
            ],
          ),

          Row(
            children: <Widget>[
              Icon(Icons.local_shipping,color: lightBlue,size: 20,),
              _buildTextField(ssqController,"请输入省市区信息" , 1),
              Icon(Icons.format_list_bulleted,color: lightBlue,size: 20,),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.details,color: lightBlue,size: 20,),
              _buildTextField(ssqController,"请输入详细地址" , 4),
            ],
          ),

        ],
      ),
    );


  }



  Widget _buildTextField(TextEditingController controller , String hint,int maxLine) {
    return new Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
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
              labelText: '$hint'),
          controller: controller,
          maxLines: maxLine,
          autocorrect: true,
          autofocus: true,
          obscureText: false,
          //是否是密码
          textAlign: TextAlign.center,
          //文本对齐方式
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
          keyboardType: TextInputType.text,
          enabled: true, //是否禁用
        ));
  }





  void showAddOrEditDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text(
            '添加收货地址',
          ),
          content: _buildAddressDialogContent(),
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
                addAddress();
              },
            ),
          ],
        );
      },
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
                Icon(Icons.local_shipping, color:lightBlue , size: 24),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "adfa",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
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



  Future<Null> loadAddress() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
    FormData formData = new FormData.from({});
    var resData = await HttpUtil.getInstance().get(I_ADDRESS_LIST, context,data: formData,tip:tipController);
    var addressBean = AddressBean.fromJson(resData);
    if (addressBean != null && addressBean.success) {
      setState(() {
        addresses = addressBean.data.list;
      });
    }
  }


  Future<Null> addAddress() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({"linkman": "","telephone":"","province":"","city":"","address":"","area":""});
    var resData = await HttpUtil.getInstance().post(I_ADD_ADDRESS,context, data: formData,tip:tipController);
    var bean = Bean.fromJson(resData);
    if (bean.success) {
      showToast("添加成功");
      //todo 刷新界面
      addresses.clear();
      loadAddress();
    } else {
      showToast(bean.msg);
    }
  }

  Future<Null> editAddress() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({"linkman": "","telephone":"","province":"","city":"","address":"","area":""});
    var resData = await HttpUtil.getInstance().post(I_ADD_ADDRESS,context, data: formData,tip:tipController);
    var bean = Bean.fromJson(resData);
    if (bean.success) {
      showToast("修改成功");
      //todo 刷新界面
      addresses.clear();
      loadAddress();
    } else {
      showToast(bean.msg);
    }
  }


  void showDelDialog(BuildContext context , int id) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text(
            '删除收货地址',
          ),
          content: Text("确定删除这个收货地址吗？"),
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
                removeAddress("$id");
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }


  Future<Null> removeAddress(String id) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({"id": "$id"});
    var resData = await HttpUtil.getInstance().post(I_DEL_ADDRESS,context, data: formData,tip:tipController);
    var bean = Bean.fromJson(resData);
    if (bean.success) {
      showToast("删除成功");
      //todo 刷新界面
      addresses.clear();
      loadAddress();
    } else {
      showToast(bean.msg);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

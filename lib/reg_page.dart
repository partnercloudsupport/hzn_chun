import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hzn/login_page.dart';
import 'package:hzn/model/code_bean.dart';
import 'package:hzn/model/reg_bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';
import 'package:tip_dialog/tip_dialog.dart';

/// 注册界面
class RegPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegWidget();
  }
}

class RegWidget extends State<RegPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final lockCodeController = TextEditingController();
  final pwdController = TextEditingController();
  final pwdConfirmController = TextEditingController();

  TipDialogController tipController;

  @override
  Widget build(BuildContext context) {
    return new TipDialogConnector(
      builder: (context, tipController) {
        this.tipController = tipController;
        return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: barColor,
              title:
              Text("注册", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 60),
                            child: _buildRegForm(),
                          )),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Text(
                        "已经有账号了？点击登录",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        startPage(context, LoginPage());
                      },
                    ))
              ],
            ));
      },
    );
  }

  Widget _buildRegForm() {
    return new Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Colors.grey.shade200,
        elevation: 5.0,
        child: new Container(
          margin: const EdgeInsets.all(10.0),
          height: 380.0,
          width: 270,
          child: Column(
            children: <Widget>[
              _buildPhoneTextField(phoneController),
              _buildCodeTextField(codeController),
              _buildLockCodeTextField(lockCodeController),
              _buildPasswordTextField(pwdController),
              _buildPasswordConfirmTextField(pwdConfirmController),
              _buildRegBtn(),
            ],
          ),
        ));
  }

  Widget _buildPhoneTextField(TextEditingController controller) {
    return new Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid) //没什么卵效果
                        ),
                    labelText: '请输入手机号码'),
                controller: controller,
                maxLines: 1,
                autocorrect: true,
                autofocus: true,
                obscureText: false,
                textAlign: TextAlign.center,
                //文本对齐方式
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                enabled: true, //是否禁用
              ),
            ),
            Container(
              height: 35,
              width: 60,
              margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
              child: new RaisedButton(
                onPressed: () {vaildCode();},
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                //按钮的背景颜色
                child: new Text(
                  '获取',
                  style: TextStyle(fontSize: 12),
                ),
                textColor: Colors.white,
                //文字的颜色
                textTheme: ButtonTextTheme.normal,
                //按钮的主题
                onHighlightChanged: (bool b) {
                  //水波纹高亮变化回调
                },
                highlightColor: Colors.grey,
                //点击或者toch控件高亮的时候显示在控件上面，水波纹下面的颜色
                splashColor: Colors.grey,
                //水波纹的颜色
                colorBrightness: Brightness.light,
                //按钮主题高亮
                elevation: 10.0,
                //按钮下面的阴影
                highlightElevation: 10.0,
                //高亮时候的阴影
                disabledElevation: 10.0, //按下的时候的阴影
//              shape:,//设置形状  LearnMaterial中有详解
              ),
            )
          ],
        ));
  }

  Widget _buildCodeTextField(TextEditingController controller) {
    return new Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        height: 50,
        child: TextField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 11.0,
                      style: BorderStyle.solid) //没什么卵效果
                  ),
              labelText: '请输入验证码'),

          controller: controller,
          maxLines: 1,
          //最大行数
          autocorrect: true,
          //是否自动更正
          autofocus: true,
          //是否自动对焦
          obscureText: false,
          //是否是密码
          textAlign: TextAlign.center,
          //文本对齐方式
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(6)],
          enabled: true, //是否禁用
        ));
  }

  Widget _buildLockCodeTextField(TextEditingController controller) {
    return new Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 11.0,
                            style: BorderStyle.solid) //没什么卵效果
                    ),
                    labelText: '请输入锁编码'),

                controller: controller,
                maxLines: 1,
                //最大行数
                autocorrect: true,
                //是否自动更正
                autofocus: true,
                //是否自动对焦
                obscureText: false,
                //是否是密码
                textAlign: TextAlign.center,
                //文本对齐方式
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
        )
       );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() =>
      lockCodeController.text = barcode
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

  Widget _buildPasswordTextField(TextEditingController controller) {
    return new Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        height: 50,
        child: TextField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 11.0,
                      style: BorderStyle.solid) //没什么卵效果
                  ),
              labelText: '请输入密码'),

          controller: controller,
          maxLines: 1,
          //最大行数
          autocorrect: true,
          //是否自动更正
          autofocus: true,
          //是否自动对焦
          obscureText: true,
          //是否是密码
          textAlign: TextAlign.center,
          //文本对齐方式
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
          keyboardType: TextInputType.text,
          enabled: true, //是否禁用
        ));
  }

  Widget _buildPasswordConfirmTextField(TextEditingController controller) {
    return new Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        height: 50,
        child: TextField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 11.0,
                      style: BorderStyle.solid) //没什么卵效果
                  ),
              labelText: '请重复输入密码'),

          controller: controller,
          maxLines: 1,
          //最大行数
          autocorrect: true,
          //是否自动更正
          autofocus: true,
          //是否自动对焦
          obscureText: true,
          //是否是密码
          textAlign: TextAlign.center,
          //文本对齐方式
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
          keyboardType: TextInputType.text,
          enabled: true, //是否禁用
        ));
  }

  Widget _buildRegBtn() {
    return new Container(
      height: 40,
      width: 300,
      margin: const EdgeInsets.fromLTRB(30, 20, 30, 8),
      child: new RaisedButton(
        onPressed: () {reg();},
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        //按钮的背景颜色
//        padding: EdgeInsets.fromLTRB(80,20,80,20.0),//按钮距离里面内容的内边距
        child: new Text(
          '注册',
          style: TextStyle(fontSize: 16),
        ),
        textColor: Colors.white,
        //文字的颜色
        textTheme: ButtonTextTheme.normal,
        //按钮的主题
        onHighlightChanged: (bool b) {
          //水波纹高亮变化回调
        },
        highlightColor: Colors.grey,
        //点击或者toch控件高亮的时候显示在控件上面，水波纹下面的颜色
        splashColor: Colors.grey,
        //水波纹的颜色
        colorBrightness: Brightness.light,
        //按钮主题高亮
        elevation: 10.0,
        //按钮下面的阴影
        highlightElevation: 10.0,
        //高亮时候的阴影
        disabledElevation: 10.0, //按下的时候的阴影
//              shape:,//设置形状  LearnMaterial中有详解
      ),
    );
  }

  //注册
  Future<Null> reg() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
    var phoneNum = phoneController.text;
    var code = codeController.text;
    var deviceNo = lockCodeController.text;
    var pwd = pwdController.text;
    var pwdConfirm = pwdConfirmController.text;

    if(phoneNum.isEmpty){
      showToast("账号不能为空");
      return;
    }

    if(code.isEmpty){
      showToast("验证码不能为空");
      return;
    }

//    if(deviceNo.isEmpty){
//      showToast("设备不能为空");
//      return;
//    }

    if(pwd.isEmpty){
      showToast("密码不能为空");
      return;
    }

    if(pwd != pwdConfirm){
      showToast("两次输入不一致");
      return;
    }


    FormData formData = new FormData.from({
      "code": "$code",
      "deviceNo": "$deviceNo",
      "repassword": "$pwdConfirm",
      "mobile": "$phoneNum",
      "password": "$pwd"
    });

    var resData = await HttpUtil.getInstance().post(I_REG, context,data: formData,tip:tipController);
    var regBean = RegBean.fromJson(resData);
    if (regBean.success) {
      showToast("注册成功");
      startPage(context,LoginPage());
    } else {
      showToast("注册失败,${regBean.msg}");
    }


//    PageStorage
//        .of(context)
//        .writeState(context, list, identifier: _dataIdentifier);
//    PageStorage
//        .of(context)
//        .writeState(context, _page, identifier: _pageIdentifier);
//    setState(() {});
  }


  /***获取验证码**/
  Future<Null> vaildCode() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
    var phoneNum = phoneController.text;

    FormData formData = new FormData.from({
      "mobile": "$phoneNum",
    });

    var resData = await HttpUtil.getInstance().post(I_VAILD_CODE,context, data: formData,tip:tipController);
    var codeBean = CodeBean.fromJson(resData);
    if (codeBean.success) {
      showToast("验证码已发送");
    } else {
      showToast("验证码发送失败,${codeBean.msg}");
    }


//    PageStorage
//        .of(context)
//        .writeState(context, list, identifier: _dataIdentifier);
//    PageStorage
//        .of(context)
//        .writeState(context, _page, identifier: _pageIdentifier);
//    setState(() {});
  }





}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hzn/main_page.dart';
import 'package:hzn/model/login_bean.dart';
import 'package:hzn/reg_page.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/sp_uitls.dart';
import 'package:hzn/utils/util.dart';
import 'package:tip_dialog/tip_dialog.dart';

/// 登陆界面
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginWidget();
  }
}

class LoginWidget extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  CancelToken _token = new CancelToken();

  final nameController = TextEditingController();
  final pwdController = TextEditingController();

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
              title: Text("登录",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: _buildLoginForm(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Text(
                        "新用户？点击这里注册",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        startPage(context, RegPage());
                      },
                    ))
              ],
            ));
      },
    );
  }

  Widget _buildLoginForm() {
    return new Material(
        borderRadius: BorderRadius.circular(10.0),
        shadowColor: Colors.grey.shade200,
        elevation: 5.0,
        child: new Container(
          margin: const EdgeInsets.all(10.0),
          height: 340.0,
          width: 270,
          child: Column(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: new CircleAvatar(
                  backgroundImage: _getImageProvider(""),
                  radius: 40.0,
                ),
              ),
              _buildNameTextField(nameController),
              _buildPwdTextField(pwdController),
              _buildForgetPwd(),
              _buildLoginBtn(),
            ],
          ),
        ));
  }

  ImageProvider _getImageProvider(String url){
    if(url.isEmpty){
      return AssetImage("images/ic_logo.png");
    }else{
      return NetworkImage(
          'https://free.modao.cc/uploads3/images/1505/15054581/raw_1512446140.jpeg');
    }
  }


  Widget _buildNameTextField(TextEditingController controller) {
    return new Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
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
              labelText: '请输入用户名'),
          controller: controller,
          maxLines: 1,
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

  Widget _buildForgetPwd() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
          child: new Offstage(
              offstage: true, //这里控制
              child: GestureDetector(
                child: Text(
                  "忘记密码？",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  //todo 跳转
                },
              )),
        ),
      ],
    );
  }

  Widget _buildPwdTextField(TextEditingController controller) {
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

  Widget _buildLoginBtn() {
    return new Container(
      height: 45,
      width: 300,
      margin: const EdgeInsets.fromLTRB(30, 30, 30, 10),
      child: new RaisedButton(
        onPressed: () {
          login();
        },
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        //按钮的背景颜色
//        padding: EdgeInsets.fromLTRB(80,20,80,20.0),//按钮距离里面内容的内边距
        child: new Text(
          '登录',
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

  //登录
  Future<Null> login() async {
    var phone = nameController.text;
    var pwd = pwdController.text;

    if (phone.isEmpty) {
      showToast("账号不能为空");
      return;
    }
    if (pwd.isEmpty) {
      showToast("密码不能为空");
      return;
    }

    FormData formData =
        new FormData.from({"mobile": "$phone", "password": "$pwd"});

    var resData = await HttpUtil.getInstance()
        .post(I_LOGIN,context, data: formData, tip: tipController);
    var loginBean = LoginBean.fromJson(resData);
    if (loginBean.success) {
      showToast("登录成功");

      SPUtil.putString(KEYS.token, loginBean.data);
      SPUtil.putBool(KEYS.login_state, true);

      startPage(context, MainPage());
    } else {
      SPUtil.putString(KEYS.token, "");
      SPUtil.putBool(KEYS.login_state, false);
      showToast("登录失败");
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

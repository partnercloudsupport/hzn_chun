import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hzn/model/bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/sp_uitls.dart';
import 'package:hzn/utils/util.dart';
import 'package:tip_dialog/tip_dialog.dart';

/// 登陆界面
class RePwdPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RePwdWidget();
  }
}

class RePwdWidget extends State<RePwdPage> {


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final oldPwdController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmPwdController = TextEditingController();

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
              Text("重置密码", style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            body: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Center(
                        child: Container(
                          margin: EdgeInsets.only(top:90),
                          child: _buildLoginForm(),
                        )),
                  ],
                ),
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
          height: 330.0,
          width: 270,
          child: Column(
            children: <Widget>[
              _buildOldPwdTextField(oldPwdController),
              _buildPwdTextField(pwdController),
              _buildConfirmPwdTextField(confirmPwdController),
              _buildSaveBtn(),
            ],
          ),
        ));
  }

  Widget _buildOldPwdTextField(TextEditingController controller) {
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
              labelText: '请输入旧密码'),
          controller: controller,
          maxLines: 1,
          autocorrect: true,
          autofocus: true,
          obscureText: true,
          textAlign: TextAlign.center,
          //文本对齐方式
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          enabled: true, //是否禁用
        ));
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
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          enabled: true, //是否禁用
        ));
  }

  Widget _buildConfirmPwdTextField(TextEditingController controller) {
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
              labelText: '请重复密码'),

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
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          enabled: true, //是否禁用
        ));
  }

  Widget _buildSaveBtn() {
    return new Container(
      height: 45,
      width: 300,
      margin: const EdgeInsets.fromLTRB(30, 50, 30, 10),
      child: new RaisedButton(
        onPressed: () {
          changePwd();
        },
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        //按钮的背景颜色
//        padding: EdgeInsets.fromLTRB(80,20,80,20.0),//按钮距离里面内容的内边距
        child: new Text(
          '保存',
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



  //修改密码
  Future<Null> changePwd() async {
    if (!networkEnable) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    var oldPwd = oldPwdController.text;
    var newPwd = pwdController.text;
    var rePwd = confirmPwdController.text;

    if(oldPwd.isEmpty){
      showToast("旧密码不能为空");
      return;
    }
    if(newPwd.isEmpty){
      showToast("新密码不能为空");
      return;
    }

    if(newPwd != rePwd){
      showToast("两次输入不一致");
      return;
    }


    FormData formData = new FormData.from({
      "oldPassWord": "$oldPwd",
      "newPassWord": "$newPwd"
    });

    var resData = await HttpUtil.getInstance().post(I_CHANGE_PWD,context, data: formData,tip: tipController);
    var bean = Bean.fromJson(resData);
    if (bean.success) {
      showToast("修改成功");

      Navigator.of(context).pop();
    } else {
      showToast("修改失败，${bean.msg}");
    }
  }






}

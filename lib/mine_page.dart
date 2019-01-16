import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hzn/login_page.dart';
import 'package:hzn/mine_setting.dart';
import 'package:hzn/model/logout_bean.dart';
import 'package:hzn/model/module_bean.dart';
import 'package:hzn/model/upload_bean.dart';
import 'package:hzn/model/user_info_bean.dart';
import 'package:hzn/order_page.dart';
import 'package:hzn/repwd_page.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/sp_uitls.dart';
import 'package:hzn/utils/util.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:image_picker/image_picker.dart';




class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Page();
  }
}

class Page extends State<MinePage> with AutomaticKeepAliveClientMixin{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TipDialogController tipController;

  var userName = "";
  var avatar = "";

  var avatarBg = "";


  @override
  void initState() {
    loadUserInfo();
    getMoudleId("100001");
  }

  @override
  void didUpdateWidget(MinePage oldWidget) {
    loadUserInfo();
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
    return new Scaffold(appBar: buildAppBar(context), body: buildBody(context));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: barColor,
        title: const Text(
      '我的',
      textAlign: TextAlign.center,
    ));
  }

  Widget _buildAvatarBg(String picUrl){
    if(picUrl!= null && picUrl.isNotEmpty){
      return Image.network(
        avatarBg,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: 200,
      );
    }else{
      return Image.asset(
        "images/food001.png",
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: 200,
      );
    }
  }


  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  _buildAvatarBg(this.avatarBg),
                  BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: new Container(
                      color: Colors.white.withOpacity(0.1),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: new ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: "images/ic_default.png",
                            //预览图
                            fit: BoxFit.cover,
                            image: avatar,
                            width: 90.0,
                            height: 90.0,
                          )),
                      onTap: (){
                        // todo 选择图片
                       showBottomDialog(context);
                      },
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        userName,
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              _buildOrders(context),
              _buildDivider(context),
              _buildSetting(context),
              _buildDivider(context),
            ],
          ),
        ),
        _buildLogOutBtn(),
      ],
    );
  }

  Widget _buildOrders(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 15),
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              new Icon(Icons.reorder),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "我的订单",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: new Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 20,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return new OrderPage();
          }));
        },
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.grey,
    );
  }


  void showBottomDialog(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context)
    {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.photo_camera),
            title: new Text("相机"),
            onTap: () async {
              getImage(ImageSource.camera).then((File file){
                if(file!= null){
                  uploadImage(file);
                }
              });
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.grey,),
          new ListTile(
            leading: new Icon(Icons.photo_library),
            title: new Text("相册"),
            onTap: () async {
              getImage(ImageSource.gallery).then((File file){
                if(file!= null){
                  uploadImage(file);
                }

              });

              Navigator.pop(context);
            },
          ),
        ],
      );
    }
    );
  }

  Widget _buildSetting(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 15),
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              new Icon(Icons.settings),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "设置",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: new Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 20,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return new MineSettingPage(this.userName);
          }));
        },
      ),
    );
  }

  Widget _buildLogOutBtn() {
    return new Container(
      height: 45,
      width: 300,
      margin: const EdgeInsets.fromLTRB(30, 50, 30, 30),
      child: new RaisedButton(
        onPressed: () {
          logout();
        },
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        //按钮的背景颜色
//        padding: EdgeInsets.fromLTRB(80,20,80,20.0),//按钮距离里面内容的内边距
        child: new Text(
          '退出',
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


  Future<File> getImage( ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source,maxHeight: 400,maxWidth: 400);
    return image;
  }


  Future<Null> loadUserInfo() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
    var resData = await HttpUtil.getInstance().get(I_USER_INFO,context);
    var userInfoBean = UserInfoBean.fromJson(resData);
    if (userInfoBean.success) {
      if(userInfoBean.data != null){
        setState(() {
          this.userName = userInfoBean.data.realName;
          this.avatar = userInfoBean.data.avatar;
        });
      }

    }
  }

  void uploadImage(File file) async {

    FormData formData = new FormData.from({
    "file": new UploadFileInfo(file, "${file.path.substring(file.path.lastIndexOf("/"),file.path.length)}")
    });

    var resData = await HttpUtil.getInstance().post(I_FILE_UPLOAD,context, data: formData,tip:tipController);

    var uploadBean = UploadBean.fromJson(resData);
    if (uploadBean.success) {
      if (uploadBean.data != null) {

        setState(() {
          this.avatar = uploadBean.data;
        });

      }else{
        showToast("头像上传失败");
      }
    }
  }

  //退出
  Future<Null> logout() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({});


    var resData = await HttpUtil.getInstance().post(I_LOGOUT,context, data: formData,tip:tipController);
    var logoutBean = LogoutBean.fromJson(resData);


    //前端不管后台返回的是什么内容，直接退出
    SPUtil.putString(KEYS.token, "");
    SPUtil.putBool(KEYS.login_state, false);
    startPage(context, LoginPage());
//    if (logoutBean.success) {
//
//    } else {
//      showToast("${logoutBean.msg}");
//    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



//退出
  Future<Null> getMoudleId(String moduleId) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({});

    var url = I_MOUDLE;
    url = url.replaceAll("{moduleId}", moduleId);

    var resData = await HttpUtil.getInstance().post(url,context, data: formData,tip:tipController);
    var moduleBean = ModuleBean.fromJson(resData);

    if(moduleBean.data != null && moduleBean.data.length > 0 ){
      Module module = moduleBean.data[0];
      setState(() {
        if(module.picUrl != null && module.picUrl.isNotEmpty){
          this.avatarBg = module.picUrl;
        }
      });
    }



  }



}

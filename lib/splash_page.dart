import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hzn/login_page.dart';
import 'package:hzn/main_page.dart';
import 'package:hzn/model/splashl_bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/sp_uitls.dart';
import 'package:hzn/utils/util.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  var isLogin = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String picUrl = "";
  String urlDirect = "";
  String title = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              child: ConstrainedBox(
                child: Image.asset("images/ic_splash.png", fit: BoxFit.cover),
                constraints: new BoxConstraints.expand(),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(bottom: 160),
            child: _getSplashImage(),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    countDown();
    loadSplash();
  }

  Widget _getSplashImage() {
    if (picUrl.isEmpty) {
      return Image.asset("images/ic_empty.png", fit: BoxFit.fill);
    } else {
      return Image.network(picUrl, fit: BoxFit.fill);
    }
  }

// 倒计时
  void countDown() {
    var _duration = new Duration(seconds: 4);
    new Future.delayed(_duration, go2HomePage);
  }

  go2HomePage() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    if (!SPUtil.isInitialized()) {
      SPUtil.getInstance().then((spUtil) {
        jump();
      });
    } else {
      jump();
    }
  }

  void jump() {
    var logined = SPUtil.getBool(KEYS.login_state);
    if (logined == null) {
      logined = false;
    }
    isLogin = logined;
    if (isLogin) {
      startPage(context, MainPage());
    } else {
      startPage(context, LoginPage());
    }
  }

  Future<Null> loadSplash() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
    var resData = await HttpUtil.getInstance().get(I_SPLASH,context);
    var splashlBean = SplashBean.fromJson(resData);
    if (splashlBean.success) {
      if (splashlBean.data != null && splashlBean.data.length > 0) {
        setState(() {
          this.picUrl = splashlBean.data.elementAt(0).picUrl;
          this.urlDirect = splashlBean.data.elementAt(0).linkUrl;
          this.title = splashlBean.data.elementAt(0).title;
        });
      }
    }
  }
}

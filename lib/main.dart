import 'dart:io';
import 'package:hzn/utils/sql_util.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hzn/login_page.dart';
import 'package:hzn/main_page.dart';
import 'package:hzn/splash_page.dart';
import 'package:hzn/reg_page.dart';
import 'package:hzn/utils/sp_uitls.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());

    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

  });
}




class MyApp extends StatelessWidget {


  void init() async {
    await SPUtil.getInstance(); //等待Sp初始化完成
  }

  @override
  Widget build(BuildContext context) {
    init();
    return new TipDialogContainer(
        child: new MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: new ThemeData(

                  primaryColorBrightness: Brightness.dark,
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                platform: TargetPlatform.iOS),
            home: SplashPage(), //启动
            routes: {
              '/main': (context) => MainPage(),
              '/login':(context)=>LoginPage(),
            }));
  }

}

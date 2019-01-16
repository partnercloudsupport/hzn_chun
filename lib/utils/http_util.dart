import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hzn/login_page.dart';
import 'package:hzn/utils/sp_uitls.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hzn/utils/util.dart';


class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  Options options;

  static HttpUtil getInstance() {
    print('getInstance');
    if (instance == null) {
      instance = new HttpUtil();
    }
    return instance;
  }
  

  HttpUtil() {
    print('dio赋值');
    // 或者通过传递一个 `options`来创建dio实例
    options = Options(
      // 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
      ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
      ///  注意: 这并不是接收数据的总时限.
      receiveTimeout: 3000,
      baseUrl: "http://api.huozhiniao.cn",
    );
    dio = new Dio(options);
  }

  get(url, context,{data, options, cancelToken,tip}) async {
    dio.options.headers={"fbtoken":SPUtil.getString(KEYS.token)};
    print('get请求启动! url：${dio.options.baseUrl}$url ,body: $data , header: ${dio.options.headers}');
    Response response;
    try {
      if(tip != null){
        showLoading(tip);
      }

      response = await dio.get(
        url,
        data: data,
        cancelToken: cancelToken,
      );
      print('get请求成功!response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      }
      print('get请求发生错误：$e');
    }finally{
      if(tip != null){
        hideLoading(tip);
      }

    }

    if(response != null && response.data!= null && response.data.toString().contains("777777")){
      tokenExpired(context);
      showToast("登录过期，请重新登录");
    }

    return response.data;
  }

  post(url,context, {data, options, cancelToken ,tip}) async {
    dio.options.headers={"fbtoken":SPUtil.getString(KEYS.token)};
    print('post请求启动! url：${dio.options.baseUrl}$url ,body: $data , header: ${dio.options.headers}');
    Response response;
    try {
      if(tip != null){
        showLoading(tip);
      }

      response = await dio.post(
        url,
        data: data,
        cancelToken: cancelToken,
      );
      print('post请求成功!response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post请求取消! ' + e.message);
      }
      print('post请求发生错误：$e');
    }finally{
      if(tip != null){
        hideLoading(tip);
      }
    }
    if(response.data!= null && response.data.toString().contains("777777")){
      tokenExpired(context);
      showToast("登录过期，请重新登录");
    }

    return response.data;
  }




  //返回777777
  void tokenExpired(BuildContext context){
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new LoginPage();
        }));
  }



//  showLoading(){
//    SpinKitFadingFour(
//      itemBuilder: (_, int index) {
//        return DecoratedBox(
//          decoration: BoxDecoration(
//            color: index.isEven ? Colors.red : Colors.green,
//          ),
//        );
//      },
//    );
//  }


}

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tip_dialog/tip_dialog.dart';


var barColor = Color.fromARGB(255,22, 88, 167);
var lightBlue = Color.fromARGB(255,70, 147, 240);


showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white);
}

String formatTime(int mills) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(mills);
  var wholeStr = dateTime.toLocal().toString();
  return wholeStr.substring(0, wholeStr.lastIndexOf("."));
}

Future<bool> isNetWorkEnable() async{
  var connectivityResult = await (new Connectivity().checkConnectivity());
  return new Future<bool>(()=>connectivityResult!= ConnectivityResult.none);
}


void showLoading(TipDialogController tipController) {
  if (tipController != null) {
    tipController.show(
        tipDialog: new TipDialog(type: TipDialogType.LOADING, tip: "正在加载..."),
        isAutoDismiss: false);
  }
}

void startPage(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}

void hideLoading(TipDialogController tipController) {
  if (tipController != null) {
    tipController.dismiss();
  }
}

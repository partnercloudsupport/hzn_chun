import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hzn/model/add_order_bean.dart';
import 'package:hzn/model/pay_info_bean.dart';
import 'package:hzn/model/product_detail_bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:tip_dialog/tip_dialog.dart';



class ProductDetailPage extends StatefulWidget {
  String productId;
  String productName = "";
  String productPic = "";

  ProductDetailPage(this.productId, this.productName, this.productPic);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductDetailWdiget(productId, productName, productPic);
  }
}

class ProductDetailWdiget extends State<ProductDetailPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final numController = TextEditingController();

  String productId = "";
  String productName = "";
  String productPic = "";

  ProductDetail productDetail;

  ProductDetailWdiget(this.productId, this.productName, this.productPic);
  TipDialogController tipController;
  //下单按钮是否可用
  var enable = true;

  @override
  void initState() {
    loadProductDetail();
  }

  Widget _buildBtnText(){
    if(enable){
      return new Text('下单',style: TextStyle(fontSize: 18),);
    }else{
      return new Text( '已下单', style: TextStyle(fontSize: 18),);
    }
  }

  Color _buildBtnColor(){
    if(enable){
      return Colors.black;
    }else{
      return Colors.grey;
    }
  }


  Widget getImage(String picurl) {
    if (picurl== null || picurl.isEmpty) {
      return Image.asset("images/ic_default.png", fit: BoxFit.cover,
        height: 190,
        width: MediaQuery.of(context).size.width,);
    } else {
      if (picurl.contains("http")) {
        return Image.network(
            picurl,
            height: 190,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover);
      }else{
        return Image.asset("images/ic_default.png", fit: BoxFit.cover,
          height: 190,
          width: MediaQuery.of(context).size.width,);
      }

    }
  }


  Widget layout(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title:Text("$productName",style: TextStyle(fontSize: 18,color: Colors.white),),
      ),

      body:new LayoutBuilder(
          builder: (BuildContext cotext, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: new ConstrainedBox(
                constraints:
                new BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: new IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      getImage(productPic),
                      Expanded(
                        flex: 1,
                        child:_buildTest(),
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: new RaisedButton(

                            onPressed: () {
                              if(enable){
                                showAlertDialog(context);
                              }
                            },
                            color: _buildBtnColor(),
                            padding: EdgeInsets.only(
                                left: 120.0, right: 120, top: 10, bottom: 10),
                            child: _buildBtnText(),
                            textColor: Colors.white,
                            textTheme: ButtonTextTheme.normal,
                            onHighlightChanged: (bool b) {},
                            disabledTextColor: Colors.black54,
                            disabledColor: Colors.black54,
                            highlightColor: Colors.black26,
                            splashColor: Colors.white,
                            colorBrightness: Brightness.light,
                            elevation: 10.0,
                            highlightElevation: 10.0,
                            disabledElevation: 10.0, //按下的时候的阴影
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          })
    );
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

  Widget _buildTest() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 40,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 5, right: 5),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "现价：",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        Text(
                          "¥ ${productDetail==null?"":productDetail.salePrice}",
                          style:
                              TextStyle(fontSize: 18, color: Colors.deepOrange),
                        )
                      ],
                    ),
                  )),
//              Expanded(
//                  flex: 1,
//                  child: Padding(
//                    padding: EdgeInsets.only(right: 30, top: 5, left: 5),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        Text(
//                          "原价：",
//                          style: TextStyle(fontSize: 16, color: Colors.black87),
//                        ),
//                        Text(
//                          "${productDetail==null?"":productDetail.originalPrice}",
//                          style:
//                              TextStyle(fontSize: 16, color: Colors.deepOrange),
//                        )
//                      ],
//                    ),
//                  ))
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        Padding(
            padding: EdgeInsets.only(left: 30, top: 5, right: 30),
            child: Container(
              width: double.infinity,
              child: Text(
                "产品详情:",
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.left,
              ),
            )),
        Padding(
            padding: EdgeInsets.only(left: 30, top: 5, right: 30),
            child: Container(
              width: double.infinity,
              child: Text(
                "${productDetail==null?"":productDetail.goodsDescribe}",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.left,
              ),
            )),
      ],
    ));
  }


  //加载产品数据
  Future<Null> loadProductDetail() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
    FormData formData = new FormData.from({"id": productId});
    var resData =
        await HttpUtil.getInstance().get(I_PRODUCT_DETAIL,context, data: formData);
    var productDetailBean = ProductDetailBean.fromJson(resData);
    if (productDetailBean.success) {
      if (productDetailBean.data != null) {
        setState(() {
          productDetail = productDetailBean.data;
        });
      }
    }
  }

  Widget _buildNumField(TextEditingController controller) {
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
              labelText: '请输入购买数量'),
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


  void showAlertDialog(BuildContext context) {
    numController.text = "1";
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text(
            '购买数量',
          ),
          content: _buildNumField(numController),
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
                var num = numController.text;
                addOrder(num);
              },
            ),
          ],
        );
      },
    );
  }


  //下单
  Future<Null> addOrder(String num) async {
    if (!networkEnable) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({
    "goodsId":"$productId",
    "num":"$num"
    });

    var resData = await HttpUtil.getInstance().post(I_ADD_ORDER, context,data: formData,tip:tipController);
    var addOrderBean = AddOrderBean.fromJson(resData);
    if(addOrderBean.success){
      showToast("下单成功");
      setState(() {
        enable = false;
      });

      pay(addOrderBean.data.id.toString());

      //todo 下单成功，开始付款    checkPermission
//      bool res = await SimplePermissions.checkPermission(Permission.ReadPhoneState);
//      if(res){
//        pay(addOrderBean.data.id.toString());
//      }else{
//        final res = await SimplePermissions.requestPermission(Permission.ReadPhoneState);
//        if(res == PermissionStatus.authorized){
//
//        }
//      }
    }else{
      showToast("${addOrderBean.msg}");
    }
  }



  //下单
  Future<Null> pay(String orderId) async {
    if (!networkEnable) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({
      "orderId":"$orderId",
      "payType":"1" //0 : 微信 1:支付宝
    });

    var resData = await HttpUtil.getInstance().post(I_PAY,context, data: formData);
    var payInfoBean = PayInfoBean.fromJson(resData);
    if(payInfoBean.success){
      var orderString = payInfoBean.data.orderString;
      //{resultStatus: 9000, result: {"alipay_trade_app_pay_response":{"code":"10000","msg":"Success","app_id":"2018123062717469","auth_app_id":"2018123062717469","charset":"utf-8","timestamp":"2019-01-01 20:56:03","out_trade_no":"20190101205539-6-6","total_amount":"1.00","trade_no":"2019010122001455960568822225","seller_id":"2088002706311626"},"sign":"DGICfmhKlNVYefiA1Q4YPnZDOYJdS15h6rkzf/DUZjVL0zl+5ZXp+wuiRLaNjv+LzEmfKkt4oKhDeLUgYgziFqB8HykKX7buclvjtBHkGugb9nKPsqDlvfOV3tJsalrX89D3MYPYp9qAgSWJ6+vOPaYm5LdHKtpGPWJxgUPQayY3uN8NT0N3X9Z487DYFSIrII4ubf/+MOer9N8g68iCO2fYUdAOYE9RJTR8zNTWU0er9MJXQFLI5qOMXkKEfXZJwpCYrtUnjVvmvjVs6NSkoto5PgNpqPpZLyI2WenG4z9pbbkEXlgVJGMqQ4ttTmWoB811gF9ZuMHaxggk+Q08sg==","sign_type":"RSA2"}, memo: }
      Map<dynamic,dynamic> result = await FlutterAlipay.pay(orderString);
      if(result.containsKey("resultStatus")){
        var resultStatus = result["resultStatus"].toString();
        if(resultStatus == "9000"){
          showToast("支付成功");
          Navigator.of(context).pop(true);
        }else{
          showToast("支付失败");
        }
      }else{
        showToast("支付失败");
      }


    }else{
      showToast("${payInfoBean.msg}");
    }
  }







}

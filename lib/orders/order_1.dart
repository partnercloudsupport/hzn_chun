import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hzn/model/bean.dart';
import 'package:hzn/model/orders_bean.dart';
import 'package:hzn/model/pay_info_bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';

class OrderFirstPage extends StatefulWidget {
  var state;

  OrderFirstPage(this.state);

  @override
  State<StatefulWidget> createState() {
    return new OrderFirstWidget(state);
  }
}

class OrderFirstWidget extends State<OrderFirstPage> {
  var state;
  var pageNum = 1;

  OrderFirstWidget(this.state);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var orders = List<OrderDetail>();
  var itemCount = 0;

  @override
  void initState() {
    loadOrderData(state, pageNum);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTabBarView(context);
  }

  Widget _buildTabBarView(BuildContext context) {
    GlobalKey<EasyRefreshState> _easyRefreshKey =
        new GlobalKey<EasyRefreshState>();

    GlobalKey<RefreshHeaderState> _headerKey =
        new GlobalKey<RefreshHeaderState>();
    GlobalKey<RefreshFooterState> _footerKey =
        new GlobalKey<RefreshFooterState>();

    return EasyRefresh(
      refreshHeader: MaterialHeader(
        key: _headerKey,
      ),
      refreshFooter: MaterialFooter(
        key: _footerKey,
      ),
      child: ListView(
        children: orders.map((OrderDetail detail) {
          return Column(
            children: <Widget>[
              new Slidable(
                delegate: new SlidableDrawerDelegate(),
                actionExtentRatio: 0.25,
                child: _buildItem(context, detail),
                secondaryActions: <Widget>[
                  new IconSlideAction(
                    caption: '删除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => showAlertDialog(context, detail.id.toString()),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              )
            ],
          );
        }).toList(),
      ),
      onRefresh: () async {
        pageNum = 0;
        loadOrderData(state, pageNum);
      },
      loadMore: () async {
        if (orders != null && orders.length >= itemCount) {
          showToast("没有更多数据...");
          return;
        }
        pageNum++;
        loadOrderData(state, pageNum);
      },
    );
  }

  void showAlertDialog(BuildContext context, String orderNo) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '删除订单',
          ),
          content: Text("确定删除这个订单吗？"),
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
                removeOrder(orderNo);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemContent(BuildContext context, OrderDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            new Text(
              "订单号：",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            Expanded(
              flex: 1,
              child: new Text(
                detail.orderNo,
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            new Text(
              "总金额:",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            new Text(
              "¥ ${detail.money.toString()}",
              maxLines: 1,
              style: TextStyle(fontSize: 16, color: Colors.deepOrangeAccent),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: new Text(
                  detail.goodsName,
                  maxLines: 2,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              new Text(
                formatTime(detail.createTime),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "单价:",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              new Text(
                "¥ ${detail.price.toString()}",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
              ),
              new Text(
                "数量:",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              new Text(
                detail.num.toString(),
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Container(
                width: 70,
                height: 30,
                child: new RaisedButton(
                  onPressed: () {
                    pay(detail.id.toString());
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  //按钮的背景颜色
                  child: new Text(
                    '支付',
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, OrderDetail detail) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
//          return new OrderDetailPage();
//        }));
      },
      child: Container(
        height: 105,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: new Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: _buildItemContent(context, detail),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> removeOrder(String orderNo) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({
      "id": "$orderNo",
    });

    var resData =
        await HttpUtil.getInstance().get(I_DEL_ORDER, context, data: formData);
    var bean = Bean.fromJson(resData);
    if (bean.success) {
      setState(() {
        orders.removeWhere((OrderDetail detail){
          return detail.id.toString() == orderNo;
        });
      });
    } else {
      showToast(bean.msg);
    }

  }

  //加载产品数据
  Future<Null> loadOrderData(int state, int pageNum) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({
      "status": "$state", //订单状态  0:已下单 1已付款 2已发货 3已完成
      "pageNum": "$pageNum", // 页码
      "pageSize": "20" //页码大小
    });

    var resData =
        await HttpUtil.getInstance().get(I_ORDER_LIST, context, data: formData);
    var ordersBean = OrdersBean.fromJson(resData);
    if (ordersBean.success) {
      itemCount = ordersBean.data.count;

      setState(() {
        if (pageNum == 0) {
          orders.clear();
          orders = ordersBean.data.details;
        } else {
          orders.addAll(ordersBean.data.details);
        }
      });
    } else {
      showToast(ordersBean.msg);
    }
  }

  //下单
  Future<Null> pay(String orderId) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({
      "orderId": "$orderId",
      "payType": "1" //0 : 微信 1:支付宝
    });

    var resData =
        await HttpUtil.getInstance().post(I_PAY, context, data: formData);
    var payInfoBean = PayInfoBean.fromJson(resData);
    if (payInfoBean.success) {
      var orderString = payInfoBean.data.orderString;
      Map<dynamic, dynamic> result = await FlutterAlipay.pay(orderString);
      if (result.containsKey("resultStatus")) {
        var resultStatus = result["resultStatus"].toString();
        if (resultStatus == "9000") {
          showToast("支付成功");
          Navigator.of(context).pop(true);
        } else {
          showToast("支付失败");
        }
      } else {
        showToast("支付失败");
      }
    } else {
      showToast("${payInfoBean.msg}");
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:hzn/model/orders_bean.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';

import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';




class OrderThreePage extends StatefulWidget {
  var state;

  OrderThreePage(this.state);

  @override
  State<StatefulWidget> createState() {
    return new OrderThreeWidget(state);
  }
}

class OrderThreeWidget extends State<OrderThreePage> {
  var state;
  var pageNum = 0;

  OrderThreeWidget(this.state);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var itemCount = 0;

  var orders = List<OrderDetail>();

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
    GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
    GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();




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
              _buildItem(context, detail),
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
        if(orders != null && orders.length >= itemCount){
          showToast("没有更多数据...");
          return;
        }
        pageNum++;
        loadOrderData(state, pageNum);
      },
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
        height: 95,
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
                  child: Text(
                    "已发货",
                    style:
                        TextStyle(fontSize: 14, color: Colors.green),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  //加载产品数据
  Future<Null> loadOrderData(int state, int pageNum) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    FormData formData = new FormData.from({
      "status": "$state", //订单状态  0:已下单1已付款2已发货3已完成
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
}

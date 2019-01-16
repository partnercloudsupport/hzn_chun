import 'package:flutter/material.dart';
import 'package:hzn/orders/order_1.dart';
import 'package:hzn/orders/order_2.dart';
import 'package:hzn/orders/order_3.dart';
import 'package:hzn/orders/order_4.dart';
import 'package:hzn/utils/util.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderWidget();
  }
}

class OrderWidget extends State<OrderPage> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(text: '待付款'),
    new Tab(text: '已付款'),
    new Tab(text: '已发货'),
    new Tab(text: '已完成')
  ];

  var _orderList = [
//      new GirlPage(key: PageStorageKey<String>('girl'),random: false),
    new OrderFirstPage(0),
    new OrderSecondPage(1),
    new OrderThreePage(2),
    new OrderFourPage(3),
  ];

  TabController mTabController;

  @override
  void initState() {
    super.initState();
    mTabController = TabController(
      length: myTabs.length,
      vsync: this,
    );
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(
      length: myTabs.length,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: barColor,
          title: Text(
            "我的订单",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          bottom: new TabBar(
            tabs: myTabs,
            isScrollable: true,
            controller: mTabController,
          ),
        ),
        body: new TabBarView(
          children: myTabs.map((Tab tab) {
            var index = 0;
            if(tab.text == myTabs.elementAt(0).text){
              index = 0;
            }else if(tab.text == myTabs.elementAt(1).text){
              index = 1;
            }else if(tab.text == myTabs.elementAt(2).text){
              index = 2;
            }else if(tab.text == myTabs.elementAt(3).text){
              index = 3;
            }

            return _orderList.elementAt(index);
          }).toList(),
          controller: mTabController,
        ),
      ),
    );
  }




  @override
  void dispose() {
    mTabController .dispose();
    super.dispose();
  }

}

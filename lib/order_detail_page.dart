import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderDetailWidget();
  }

}

class OrderDetailWidget extends State<OrderDetailPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBody(),
    );
  }



  Widget _buildBody(){
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text('SliverAppBar'),
          backgroundColor: Theme.of(context).accentColor,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset('images/food001.png', fit: BoxFit.cover),
          ),
          // floating: floating,
          // snap: snap,
          // pinned: pinned,
        ),

      ],
    );
  }




}
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hzn/model/banner_bean.dart';
import 'package:hzn/model/product_bean.dart';
import 'package:hzn/product_detail.dart';
import 'package:hzn/utils/http_util.dart';
import 'package:hzn/utils/options.dart';
import 'package:hzn/utils/util.dart';
import 'package:hzn/web_view_page.dart';
import 'package:hzn/widget/CarouselWithIndicator.dart';
import 'package:tip_dialog/tip_dialog.dart';


import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new Page();
  }
}

class Page extends State<HomePage> with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TipDialogController tipController;
  var _banner = new List<BannerData>();
  var _products = new List();

  int _current = 0;


  @override
  void initState() {
    loadBannerData();
    loadProductData();
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
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: buildAppBar(context),
        body: EasyRefresh(
          refreshHeader: MaterialHeader(
            key: _headerKey,
          ),
          refreshFooter: MaterialFooter(
            key: _footerKey,
          ),
          key: _easyRefreshKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _buildHeader(context),
              ),
              new SliverGrid.count(
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                //      横轴数量 这里的横轴就是x轴 因为方向是垂直的时候 主轴是垂直的
                crossAxisCount: 2,
                children: _buildItems(context),
                childAspectRatio: 0.6,
              ),
            ],
          ),
          onRefresh: () async {
            loadBannerData();
            loadProductData();
          },
          loadMore: () async {},
        ));
  }

  Widget _buildHeader(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: _buildSlider(context),
    );
  }

  List<Widget> _buildImages(){
    if(_banner!= null && _banner.length>0){
      return _banner.map((BannerData bannerData){
        return new Builder(
          builder:  (BuildContext context) {
            return GestureDetector(
              onTap: (){
                onBannerClick(context, bannerData.linkUrl, bannerData.title);
              },
              child: Image.network(bannerData.picUrl, fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,),
            );
          },);
      }).toList();
    }else{
      List<Widget> imgs = List();
      imgs.add(ConstrainedBox(
        child: Image.asset(
            "images/ic_default.png",
            fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        constraints: new BoxConstraints.expand(),
      ));
      return imgs;
    }
  }

  void onBannerClick(BuildContext context, String linkUrl, String title) {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new WebViewPage(
          linkUrl,
          title,
        ); //link,title为需要传递的参数
      },
    ));
  }


  Widget _buildSlider(BuildContext context) {
    return Stack(
        children: [
          CarouselSlider(
            items: _buildImages(),
            viewportFraction: 1.0,
            initialPage: 0,
            height: 400,
            reverse: false,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            aspectRatio: 3.0,
            updateCallback: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 5.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(_banner, (index, url) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? Color.fromRGBO(255, 255, 255, 0.9) : Color.fromRGBO(0, 0, 0, 0.9)
                    ),
                  );
                }),
              )
          )
        ]
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    if(list!=null){
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }

    }

    return result;
  }





  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: barColor,
      title: Text('商城', textAlign: TextAlign.center),
//    leading: Icon(Icons.menu)
    );
  }

  List _buildItems(BuildContext context) {
    var items = List<Widget>();
    for (var i = 0; i < _products.length; i++) {
      items.add(GestureDetector(
        onTap: () {
          onProductClick(_products.elementAt(i));
        },
        child: _buildItem(context, _products.elementAt(i)),
      ));
    }
    return items;
  }

  void onProductClick(Product product) {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new ProductDetailPage(product.id.toString(), product.goodsName,
            product.url); //link,title为需要传递的参数
      },
    ));
  }

  Widget getImage(String picurl) {
    if (picurl== null || picurl.isEmpty) {
      return ConstrainedBox(
        child: Image.asset("images/ic_default.png", fit: BoxFit.cover),
        constraints: new BoxConstraints.expand(),
      );
    } else {
      if (picurl.contains("http")) {
        return ConstrainedBox(
          child: Image.network(picurl, fit: BoxFit.cover),
          constraints: new BoxConstraints.expand(),
        );
      }else{
        return ConstrainedBox(
          child: Image.asset("images/ic_default.png", fit: BoxFit.cover),
          constraints: new BoxConstraints.expand(),
        );
      }

    }
  }

  Widget _buildItem(BuildContext context, Product product) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ClipRRect(
                child: getImage(product.url),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5, left: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          product.goodsName,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      new Offstage(
                        child: Icon(Icons.favorite_border, color: Colors.grey, size: 16),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0, left: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      product.goodsDescribe,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }



//  Widget _buildItem(BuildContext context, Product product) {
//    return Card(
//      child: Padding(
//        padding: EdgeInsets.all(10.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Expanded(
//              flex: 15,
//              child: ClipRRect(
//                child: getImage(product.url),
//                borderRadius: BorderRadius.all(Radius.circular(5.0)),
//              ),
//            ),
//            Expanded(
//                flex: 1,
//                child: Container(
//                  margin: EdgeInsets.only(top: 5, left: 5),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Text(
//                          product.goodsName,
//                          style: TextStyle(fontSize: 16, color: Colors.black87),
//                          maxLines: 1,
//                          overflow: TextOverflow.ellipsis,
//                        ),
//                      ),
//                      new Offstage(
//                        child: Icon(Icons.favorite_border, color: Colors.grey, size: 16),
//                      )
//                    ],
//                  ),
//                )),
//            Expanded(
//              flex: 4,
//              child: Padding(
//                padding: EdgeInsets.only(top: 15.0, left: 5),
//                child: Align(
//                  alignment: Alignment.topLeft,
//                  child: Text(
//                    product.goodsDescribe,
//                    style: TextStyle(fontSize: 14, color: Colors.grey),
//                    textAlign: TextAlign.left,
//                    maxLines: 2,
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  //加载banner数据
  Future<Null> loadBannerData() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    var resData = await HttpUtil.getInstance().get(I_BANNER,context);
    var bannerBean = BannerBean.fromJson(resData);
    if (bannerBean.success) {
      setState(() {
        _banner = bannerBean.data;
      });
    }
  }

  //加载产品数据
  Future<Null> loadProductData() async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }

    var resData =
        await HttpUtil.getInstance().get(I_PRODUCTS,context, tip: tipController);
    var productBean = ProductBean.fromJson(resData);
    if (productBean.success) {
      setState(() {
        _products = productBean.data.products;
      });
    }
  }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

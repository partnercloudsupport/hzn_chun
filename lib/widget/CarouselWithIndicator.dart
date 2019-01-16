
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hzn/model/banner_bean.dart';
import 'package:hzn/web_view_page.dart';


class CarouselWithIndicator extends StatefulWidget {

  List<BannerData> banners;


  CarouselWithIndicator(List<BannerData> banners){
    this.banners = banners;
  }
  
  @override
  CarouselWithIndicatorState createState() => CarouselWithIndicatorState(banners);
}

class CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  List<BannerData> banners;

  CarouselWithIndicatorState(List<BannerData> banners){
    this.banners = banners;
  }

  List<Widget> _buildImages(){
    if(banners!= null && banners.length>0){
      return banners.map((BannerData bannerData){
        return new Builder(
          builder:  (BuildContext context) {
            return GestureDetector(
              onTap: (){
                onBannerClick(context, bannerData.linkUrl, bannerData.title);
              },
              child: Image.network(bannerData.picUrl, fit: BoxFit.fill),
            );
          },);
        }).toList();
    }else{
      List<Widget> imgs = List();
      imgs.add(ConstrainedBox(
        child: Image.asset(
            "images/ic_default.png",
            fit: BoxFit.cover
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
  
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          CarouselSlider(
            items: _buildImages(),
            viewportFraction: 0.8,
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
                children: map<Widget>(banners, (index, url) {
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


}
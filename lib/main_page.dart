import 'package:flutter/material.dart';
import 'package:hzn/device_page.dart';
import 'package:hzn/home_page.dart';
import 'package:hzn/mine_page.dart';
import 'package:hzn/utils/sql_util.dart';
import 'package:hzn/utils/util.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, home: new MainPageWidget());
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPageWidget> {
  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['商城', '设备', '我的'];

  /*
   * 存放三个页面，跟fragmentList一样
   */
  var _pageList;


  @override
  void initState() {
    _loadCitys(context);
  }

  void _loadCitys(BuildContext context) async{
    SqlUtil.getInstance(context);
  }



  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Icon getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: barColor));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: const Color(0xff515151)));
    }
  }


  Icon getIcon(IconData iconData,bool isSelected) {
    if(isSelected){
      return Icon(iconData, size: 24,color: barColor,);
    }else{
      return Icon(iconData, size: 24,color: Colors.grey,);
    }
  }

  void initData() {
    /*
     * 初始化选中和未选中的icon
     */
    tabImages = [
      [getIcon(Icons.home,false), getIcon(Icons.home,true)],
      [getIcon(Icons.lock_outline,false), getIcon(Icons.lock_outline,true)],
      [getIcon(Icons.perm_identity,false), getIcon(Icons.perm_identity,true)]
    ];
    /*
     * 三个子界面
     */
    _pageList = [
//      new GirlPage(key: PageStorageKey<String>('girl'),random: false),
      new HomePage(),
      new DevicePage(),
      new MinePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //初始化数据
    initData();
    return Scaffold(
        body: _pageList[_tabIndex],
        bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0), title: getTabTitle(0)),
            new BottomNavigationBarItem(
                icon: getTabIcon(1), title: getTabTitle(1)),
            new BottomNavigationBarItem(
                icon: getTabIcon(2), title: getTabTitle(2)),
          ],
          type: BottomNavigationBarType.fixed,
          //默认选中首页
          currentIndex: _tabIndex,
          iconSize: 24.0,
          //点击事件
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ));
  }
}
